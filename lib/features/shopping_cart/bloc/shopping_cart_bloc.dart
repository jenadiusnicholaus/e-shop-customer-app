import 'package:bloc/bloc.dart';
import 'package:eshop/features/shopping_cart/repository.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
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
        await repository.addItemToShoppingCart(
            product: event.product,
            productColor: event.productColor,
            delivery: event.delivered);

        add(GetCartItems());
        Get.snackbar(
          'Success',
          "Item added to cart",
          colorText: Colors.black,
          snackPosition: SnackPosition.TOP,
        );
        emit(ProductAddedToCart());
      } catch (e, s) {
        emit(ShoppingCartError('Error adding item to cart'));
      }
    });

    on<GetCartItems>((event, emit) async {
      emit(ShoppingCartLoading());
      try {
        final cartItems = await repository.getCartItems();
        double totalAmount = 0;

        for (var item in cartItems) {
          Results product = Results.fromJson(item['product']);
          if (product.sellingPrice != null && item['quantity'] != null) {
            double price =
                product.discountPrice != null || product.discountPrice != 0
                    ? product.discountPrice!
                    : product.sellingPrice!;
            totalAmount += price * double.parse(item['quantity'].toString());
          }
        }
        emit(
            ShoppingCartLoaded(cartItems: cartItems, totalAmount: totalAmount));
      } catch (e) {
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

    on<RemoveCartItem>((event, emit) async {
      emit(ShoppingCartLoading());
      try {
        await repository.removeItem(event.id);
        add(GetCartItems());
      } catch (e) {
        emit(ShoppingCartError('Error removing item from cart'));
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
