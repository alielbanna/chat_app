import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:injectable/injectable.dart';
import '../../../../core/errors/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../entities/chat_entity.dart';
import '../repositories/chat_repository.dart';

@lazySingleton
class GetUserChatsUseCase implements StreamUseCase<List<ChatEntity>, GetUserChatsParams> {
  final ChatRepository repository;

  GetUserChatsUseCase(this.repository);

  @override
  Stream<Either<Failure, List<ChatEntity>>> call(GetUserChatsParams params) {
    return repository.getUserChats(params.userId);
  }
}

class GetUserChatsParams extends Equatable {
  final String userId;

  const GetUserChatsParams({required this.userId});

  @override
  List<Object> get props => [userId];
}