part of 'shopping_cart_bloc.dart';

@immutable
sealed class ShoppingCartEvent {}

final class AddItemToCart extends ShoppingCartEvent {
  final Results product;
  final String productColor;
  final bool delivered;

  AddItemToCart(
      {required this.product,
      required this.productColor,
      required this.delivered});
}

class GetCartItems extends ShoppingCartEvent {}

// update card

class UpdateCartItem extends ShoppingCartEvent {
  final String id;
  final int quantity;

  UpdateCartItem({required this.id, required this.quantity});
}

class ClearCart extends ShoppingCartEvent {}

class GetTotalAmount extends ShoppingCartEvent {}

// context.read<ShoppingCartBloc>().add(RemoveCartItem(id: cartItems[index]['id']));
class RemoveCartItem extends ShoppingCartEvent {
  final String id;

  RemoveCartItem({required this.id});
}
