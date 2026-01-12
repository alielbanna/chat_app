import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:injectable/injectable.dart';
import '../../../../core/errors/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../repositories/chat_repository.dart';

@lazySingleton
class DeleteMessageUseCase implements UseCase<void, DeleteMessageParams> {
  final ChatRepository repository;

  DeleteMessageUseCase(this.repository);

  @override
  Future<Either<Failure, void>> call(DeleteMessageParams params) async {
    return await repository.deleteMessage(params.chatId, params.messageId);
  }
}

class DeleteMessageParams extends Equatable {
  final String chatId;
  final String messageId;

  const DeleteMessageParams({
    required this.chatId,
    required this.messageId,
  });

  @override
  List<Object> get props => [chatId, messageId];
}