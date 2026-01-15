import 'package:equatable/equatable.dart';

abstract class MediaEvent extends Equatable {
  const MediaEvent();

  @override
  List<Object?> get props => [];
}

class MediaImagePickRequested extends MediaEvent {
  const MediaImagePickRequested();
}

class MediaFilePickRequested extends MediaEvent {
  const MediaFilePickRequested();
}

class MediaImageUploadRequested extends MediaEvent {
  final String filePath;
  final String chatId;

  const MediaImageUploadRequested({
    required this.filePath,
    required this.chatId,
  });

  @override
  List<Object> get props => [filePath, chatId];
}

class MediaFileUploadRequested extends MediaEvent {
  final String filePath;
  final String chatId;

  const MediaFileUploadRequested({
    required this.filePath,
    required this.chatId,
  });

  @override
  List<Object> get props => [filePath, chatId];
}

class MediaVoiceUploadRequested extends MediaEvent {
  final String filePath;
  final int duration;
  final String chatId;

  const MediaVoiceUploadRequested({
    required this.filePath,
    required this.duration,
    required this.chatId,
  });

  @override
  List<Object> get props => [filePath, duration, chatId];
}