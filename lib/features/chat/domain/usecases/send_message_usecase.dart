import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:injectable/injectable.dart';
import '../../../../core/errors/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../entities/message_entity.dart';
import '../repositories/chat_repository.dart';

@lazySingleton
class SendMessageUseCase implements UseCase<void, SendMessageParams> {
  final ChatRepository repository;

  SendMessageUseCase(this.repository);

  @override
  Future<Either<Failure, void>> call(SendMessageParams params) async {
    return await repository.sendMessage(params.message);
  }
}

class SendMessageParams extends Equatable {
  final MessageEntity message;

  const SendMessageParams({required this.message});

  @override
  List<Object> get props => [message];
}