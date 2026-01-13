import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import '../../../../core/usecases/usecase.dart';
import '../../../../core/utils/logger.dart';
import '../../domain/usecases/get_current_user_usecase.dart';
import '../../domain/usecases/reset_password_usecase.dart';
import '../../domain/usecases/sign_in_usecase.dart';
import '../../domain/usecases/sign_out_usecase.dart';
import '../../domain/usecases/sign_up_usecase.dart';
import 'auth_event.dart';
import 'auth_state.dart';

@injectable
class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final SignInUseCase signInUseCase;
  final SignUpUseCase signUpUseCase;
  final SignOutUseCase signOutUseCase;
  final GetCurrentUserUseCase getCurrentUserUseCase;
  final ResetPasswordUseCase resetPasswordUseCase;

  AuthBloc({
    required this.signInUseCase,
    required this.signUpUseCase,
    required this.signOutUseCase,
    required this.getCurrentUserUseCase,
    required this.resetPasswordUseCase,
  }) : super(const AuthInitial()) {
    on<AuthCheckRequested>(_onAuthCheckRequested);
    on<AuthSignInRequested>(_onSignInRequested);
    on<AuthSignUpRequested>(_onSignUpRequested);
    on<AuthSignOutRequested>(_onSignOutRequested);
    on<AuthResetPasswordRequested>(_onResetPasswordRequested);
  }

  Future<void> _onAuthCheckRequested(
      AuthCheckRequested event,
      Emitter<AuthState> emit,
      ) async {
    emit(const AuthLoading());

    final result = await getCurrentUserUseCase(NoParams());

    result.fold(
          (failure) {
        AppLogger.error('Auth check failed', failure.message);
        emit(const AuthUnauthenticated());
      },
          (user) {
        if (user != null) {
          AppLogger.info('User authenticated: ${user.email}');
          emit(AuthAuthenticated(user: user));
        } else {
          emit(const AuthUnauthenticated());
        }
      },
    );
  }

  Future<void> _onSignInRequested(
      AuthSignInRequested event,
      Emitter<AuthState> emit,
      ) async {
    emit(const AuthLoading());

    final result = await signInUseCase(
      SignInParams(email: event.email, password: event.password),
    );

    result.fold(
          (failure) {
        AppLogger.error('Sign in failed', failure.message);
        emit(AuthError(message: failure.message));
      },
          (user) {
        AppLogger.info('Sign in successful: ${user.email}');
        emit(AuthAuthenticated(user: user));
      },
    );
  }

  Future<void> _onSignUpRequested(
      AuthSignUpRequested event,
      Emitter<AuthState> emit,
      ) async {
    emit(const AuthLoading());

    final result = await signUpUseCase(
      SignUpParams(
        email: event.email,
        password: event.password,
        name: event.name,
      ),
    );

    result.fold(
          (failure) {
        AppLogger.error('Sign up failed', failure.message);
        emit(AuthError(message: failure.message));
      },
          (user) {
        AppLogger.info('Sign up successful: ${user.email}');
        emit(AuthAuthenticated(user: user));
      },
    );
  }

  Future<void> _onSignOutRequested(
      AuthSignOutRequested event,
      Emitter<AuthState> emit,
      ) async {
    emit(const AuthLoading());

    final result = await signOutUseCase(NoParams());

    result.fold(
          (failure) {
        AppLogger.error('Sign out failed', failure.message);
        emit(AuthError(message: failure.message));
      },
          (_) {
        AppLogger.info('Sign out successful');
        emit(const AuthUnauthenticated());
      },
    );
  }

  Future<void> _onResetPasswordRequested(
      AuthResetPasswordRequested event,
      Emitter<AuthState> emit,
      ) async {
    emit(const AuthLoading());

    final result = await resetPasswordUseCase(
      ResetPasswordParams(email: event.email),
    );

    result.fold(
          (failure) {
        AppLogger.error('Reset password failed', failure.message);
        emit(AuthError(message: failure.message));
      },
          (_) {
        AppLogger.info('Password reset email sent to: ${event.email}');
        emit(AuthPasswordResetSent(email: event.email));
      },
    );
  }
}