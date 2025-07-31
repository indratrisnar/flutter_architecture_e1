part of 'auth_bloc.dart';

sealed class AuthState extends Equatable {
  const AuthState();

  @override
  List<Object> get props => [];
}

final class AuthInitial extends AuthState {
  const AuthInitial();
}

final class AuthLoading extends AuthState {
  const AuthLoading();
}

final class Authenticated extends AuthState {
  final UserModel user;
  final TokenModel token;

  const Authenticated({required this.user, required this.token});

  @override
  List<Object> get props => [user, token];
}

final class Unauthenticated extends AuthState {
  const Unauthenticated();
}

final class AuthRegisterSuccess extends AuthState {
  const AuthRegisterSuccess();
}

final class AuthFailed extends AuthState {
  final Failure failure;

  const AuthFailed({required this.failure});

  @override
  List<Object> get props => [failure];
}
