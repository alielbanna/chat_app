import 'package:json_annotation/json_annotation.dart';
import '../../domain/entities/media_entity.dart';

part 'media_model.g.dart';

enum MediaType { image, file, voice }

@JsonSerializable(explicitToJson: true)
class MediaModel {
  final String id;
  final String url;
  final String fileName;
  final int fileSize;
  final MediaType type;
  final String? thumbnailUrl;
  final int? duration; // For voice messages in seconds
  @JsonKey(fromJson: _dateTimeFromTimestamp, toJson: _dateTimeToTimestamp)
  final DateTime uploadedAt;

  const MediaModel({
    required this.id,
    required this.url,
    required this.fileName,
    required this.fileSize,
    required this.type,
    this.thumbnailUrl,
    this.duration,
    required this.uploadedAt,
  });

  factory MediaModel.fromJson(Map<String, dynamic> json) =>
      _$MediaModelFromJson(json);

  Map<String, dynamic> toJson() => _$MediaModelToJson(this);

  MediaEntity toEntity() => MediaEntity(
    id: id,
    url: url,
    fileName: fileName,
    fileSize: fileSize,
    type: type,
    thumbnailUrl: thumbnailUrl,
    duration: duration,
    uploadedAt: uploadedAt,
  );

  factory MediaModel.fromEntity(MediaEntity entity) => MediaModel(
    id: entity.id,
    url: entity.url,
    fileName: entity.fileName,
    fileSize: entity.fileSize,
    type: entity.type,
    thumbnailUrl: entity.thumbnailUrl,
    duration: entity.duration,
    uploadedAt: entity.uploadedAt,
  );

  static DateTime _dateTimeFromTimestamp(dynamic timestamp) {
    if (timestamp == null) return DateTime.now();
    if (timestamp is int) return DateTime.fromMillisecondsSinceEpoch(timestamp);
    if (timestamp is String) return DateTime.parse(timestamp);
    return DateTime.fromMillisecondsSinceEpoch(
        timestamp.seconds * 1000 + timestamp.nanoseconds ~/ 1000000);
  }

  static dynamic _dateTimeToTimestamp(DateTime dateTime) {
    return dateTime.toIso8601String();
  }
}