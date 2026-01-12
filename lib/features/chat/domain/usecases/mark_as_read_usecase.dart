import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:injectable/injectable.dart';
import '../../../../core/errors/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../repositories/chat_repository.dart';

@lazySingleton
class MarkAsReadUseCase implements UseCase<void, MarkAsReadParams> {
  final ChatRepository repository;

  MarkAsReadUseCase(this.repository);

  @override
  Future<Either<Failure, void>> call(MarkAsReadParams params) async {
    return await repository.markAsRead(params.chatId, params.userId);
  }
}

class MarkAsReadParams extends Equatable {
  final String chatId;
  final String userId;

  const MarkAsReadParams({
    required this.chatId,
    required this.userId,
  });

  @override
  List<Object> get props => [chatId, userId];
}