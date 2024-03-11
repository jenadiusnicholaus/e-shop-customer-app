import 'dart:developer';

import 'package:bloc/bloc.dart';
import 'package:eshop/features/shopping_cart/repository.dart';
import 'package:meta/meta.dart';

import '../../products/models/product_model.dart';

part 'shopping_cart_event.dart';
part 'shopping_cart_state.dart';

class ShoppingCartBloc extends Bloc<ShoppingCartEvent, ShoppingCartState> {
  final ShoppingCartRepo repository;
  ShoppingCartBloc({required this.repository}) : super(ShoppingCartInitial()) {
    on<ShoppingCartEvent>((event, emit) {
      // TODO: implement event handler
    });

    on<AddItemToCart>((event, emit) async {
      emit(ShoppingCartLoading());
      try {
        await repository.addItemToShoppingCart(product: event.product);
        emit(ProductAddedToCart());
      } catch (e) {
        emit(ShoppingCartError('Error adding item to cart'));
      }
    });

    on<GetCartItems>((event, emit) async {
      emit(ShoppingCartLoading());
      try {
        final cartItems = await repository.getCartItems();
        double totalAmount = 0;

        for (var item in cartItems) {
          totalAmount += item['product']['price'] * item['quantity'];
        }
        emit(
            ShoppingCartLoaded(cartItems: cartItems, totalAmount: totalAmount));
      } catch (e) {
        log(e.toString());
        emit(ShoppingCartError('Error loading cart items'));
      }
    });

    on<UpdateCartItem>((event, emit) async {
      emit(ShoppingCartLoading());
      try {
        repository.updateQuantity(event.id, event.quantity);

        add(GetCartItems());
      } catch (e) {
        emit(ShoppingCartError('Error updating item in cart'));
      }
    });

    on<ClearCart>((event, emit) async {
      emit(ShoppingCartLoading());

      try {
        await repository.clearCart();
        emit(CartCleared());
        add(GetCartItems());
      } catch (e) {
        emit(ShoppingCartError('Error clearing cart'));
      }
    });
  }
}
