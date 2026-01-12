import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:injectable/injectable.dart';
import '../../../../core/errors/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../repositories/chat_repository.dart';

@lazySingleton
class AddReactionUseCase implements UseCase<void, AddReactionParams> {
  final ChatRepository repository;

  AddReactionUseCase(this.repository);

  @override
  Future<Either<Failure, void>> call(AddReactionParams params) async {
    return await repository.addReaction(
      params.chatId,
      params.messageId,
      params.userId,
      params.emoji,
    );
  }
}

class AddReactionParams extends Equatable {
  final String chatId;
  final String messageId;
  final String userId;
  final String emoji;

  const AddReactionParams({
    required this.chatId,
    required this.messageId,
    required this.userId,
    required this.emoji,
  });

  @override
  List<Object> get props => [chatId, messageId, userId, emoji];
}