import 'package:dartz/dartz.dart';
import '../errors/failures.dart';

/// Base UseCase for operations that return a value
abstract class UseCase<T, Params> {
  Future<Either<Failure, T>> call(Params params);
}

/// Base UseCase for streaming operations
abstract class StreamUseCase<T, Params> {
  Stream<Either<Failure, T>> call(Params params);
}

/// Used when no parameters are needed
class NoParams {
  const NoParams();
}