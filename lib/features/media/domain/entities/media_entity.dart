import 'package:equatable/equatable.dart';
import '../../data/models/media_model.dart';

class MediaEntity extends Equatable {
  final String id;
  final String url;
  final String fileName;
  final int fileSize;
  final MediaType type;
  final String? thumbnailUrl;
  final int? duration;
  final DateTime uploadedAt;

  const MediaEntity({
    required this.id,
    required this.url,
    required this.fileName,
    required this.fileSize,
    required this.type,
    this.thumbnailUrl,
    this.duration,
    required this.uploadedAt,
  });

  @override
  List<Object?> get props => [
    id,
    url,
    fileName,
    fileSize,
    type,
    thumbnailUrl,
    duration,
    uploadedAt,
  ];
}