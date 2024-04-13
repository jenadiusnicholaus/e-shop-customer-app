part of 'login_bloc.dart';

@immutable
sealed class LoginState {}

final class LoginInitial extends LoginState {}

final class LoginLoading extends LoginState {}

final class LoginSuccess extends LoginState {
  final String token;

  LoginSuccess({required this.token});
}

final class LoginFailure extends LoginState {
  final String error;

  LoginFailure({required this.error});
}

final class LoginError extends LoginState {
  final String error;

  LoginError({required this.error});
}

// ============== google login ==============
final class LoginGoogleLoading extends LoginState {}

final class LoginGoogleSuccess extends LoginState {
  final String message;
  LoginGoogleSuccess({required this.message});
}

final class LoginGoogleFailure extends LoginState {
  final String error;

  LoginGoogleFailure({required this.error});
}
