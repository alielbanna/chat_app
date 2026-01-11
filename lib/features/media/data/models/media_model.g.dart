// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'media_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

MediaModel _$MediaModelFromJson(Map<String, dynamic> json) => MediaModel(
  id: json['id'] as String,
  url: json['url'] as String,
  fileName: json['fileName'] as String,
  fileSize: (json['fileSize'] as num).toInt(),
  type: $enumDecode(_$MediaTypeEnumMap, json['type']),
  thumbnailUrl: json['thumbnailUrl'] as String?,
  duration: (json['duration'] as num?)?.toInt(),
  uploadedAt: MediaModel._dateTimeFromTimestamp(json['uploadedAt']),
);

Map<String, dynamic> _$MediaModelToJson(MediaModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'url': instance.url,
      'fileName': instance.fileName,
      'fileSize': instance.fileSize,
      'type': _$MediaTypeEnumMap[instance.type]!,
      'thumbnailUrl': instance.thumbnailUrl,
      'duration': instance.duration,
      'uploadedAt': MediaModel._dateTimeToTimestamp(instance.uploadedAt),
    };

const _$MediaTypeEnumMap = {
  MediaType.image: 'image',
  MediaType.file: 'file',
  MediaType.voice: 'voice',
};
