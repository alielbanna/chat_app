import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:injectable/injectable.dart';
import '../../../../core/errors/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../entities/media_entity.dart';
import '../repositories/storage_repository.dart';

@lazySingleton
class UploadImageUseCase implements UseCase<MediaEntity, UploadImageParams> {
  final StorageRepository repository;

  UploadImageUseCase(this.repository);

  @override
  Future<Either<Failure, MediaEntity>> call(UploadImageParams params) async {
    return await repository.uploadImage(
      filePath: params.filePath,
      folder: params.folder,
      onProgress: params.onProgress,
    );
  }
}

class UploadImageParams extends Equatable {
  final String filePath;
  final String folder;
  final Function(double)? onProgress;

  const UploadImageParams({
    required this.filePath,
    required this.folder,
    this.onProgress,
  });

  @override
  List<Object?> get props => [filePath, folder];
}