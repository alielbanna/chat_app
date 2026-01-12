import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:injectable/injectable.dart';
import '../../../../core/errors/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../entities/message_entity.dart';
import '../repositories/chat_repository.dart';

@lazySingleton
class GetMessagesUseCase implements StreamUseCase<List<MessageEntity>, GetMessagesParams> {
  final ChatRepository repository;

  GetMessagesUseCase(this.repository);

  @override
  Stream<Either<Failure, List<MessageEntity>>> call(GetMessagesParams params) {
    return repository.getMessages(params.chatId);
  }
}

class GetMessagesParams extends Equatable {
  final String chatId;

  const GetMessagesParams({required this.chatId});

  @override
  List<Object> get props => [chatId];
}