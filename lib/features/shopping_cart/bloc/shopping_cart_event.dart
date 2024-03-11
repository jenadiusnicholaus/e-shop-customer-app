part of 'shopping_cart_bloc.dart';

@immutable
sealed class ShoppingCartEvent {}

final class AddItemToCart extends ShoppingCartEvent {
  final Results product;

  AddItemToCart({required this.product});
}

class GetCartItems extends ShoppingCartEvent {}

class RemoveItemFromCart extends ShoppingCartEvent {
  final Results product;

  RemoveItemFromCart({required this.product});
}

// update card

class UpdateCartItem extends ShoppingCartEvent {
  final String id;
  final int quantity;

  UpdateCartItem({required this.id, required this.quantity});
}

class ClearCart extends ShoppingCartEvent {}

class GetTotalAmount extends ShoppingCartEvent {}
