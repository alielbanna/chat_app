import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:injectable/injectable.dart';
import '../../../../core/errors/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../repositories/chat_repository.dart';

@lazySingleton
class GetOrCreateChatUseCase implements UseCase<String, GetOrCreateChatParams> {
  final ChatRepository repository;

  GetOrCreateChatUseCase(this.repository);

  @override
  Future<Either<Failure, String>> call(GetOrCreateChatParams params) async {
    return await repository.getOrCreateChat(params.userId1, params.userId2);
  }
}

class GetOrCreateChatParams extends Equatable {
  final String userId1;
  final String userId2;

  const GetOrCreateChatParams({
    required this.userId1,
    required this.userId2,
  });

  @override
  List<Object> get props => [userId1, userId2];
}