import 'dart:convert';

import 'package:eshop/features/products/models/product_model.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:uuid/uuid.dart';

class ShoppingCartRepo {
  Future<List<Map<String, dynamic>>> getCartItems() async {
    final prefs = await SharedPreferences.getInstance();
    List<String>? cartItems = prefs.getStringList('cartItems');
    if (cartItems == null) {
      return [];
    }
    return cartItems
        .map((item) => jsonDecode(item) as Map<String, dynamic>)
        .toList();
  }

  Future<void> addItemToShoppingCart(
      {Results? product, String? productColor, delivery}) async {
    final prefs = await SharedPreferences.getInstance();
    List<String> cartItems = prefs.getStringList('cartItems') ?? [];

    // Check if the product is already in the cart
    int index = cartItems.indexWhere((item) {
      Map<String, dynamic> decodedItem = jsonDecode(item);

      return decodedItem['product']['id'] == product?.id;
    });

    if (index != -1) {
      // If the product is already in the cart, update the quantity
      Map<String, dynamic> decodedItem = jsonDecode(cartItems[index]);
      decodedItem['quantity'] += 1;
      if (productColor != null) {
        decodedItem['productColor'] = productColor;
        decodedItem['delivered'] = delivery;
      }
      cartItems[index] = jsonEncode(decodedItem);
    } else {
      // If the product is not in the cart, add it
      cartItems.add(jsonEncode({
        'id': Uuid().v4(),
        'product': product?.toJson(),
        'productColor': productColor,
        'quantity': 1,
        'delivered': delivery,
      }));
    }

    await prefs.setStringList('cartItems', cartItems);
  }

  void updateQuantity(String id, int quantity) async {
    final prefs = await SharedPreferences.getInstance();
    List<String> cartItemsString = prefs.getStringList('cartItems') ?? [];
    List<Map<String, dynamic>> cartItems = cartItemsString
        .map((item) => jsonDecode(item) as Map<String, dynamic>)
        .toList();

    int index = cartItems.indexWhere((item) => item['id'] == id);
    if (index != -1) {
      cartItems[index]['quantity'] = quantity;
      await prefs.setStringList(
          'cartItems', cartItems.map((item) => jsonEncode(item)).toList());
    }
  }

  Future<void> removeItem(String id) async {
    final prefs = await SharedPreferences.getInstance();
    List<String> cartItemsString = prefs.getStringList('cartItems') ?? [];
    List<Map<String, dynamic>> cartItems = cartItemsString
        .map((item) => jsonDecode(item) as Map<String, dynamic>)
        .toList();

    cartItems.removeWhere((item) => item['id'] == id);
    await prefs.setStringList(
        'cartItems', cartItems.map((item) => jsonEncode(item)).toList());
  }

  Future<void> clearCart() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('cartItems');
  }
}
