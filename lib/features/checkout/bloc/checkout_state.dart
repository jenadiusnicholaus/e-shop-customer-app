part of 'checkout_bloc.dart';

@immutable
sealed class CheckoutState {}

final class CheckoutInitial extends CheckoutState {}

final class UserContactInfosLoading extends CheckoutState {}

final class UserContactInfosLoaded extends CheckoutState {
  final ContactInfosModel userContactInfos;

  UserContactInfosLoaded({required this.userContactInfos});
}

final class UserContactInfosError extends CheckoutState {
  final String error;

  UserContactInfosError({required this.error});
}
