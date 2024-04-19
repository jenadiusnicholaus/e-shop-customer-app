import 'package:eshop/features/products/models/product_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../features/shopping_cart/bloc/shopping_cart_bloc.dart';

class CartItem extends StatefulWidget {
  final Results? product;
  final dynamic cartItems;
  final Color? selectedColor;

  const CartItem(
      {super.key,
      required this.product,
      required this.cartItems,
      required this.selectedColor});

  @override
  State<CartItem> createState() => _CartItemState();
}

class _CartItemState extends State<CartItem>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Stack(
        children: [
          Image.network(widget.product?.image ?? '', width: 100, height: 100),
          Positioned(
            top: 0,
            right: 0,
            child: Container(
              width: 20, // Set this to your desired width
              height: 20, // Set this to your desired height
              decoration: BoxDecoration(
                color: widget.selectedColor,
                shape: BoxShape.circle,
              ),
            ),
          )
        ],
      ),
      title: Text(widget.product?.name ?? ''),
      subtitle: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
              'TZS ${widget.product?.discountPrice != null && widget.product?.discountPrice != 0 ? widget.product?.discountPrice : widget.product?.sellingPrice}',
              style: const TextStyle(color: Colors.red)),
          // ignore: prefer_is_empty
          if (widget.product?.productDeliveryInfos?.isNotEmpty == true &&
              widget.product?.productDeliveryInfos?.first.freeDelivery == true)
            const Text('Free Delivery',
                style: TextStyle(fontSize: 8, color: Colors.green))
          else
            const Text('', style: TextStyle(color: Colors.red, fontSize: 8)),
        ],
      ),
      trailing: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          IconButton(
            icon: Icon(Icons.remove),
            onPressed: () {
              int currentQuantity = widget.cartItems['quantity'];
              if (currentQuantity > 1) {
                context.read<ShoppingCartBloc>().add(UpdateCartItem(
                      id: widget.cartItems['id'],
                      quantity: currentQuantity - 1,
                    ));
              }
            },
          ),
          Text('${widget.cartItems['quantity']}'),
          IconButton(
            icon: Icon(Icons.add),
            onPressed: () {
              int currentQuantity = widget.cartItems['quantity'];
              // updateQuantity(
              //     cartItems[index]['id'], currentQuantity + 1);
              context.read<ShoppingCartBloc>().add(UpdateCartItem(
                    id: widget.cartItems['id'],
                    quantity: currentQuantity + 1,
                  ));
            },
          ),
        ],
      ),
    );
  }
}
