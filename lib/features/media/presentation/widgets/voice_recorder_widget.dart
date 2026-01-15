import 'dart:async';
import 'package:flutter/material.dart';
import 'package:record/record.dart';
import 'package:path_provider/path_provider.dart';
import '../../../../core/theme/app_colors.dart';

class VoiceRecorderWidget extends StatefulWidget {
  final Function(String path, int duration) onRecordingComplete;

  const VoiceRecorderWidget({
    super.key,
    required this.onRecordingComplete,
  });

  @override
  State<VoiceRecorderWidget> createState() => _VoiceRecorderWidgetState();
}

class _VoiceRecorderWidgetState extends State<VoiceRecorderWidget> {
  final AudioRecorder _recorder = AudioRecorder();
  bool _isRecording = false;
  int _recordDuration = 0;
  Timer? _timer;

  @override
  void dispose() {
    _timer?.cancel();
    _recorder.dispose();
    super.dispose();
  }

  Future<void> _startRecording() async {
    try {
      if (await _recorder.hasPermission()) {
        final dir = await getTemporaryDirectory();
        final path = '${dir.path}/voice_${DateTime.now().millisecondsSinceEpoch}.m4a';

        await _recorder.start(
          const RecordConfig(
            encoder: AudioEncoder.aacLc,
            bitRate: 128000,
            sampleRate: 44100,
          ),
          path: path,
        );

        setState(() {
          _isRecording = true;
          _recordDuration = 0;
        });

        _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
          setState(() {
            _recordDuration++;
          });
        });
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error starting recording: $e')),
      );
    }
  }

  Future<void> _stopRecording() async {
    try {
      final path = await _recorder.stop();
      _timer?.cancel();

      setState(() {
        _isRecording = false;
      });

      if (path != null) {
        widget.onRecordingComplete(path, _recordDuration);
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error stopping recording: $e')),
      );
    }
  }

  Future<void> _cancelRecording() async {
    await _recorder.stop();
    _timer?.cancel();

    setState(() {
      _isRecording = false;
      _recordDuration = 0;
    });
  }

  String _formatDuration(int seconds) {
    final minutes = seconds ~/ 60;
    final remainingSeconds = seconds % 60;
    return '${minutes.toString().padLeft(2, '0')}:${remainingSeconds.toString().padLeft(2, '0')}';
  }

  @override
  Widget build(BuildContext context) {
    if (!_isRecording) {
      return IconButton(
        icon: const Icon(Icons.mic, color: AppColors.primary),
        onPressed: _startRecording,
      );
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: AppColors.error.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(24),
      ),
      child: Row(
        children: [
          IconButton(
            icon: const Icon(Icons.delete, color: AppColors.error),
            onPressed: _cancelRecording,
          ),
          const SizedBox(width: 8),
          _buildWaveform(),
          const SizedBox(width: 8),
          Text(
            _formatDuration(_recordDuration),
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(width: 8),
          IconButton(
            icon: const Icon(Icons.send, color: AppColors.primary),
            onPressed: _stopRecording,
          ),
        ],
      ),
    );
  }

  Widget _buildWaveform() {
    return Expanded(
      child: SizedBox(
        height: 30,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: List.generate(
            20,
                (index) => AnimatedContainer(
              duration: const Duration(milliseconds: 300),
              width: 3,
              height: (10 + (index % 3) * 10).toDouble(),
              decoration: BoxDecoration(
                color: AppColors.error,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
          ),
        ),
      ),
    );
  }
}