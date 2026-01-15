import 'dart:async';
import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../media/presentation/widgets/image_picker_bottom_sheet.dart';
import '../../../media/presentation/widgets/voice_recorder_widget.dart';

class ChatInput extends StatefulWidget {
  final Function(String) onSendMessage;
  final Function(String imagePath) onSendImage;
  final Function(String filePath) onSendFile;
  final Function(String voicePath, int duration) onSendVoice;
  final Function(bool)? onTypingChanged;

  const ChatInput({
    super.key,
    required this.onSendMessage,
    required this.onSendImage,
    required this.onSendFile,
    required this.onSendVoice,
    this.onTypingChanged,
  });

  @override
  State<ChatInput> createState() => _ChatInputState();
}

class _ChatInputState extends State<ChatInput> {
  final TextEditingController _controller = TextEditingController();
  final FocusNode _focusNode = FocusNode();
  Timer? _typingTimer;
  bool _isTyping = false;
  bool _isRecording = false;

  @override
  void dispose() {
    _controller.dispose();
    _focusNode.dispose();
    _typingTimer?.cancel();
    super.dispose();
  }

  void _handleTextChanged(String text) {
    _typingTimer?.cancel();

    if (text.trim().isNotEmpty) {
      if (!_isTyping) {
        _isTyping = true;
        widget.onTypingChanged?.call(true);
      }

      _typingTimer = Timer(const Duration(seconds: 3), () {
        if (_isTyping) {
          _isTyping = false;
          widget.onTypingChanged?.call(false);
        }
      });
    } else {
      if (_isTyping) {
        _isTyping = false;
        widget.onTypingChanged?.call(false);
      }
    }
  }

  void _handleSend() {
    final text = _controller.text.trim();
    if (text.isEmpty) return;

    widget.onSendMessage(text);
    _controller.clear();

    if (_isTyping) {
      _isTyping = false;
      widget.onTypingChanged?.call(false);
    }
  }

  void _handleAttachment() {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (_) => SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: AppColors.gray300,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              const SizedBox(height: 24),
              const Text(
                'Share',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 24),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  _buildAttachmentOption(
                    icon: Icons.image,
                    label: 'Image',
                    color: Colors.purple,
                    onTap: () {
                      Navigator.pop(context);
                      ImagePickerBottomSheet.show(
                        context,
                        widget.onSendImage,
                      );
                    },
                  ),
                  _buildAttachmentOption(
                    icon: Icons.insert_drive_file,
                    label: 'File',
                    color: Colors.blue,
                    onTap: () async {
                      Navigator.pop(context);
                      final result = await FilePicker.platform.pickFiles();
                      if (result != null && result.files.isNotEmpty) {
                        final path = result.files.first.path;
                        if (path != null) {
                          widget.onSendFile(path);
                        }
                      }
                    },
                  ),
                ],
              ),
              const SizedBox(height: 16),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildAttachmentOption({
    required IconData icon,
    required String label,
    required Color color,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        width: 100,
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: color.withOpacity(0.1),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          children: [
            Icon(icon, size: 36, color: color),
            const SizedBox(height: 8),
            Text(
              label,
              style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w500),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
      decoration: BoxDecoration(
        color: AppColors.white,
        boxShadow: [
          BoxShadow(
            offset: const Offset(0, -2),
            blurRadius: 4,
            color: AppColors.black.withOpacity(0.05),
          ),
        ],
      ),
      child: SafeArea(
        child: Row(
          children: [
            IconButton(
              icon: const Icon(Icons.attach_file),
              onPressed: _handleAttachment,
              color: AppColors.gray600,
            ),
            Expanded(
              child: _isRecording
                  ? VoiceRecorderWidget(
                onRecordingComplete: (path, duration) {
                  setState(() => _isRecording = false);
                  widget.onSendVoice(path, duration);
                },
              )
                  : TextField(
                controller: _controller,
                focusNode: _focusNode,
                onChanged: _handleTextChanged,
                decoration: InputDecoration(
                  hintText: 'Type a message...',
                  hintStyle: const TextStyle(color: AppColors.gray500),
                  filled: true,
                  fillColor: AppColors.gray50,
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 10,
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(24),
                    borderSide: BorderSide.none,
                  ),
                ),
                textInputAction: TextInputAction.send,
                onSubmitted: (_) => _handleSend(),
                maxLines: null,
                textCapitalization: TextCapitalization.sentences,
              ),
            ),
            if (!_isRecording)
              IconButton(
                icon: Icon(
                  _controller.text.trim().isEmpty ? Icons.mic : Icons.send,
                  color: AppColors.primary,
                ),
                onPressed: () {
                  if (_controller.text.trim().isEmpty) {
                    setState(() => _isRecording = true);
                  } else {
                    _handleSend();
                  }
                },
              ),
          ],
        ),
      ),
    );
  }
}