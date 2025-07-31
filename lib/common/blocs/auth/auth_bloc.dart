import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_architecture_e1/core/errors/failures.dart';
import 'package:flutter_architecture_e1/data/models/token_model.dart';
import 'package:flutter_architecture_e1/data/models/user_model.dart';
import 'package:flutter_architecture_e1/data/repositories/auth_repository.dart';

part 'auth_event.dart';
part 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final AuthRepository _authRepository;

  AuthBloc({required AuthRepository authRepository})
    : _authRepository = authRepository,
      super(const AuthInitial()) {
    on<AuthLoginRequestedEvent>(_onLoginRequested);
    on<AuthRegisterRequestedEvent>(_onRegisterRequested);
    on<AuthLogoutRequestedEvent>(_onLogoutRequested);
    on<AuthStatusCheckedEvent>(_onAuthStatusChecked);
  }

  Future<void> _onLoginRequested(
    AuthLoginRequestedEvent event,
    Emitter<AuthState> emit,
  ) async {
    emit(const AuthLoading());
    final result = await _authRepository.login(event.email, event.password);
    result.fold(
      (failure) => emit(AuthFailed(failure: failure)),
      (data) => emit(Authenticated(user: data.$1, token: data.$2)),
    );
  }

  Future<void> _onRegisterRequested(
    AuthRegisterRequestedEvent event,
    Emitter<AuthState> emit,
  ) async {
    emit(const AuthLoading());
    final result = await _authRepository.register(
      event.name,
      event.email,
      event.password,
    );
    result.fold(
      (failure) => emit(AuthFailed(failure: failure)),
      (userModel) => emit(const AuthRegisterSuccess()),
    );
  }

  Future<void> _onLogoutRequested(
    AuthLogoutRequestedEvent event,
    Emitter<AuthState> emit,
  ) async {
    emit(const AuthLoading());
    final result = await _authRepository.logout();
    result.fold(
      (failure) => emit(AuthFailed(failure: failure)),
      (_) => emit(const Unauthenticated()),
    );
  }

  Future<void> _onAuthStatusChecked(
    AuthStatusCheckedEvent event,
    Emitter<AuthState> emit,
  ) async {
    emit(const AuthLoading());
    final result = await _authRepository.getCachedAuthData();
    result.fold(
      (failure) => add(const AuthLogoutRequestedEvent()),
      (data) => emit(Authenticated(user: data.$1, token: data.$2)),
    );
  }
}
