import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';
import '../../../../core/errors/exceptions.dart';
import '../../../../core/errors/failures.dart';
import '../../../../core/network/network_info.dart';
import '../../../../core/utils/logger.dart';
import '../../domain/entities/media_entity.dart';
import '../../domain/repositories/storage_repository.dart';
import '../datasources/storage_remote_datasource.dart';

@LazySingleton(as: StorageRepository)
class StorageRepositoryImpl implements StorageRepository {
  final StorageRemoteDataSource remoteDataSource;
  final NetworkInfo networkInfo;

  StorageRepositoryImpl({
    required this.remoteDataSource,
    required this.networkInfo,
  });

  @override
  Future<Either<Failure, MediaEntity>> uploadImage({
    required String filePath,
    required String folder,
    Function(double)? onProgress,
  }) async {
    try {
      if (!await networkInfo.isConnected) {
        return const Left(NetworkFailure());
      }

      final media = await remoteDataSource.uploadImage(
        filePath: filePath,
        folder: folder,
        onProgress: onProgress,
      );

      AppLogger.info('Image uploaded successfully: ${media.url}');
      return Right(media.toEntity());
    } on FileException catch (e) {
      AppLogger.error('Upload image error', e);
      return Left(FileFailure(e.message));
    } catch (e) {
      AppLogger.error('Upload image unexpected error', e);
      return Left(FileFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, MediaEntity>> uploadFile({
    required String filePath,
    required String folder,
    Function(double)? onProgress,
  }) async {
    try {
      if (!await networkInfo.isConnected) {
        return const Left(NetworkFailure());
      }

      final media = await remoteDataSource.uploadFile(
        filePath: filePath,
        folder: folder,
        onProgress: onProgress,
      );

      AppLogger.info('File uploaded successfully: ${media.url}');
      return Right(media.toEntity());
    } on FileException catch (e) {
      AppLogger.error('Upload file error', e);
      return Left(FileFailure(e.message));
    } catch (e) {
      AppLogger.error('Upload file unexpected error', e);
      return Left(FileFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, MediaEntity>> uploadVoice({
    required String filePath,
    required int duration,
    Function(double)? onProgress,
  }) async {
    try {
      if (!await networkInfo.isConnected) {
        return const Left(NetworkFailure());
      }

      final media = await remoteDataSource.uploadVoice(
        filePath: filePath,
        duration: duration,
        onProgress: onProgress,
      );

      AppLogger.info('Voice uploaded successfully: ${media.url}');
      return Right(media.toEntity());
    } on FileException catch (e) {
      AppLogger.error('Upload voice error', e);
      return Left(FileFailure(e.message));
    } catch (e) {
      AppLogger.error('Upload voice unexpected error', e);
      return Left(FileFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> deleteFile(String fileUrl) async {
    try {
      if (!await networkInfo.isConnected) {
        return const Left(NetworkFailure());
      }

      await remoteDataSource.deleteFile(fileUrl);
      AppLogger.info('File deleted successfully');
      return const Right(null);
    } on FileException catch (e) {
      AppLogger.error('Delete file error', e);
      return Left(FileFailure(e.message));
    } catch (e) {
      AppLogger.error('Delete file unexpected error', e);
      return Left(FileFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, String>> getDownloadUrl(String filePath) async {
    try {
      if (!await networkInfo.isConnected) {
        return const Left(NetworkFailure());
      }

      final url = await remoteDataSource.getDownloadUrl(filePath);
      return Right(url);
    } on FileException catch (e) {
      AppLogger.error('Get download URL error', e);
      return Left(FileFailure(e.message));
    } catch (e) {
      AppLogger.error('Get download URL unexpected error', e);
      return Left(FileFailure(e.toString()));
    }
  }
}