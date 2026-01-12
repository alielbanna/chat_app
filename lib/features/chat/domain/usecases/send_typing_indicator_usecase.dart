import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:injectable/injectable.dart';
import '../../../../core/errors/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../repositories/chat_repository.dart';

@lazySingleton
class SendTypingIndicatorUseCase implements UseCase<void, SendTypingIndicatorParams> {
  final ChatRepository repository;

  SendTypingIndicatorUseCase(this.repository);

  @override
  Future<Either<Failure, void>> call(SendTypingIndicatorParams params) async {
    return await repository.sendTypingIndicator(
      params.chatId,
      params.userId,
      params.userName,
      params.isTyping,
    );
  }
}

class SendTypingIndicatorParams extends Equatable {
  final String chatId;
  final String userId;
  final String userName;
  final bool isTyping;

  const SendTypingIndicatorParams({
    required this.chatId,
    required this.userId,
    required this.userName,
    required this.isTyping,
  });

  @override
  List<Object> get props => [chatId, userId, userName, isTyping];
}