part of 'shopping_cart_bloc.dart';

@immutable
sealed class ShoppingCartState {}

final class ShoppingCartInitial extends ShoppingCartState {}

final class ProductAddedToCart extends ShoppingCartState {}

final class ShoppingCartLoading extends ShoppingCartState {}

final class ShoppingCartLoaded extends ShoppingCartState {
  final List<Map<String, dynamic>> cartItems;
  final double totalAmount;

  ShoppingCartLoaded({required this.cartItems, required this.totalAmount});
}

final class ShoppingCartError extends ShoppingCartState {
  final String message;

  ShoppingCartError(this.message);
}

final class ShoppingCartUpdated extends ShoppingCartState {
  final List<Map<String, dynamic>> cartItems;

  ShoppingCartUpdated(this.cartItems);
}

final class CartCleared extends ShoppingCartState {}
