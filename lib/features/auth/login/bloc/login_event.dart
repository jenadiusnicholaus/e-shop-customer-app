part of 'login_bloc.dart';

@immutable
sealed class LoginEvent {}

class onLoginButtonPressed extends LoginEvent {
  final String email;
  final String password;

  onLoginButtonPressed({required this.email, required this.password});
}
