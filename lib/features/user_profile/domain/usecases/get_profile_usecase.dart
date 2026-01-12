import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:injectable/injectable.dart';
import '../../../../core/errors/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../../../authentication/domain/entities/user_entity.dart';
import '../repositories/profile_repository.dart';

@lazySingleton
class GetProfileUseCase implements UseCase<UserEntity, GetProfileParams> {
  final ProfileRepository repository;

  GetProfileUseCase(this.repository);

  @override
  Future<Either<Failure, UserEntity>> call(GetProfileParams params) async {
    return await repository.getProfile(params.userId);
  }
}

class GetProfileParams extends Equatable {
  final String userId;

  const GetProfileParams({required this.userId});

  @override
  List<Object> get props => [userId];
}