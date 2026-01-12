import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:injectable/injectable.dart';
import '../../../../core/errors/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../entities/media_entity.dart';
import '../repositories/storage_repository.dart';

@lazySingleton
class UploadFileUseCase implements UseCase<MediaEntity, UploadFileParams> {
  final StorageRepository repository;

  UploadFileUseCase(this.repository);

  @override
  Future<Either<Failure, MediaEntity>> call(UploadFileParams params) async {
    return await repository.uploadFile(
      filePath: params.filePath,
      folder: params.folder,
      onProgress: params.onProgress,
    );
  }
}

class UploadFileParams extends Equatable {
  final String filePath;
  final String folder;
  final Function(double)? onProgress;

  const UploadFileParams({
    required this.filePath,
    required this.folder,
    this.onProgress,
  });

  @override
  List<Object?> get props => [filePath, folder];
}