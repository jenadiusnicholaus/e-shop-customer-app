import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'bloc/shopping_cart_bloc.dart';

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
                separatorBuilder: (context, index) => Divider(),
                itemBuilder: (context, index) {
                  return ListTile(
                    leading:
                        Image.network(cartItems[index]['product']['image']),
                    title: Text(cartItems[index]['product']['name']),
                    subtitle:
                        Text('${cartItems[index]['product']['price']} TZS'),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IconButton(
                          icon: Icon(Icons.remove),
                          onPressed: () {
                            int currentQuantity = cartItems[index]['quantity'];
                            if (currentQuantity > 1) {
                              // updateQuantity(
                              //     cartItems[index]['id'], currentQuantity - 1);
                              context
                                  .read<ShoppingCartBloc>()
                                  .add(UpdateCartItem(
                                    id: cartItems[index]['id'],
                                    quantity: currentQuantity - 1,
                                  ));
                            }
                          },
                        ),
                        Text('${cartItems[index]['quantity']}'),
                        IconButton(
                          icon: Icon(Icons.add),
                          onPressed: () {
                            int currentQuantity = cartItems[index]['quantity'];
                            // updateQuantity(
                            //     cartItems[index]['id'], currentQuantity + 1);
                            context.read<ShoppingCartBloc>().add(UpdateCartItem(
                                  id: cartItems[index]['id'],
                                  quantity: currentQuantity + 1,
                                ));
                          },
                        ),
                      ],
                    ),
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
                            showDialog(
                              context: context,
                              builder: (context) {
                                return AlertDialog(
                                  title: const Text('Confirm Purchase'),
                                  content: const Text(
                                      'Are you sure you want to purchase these items?'),
                                  actions: [
                                    TextButton(
                                      onPressed: () {
                                        context
                                            .read<ShoppingCartBloc>()
                                            .add(ClearCart());
                                        Navigator.pop(context);
                                      },
                                      child: const Text('Remove all',
                                          style: TextStyle(color: Colors.red)),
                                    ),
                                    TextButton(
                                      onPressed: () {
                                        Navigator.pop(context);
                                      },
                                      child: const Text('Cancel',
                                          style: TextStyle(color: Colors.red)),
                                    ),
                                    ElevatedButton(
                                      style: ElevatedButton.styleFrom(
                                          backgroundColor: Colors.green,
                                          shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(10),
                                          )),
                                      onPressed: () async {},
                                      child: const Text('Confirm'),
                                    ),
                                  ],
                                );
                              },
                            );
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
