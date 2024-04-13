part of 'checkout_bloc.dart';

@immutable
sealed class CheckoutEvent {}

class FetchContactInfos extends CheckoutEvent {}

class CheckoutButtonPressed extends CheckoutEvent {
  final String address;
  final String city;
  final String state;
  final String zip;
  final String country;
  final String phone;
  final String email;
  final String paymentMethod;
  final String cardNumber;
  final String cardExpiry;
  final String cardCVC;

  CheckoutButtonPressed({
    required this.address,
    required this.city,
    required this.state,
    required this.zip,
    required this.country,
    required this.phone,
    required this.email,
    required this.paymentMethod,
    required this.cardNumber,
    required this.cardExpiry,
    required this.cardCVC,
  });
}
