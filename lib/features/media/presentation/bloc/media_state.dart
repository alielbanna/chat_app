import 'package:equatable/equatable.dart';
import '../../domain/entities/media_entity.dart';

abstract class MediaState extends Equatable {
  const MediaState();

  @override
  List<Object?> get props => [];
}

class MediaInitial extends MediaState {
  const MediaInitial();
}

class MediaPicking extends MediaState {
  const MediaPicking();
}

class MediaUploading extends MediaState {
  final double progress;

  const MediaUploading({required this.progress});

  @override
  List<Object> get props => [progress];
}

class MediaUploadSuccess extends MediaState {
  final MediaEntity media;

  const MediaUploadSuccess({required this.media});

  @override
  List<Object> get props => [media];
}

class MediaError extends MediaState {
  final String message;

  const MediaError({required this.message});

  @override
  List<Object> get props => [message];
}