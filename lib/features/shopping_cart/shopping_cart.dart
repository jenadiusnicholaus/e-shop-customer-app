import 'package:eshop/features/checkout/checkout.dart';
import 'package:eshop/features/products/models/product_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../shared/environments/navigationn_state.dart';
import 'bloc/shopping_cart_bloc.dart';
import '../../shared/widgets/cart_item.dart';

class ShoppingCartPage extends StatefulWidget {
  ShoppingCartPage({
    Key? key,
  }) : super(key: key);

  @override
  _ShoppingCartPageState createState() => _ShoppingCartPageState();
}

class _ShoppingCartPageState extends State<ShoppingCartPage> {
  @override
  void initState() {
    super.initState();
    context.read<ShoppingCartBloc>().add(GetCartItems());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('Shopping Cart'),
        ),
        body: BlocBuilder<ShoppingCartBloc, ShoppingCartState>(
          builder: (context, state) {
            if (state is ShoppingCartLoading) {
              return const Center(child: CircularProgressIndicator());
            } else if (state is ShoppingCartError) {
              return Center(child: Text('Error: ${state.message}'));
            } else if (state is ShoppingCartLoaded) {
              final cartItems = state.cartItems;
              return ListView.separated(
                itemCount: cartItems.length,
                separatorBuilder: (context, index) => const Divider(),
                itemBuilder: (context, index) {
                  Results product =
                      Results.fromJson(cartItems[index]['product']);
                  Color color = Color(int.parse(
                      'FF${cartItems[index]['productColor'].substring(1)}',
                      radix: 16));
                  return CartItem(
                    product: product,
                    cartItems: cartItems[index],
                    selectedColor: color,
                  );
                },
              );
            }
            return Container();
          },
        ),
        bottomNavigationBar: BlocBuilder<ShoppingCartBloc, ShoppingCartState>(
          builder: (context, state) {
            if (state is ShoppingCartLoaded) {
              final totalAmount = state.totalAmount;
              return BottomAppBar(
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('Total: $totalAmount TZS'),
                      SizedBox(
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.black,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                              )),
                          onPressed: () {
                            NavigationState.checkoutpage;
                            // Navigator.push(
                            //     context,
                            //     MaterialPageRoute(
                            //         builder: (context) => const LoginPage()));

                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) =>
                                        const CheckoutPage()));
                          },
                          child: const Text('Purchase',
                              style: TextStyle(color: Colors.white)),
                        ),
                      ),
                    ],
                  ),
                ),
              );
            }
            return Container();
          },
        )

        // ...
        );
  }
}
