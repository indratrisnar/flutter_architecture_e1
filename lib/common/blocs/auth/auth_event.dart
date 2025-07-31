part of 'auth_bloc.dart';

sealed class AuthEvent extends Equatable {
  const AuthEvent();

  @override
  List<Object> get props => [];
}

final class AuthLoginRequestedEvent extends AuthEvent {
  final String email;
  final String password;

  const AuthLoginRequestedEvent({required this.email, required this.password});

  @override
  List<Object> get props => [email, password];
}

final class AuthRegisterRequestedEvent extends AuthEvent {
  final String name;
  final String email;
  final String password;

  const AuthRegisterRequestedEvent({
    required this.name,
    required this.email,
    required this.password,
  });

  @override
  List<Object> get props => [name, email, password];
}

final class AuthLogoutRequestedEvent extends AuthEvent {
  const AuthLogoutRequestedEvent();
}

final class AuthStatusCheckedEvent extends AuthEvent {
  const AuthStatusCheckedEvent();
}
