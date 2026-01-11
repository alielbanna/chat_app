import 'package:dartz/dartz.dart';
import '../../../../core/errors/failures.dart';
import '../entities/media_entity.dart';

abstract class StorageRepository {
  /// Upload image file
  Future<Either<Failure, MediaEntity>> uploadImage({
    required String filePath,
    required String folder,
    Function(double)? onProgress,
  });

  /// Upload any file
  Future<Either<Failure, MediaEntity>> uploadFile({
    required String filePath,
    required String folder,
    Function(double)? onProgress,
  });

  /// Upload voice message
  Future<Either<Failure, MediaEntity>> uploadVoice({
    required String filePath,
    required int duration,
    Function(double)? onProgress,
  });

  /// Delete file from storage
  Future<Either<Failure, void>> deleteFile(String fileUrl);

  /// Get download URL
  Future<Either<Failure, String>> getDownloadUrl(String filePath);
}