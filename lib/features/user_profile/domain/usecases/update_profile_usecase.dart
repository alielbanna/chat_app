import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:injectable/injectable.dart';
import '../../../../core/errors/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../repositories/profile_repository.dart';

@lazySingleton
class UpdateProfileUseCase implements UseCase<void, UpdateProfileParams> {
  final ProfileRepository repository;

  UpdateProfileUseCase(this.repository);

  @override
  Future<Either<Failure, void>> call(UpdateProfileParams params) async {
    return await repository.updateProfile(
      userId: params.userId,
      name: params.name,
      phoneNumber: params.phoneNumber,
      bio: params.bio,
    );
  }
}

class UpdateProfileParams extends Equatable {
  final String userId;
  final String? name;
  final String? phoneNumber;
  final String? bio;

  const UpdateProfileParams({
    required this.userId,
    this.name,
    this.phoneNumber,
    this.bio,
  });

  @override
  List<Object?> get props => [userId, name, phoneNumber, bio];
}