import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../../../core/theme/app_colors.dart';
import '../../domain/entities/message_entity.dart';

class MessageBubble extends StatelessWidget {
  final MessageEntity message;
  final bool isMe;

  const MessageBubble({
    super.key,
    required this.message,
    required this.isMe,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        mainAxisAlignment: isMe ? MainAxisAlignment.end : MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          if (!isMe) ...[
            CircleAvatar(
              radius: 16,
              backgroundColor: AppColors.primary,
              child: Text(
                message.senderName[0].toUpperCase(),
                style: const TextStyle(
                  color: AppColors.white,
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            const SizedBox(width: 8),
          ],
          Flexible(
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
              decoration: BoxDecoration(
                color: isMe ? AppColors.primary : AppColors.gray100,
                borderRadius: BorderRadius.only(
                  topLeft: const Radius.circular(16),
                  topRight: const Radius.circular(16),
                  bottomLeft: Radius.circular(isMe ? 16 : 4),
                  bottomRight: Radius.circular(isMe ? 4 : 16),
                ),
              ),
              child: _buildContent(),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatusIcon(MessageStatus status) {
    IconData icon;
    Color color = AppColors.white.withValues(alpha:0.7);

    switch (status) {
      case MessageStatus.sending:
        icon = Icons.access_time;
        break;
      case MessageStatus.sent:
        icon = Icons.check;
        break;
      case MessageStatus.delivered:
        icon = Icons.done_all;
        break;
      case MessageStatus.read:
        icon = Icons.done_all;
        color = AppColors.secondary;
        break;
      case MessageStatus.failed:
        icon = Icons.error_outline;
        color = AppColors.error;
        break;
    }

    return Icon(icon, size: 14, color: color);
  }

  Widget _buildContent() {
    switch (message.type) {
      case MessageType.image:
        return _buildImageMessage();
      case MessageType.file:
        return _buildFileMessage();
      case MessageType.voice:
        return _buildVoiceMessage();
      case MessageType.text:
      default:
        return _buildTextMessage();
    }
  }

  Widget _buildImageMessage() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (!isMe && message.senderName.isNotEmpty)
          Padding(
            padding: const EdgeInsets.only(bottom: 4),
            child: Text(
              message.senderName,
              style: const TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.bold,
                color: AppColors.primary,
              ),
            ),
          ),
        ClipRRect(
          borderRadius: BorderRadius.circular(12),
          child: Image.network(
            message.fileUrl ?? '',
            width: 200,
            fit: BoxFit.cover,
            loadingBuilder: (context, child, progress) {
              if (progress == null) return child;
              return Container(
                width: 200,
                height: 200,
                color: AppColors.gray100,
                child: const Center(child: CircularProgressIndicator()),
              );
            },
            errorBuilder: (context, error, stack) {
              return Container(
                width: 200,
                height: 200,
                color: AppColors.gray100,
                child: const Icon(Icons.error),
              );
            },
          ),
        ),
        if (message.content.isNotEmpty) ...[
          const SizedBox(height: 4),
          Text(
            message.content,
            style: TextStyle(
              fontSize: 15,
              color: isMe ? AppColors.white : AppColors.gray900,
            ),
          ),
        ],
        const SizedBox(height: 4),
        _buildTimestamp(),
      ],
    );
  }

  Widget _buildFileMessage() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (!isMe && message.senderName.isNotEmpty)
          Padding(
            padding: const EdgeInsets.only(bottom: 4),
            child: Text(
              message.senderName,
              style: const TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.bold,
                color: AppColors.primary,
              ),
            ),
          ),
        Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: isMe ? AppColors.white.withValues(alpha: 0.2) : AppColors.gray200,
            borderRadius: BorderRadius.circular(8),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                Icons.insert_drive_file,
                color: isMe ? AppColors.white : AppColors.gray700,
              ),
              const SizedBox(width: 8),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    message.fileName ?? 'File',
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                      color: isMe ? AppColors.white : AppColors.gray900,
                    ),
                  ),
                  if (message.fileSize != null)
                    Text(
                      _formatFileSize(message.fileSize!),
                      style: TextStyle(
                        fontSize: 12,
                        color: isMe
                            ? AppColors.white.withValues(alpha: 0.7)
                            : AppColors.gray600,
                      ),
                    ),
                ],
              ),
            ],
          ),
        ),
        const SizedBox(height: 4),
        _buildTimestamp(),
      ],
    );
  }

  Widget _buildVoiceMessage() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (!isMe && message.senderName.isNotEmpty)
          Padding(
            padding: const EdgeInsets.only(bottom: 4),
            child: Text(
              message.senderName,
              style: const TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.bold,
                color: AppColors.primary,
              ),
            ),
          ),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          decoration: BoxDecoration(
            color: isMe ? AppColors.white.withValues(alpha: 0.2) : AppColors.gray200,
            borderRadius: BorderRadius.circular(24),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                Icons.play_arrow,
                color: isMe ? AppColors.white : AppColors.primary,
                size: 28,
              ),
              const SizedBox(width: 8),
              _buildWaveform(),
              const SizedBox(width: 8),
              Text(
                _formatDuration(message.fileSize ?? 0),
                style: TextStyle(
                  fontSize: 12,
                  color: isMe
                      ? AppColors.white.withValues(alpha: 0.9)
                      : AppColors.gray700,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 4),
        _buildTimestamp(),
      ],
    );
  }

  Widget _buildTextMessage() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (!isMe && message.senderName.isNotEmpty)
          Padding(
            padding: const EdgeInsets.only(bottom: 4),
            child: Text(
              message.senderName,
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.bold,
                color: isMe ? AppColors.white.withValues(alpha: 0.9) : AppColors.primary,
              ),
            ),
          ),
        Text(
          message.content,
          style: TextStyle(
            fontSize: 15,
            color: isMe ? AppColors.white : AppColors.gray900,
          ),
        ),
        const SizedBox(height: 4),
        _buildTimestamp(),
      ],
    );
  }

  Widget _buildWaveform() {
    return SizedBox(
      width: 80,
      height: 20,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: List.generate(
          12,
              (index) => Container(
            width: 2,
            height: (5 + (index % 3) * 5).toDouble(),
            decoration: BoxDecoration(
              color: isMe ? AppColors.white : AppColors.primary,
              borderRadius: BorderRadius.circular(1),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTimestamp() {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          DateFormat('HH:mm').format(message.timestamp),
          style: TextStyle(
            fontSize: 11,
            color: isMe
                ? AppColors.white.withValues(alpha: 0.7)
                : AppColors.gray600,
          ),
        ),
        if (isMe) ...[
          const SizedBox(width: 4),
          _buildStatusIcon(message.status),
        ],
      ],
    );
  }

  String _formatFileSize(int bytes) {
    if (bytes < 1024) return '$bytes B';
    if (bytes < 1024 * 1024) return '${(bytes / 1024).toStringAsFixed(1)} KB';
    return '${(bytes / (1024 * 1024)).toStringAsFixed(1)} MB';
  }

  String _formatDuration(int seconds) {
    final minutes = seconds ~/ 60;
    final remainingSeconds = seconds % 60;
    return '${minutes.toString().padLeft(2, '0')}:${remainingSeconds.toString().padLeft(2, '0')}';
  }
}