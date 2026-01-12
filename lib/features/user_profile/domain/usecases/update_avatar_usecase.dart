import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:injectable/injectable.dart';
import '../../../../core/errors/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../repositories/profile_repository.dart';

@lazySingleton
class UpdateAvatarUseCase implements UseCase<String, UpdateAvatarParams> {
  final ProfileRepository repository;

  UpdateAvatarUseCase(this.repository);

  @override
  Future<Either<Failure, String>> call(UpdateAvatarParams params) async {
    return await repository.updateAvatar(
      userId: params.userId,
      imagePath: params.imagePath,
    );
  }
}

class UpdateAvatarParams extends Equatable {
  final String userId;
  final String imagePath;

  const UpdateAvatarParams({
    required this.userId,
    required this.imagePath,
  });

  @override
  List<Object> get props => [userId, imagePath];
}