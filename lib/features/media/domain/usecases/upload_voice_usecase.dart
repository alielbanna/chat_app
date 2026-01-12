import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:injectable/injectable.dart';
import '../../../../core/errors/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../entities/media_entity.dart';
import '../repositories/storage_repository.dart';

@lazySingleton
class UploadVoiceUseCase implements UseCase<MediaEntity, UploadVoiceParams> {
  final StorageRepository repository;

  UploadVoiceUseCase(this.repository);

  @override
  Future<Either<Failure, MediaEntity>> call(UploadVoiceParams params) async {
    return await repository.uploadVoice(
      filePath: params.filePath,
      duration: params.duration,
      onProgress: params.onProgress,
    );
  }
}

class UploadVoiceParams extends Equatable {
  final String filePath;
  final int duration;
  final Function(double)? onProgress;

  const UploadVoiceParams({
    required this.filePath,
    required this.duration,
    this.onProgress,
  });

  @override
  List<Object?> get props => [filePath, duration];
}