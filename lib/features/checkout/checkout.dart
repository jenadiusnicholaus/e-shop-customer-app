import 'package:eshop/features/checkout/bloc/checkout_bloc.dart';
import 'package:eshop/features/auth/login/login.dart';
import 'package:eshop/shared/widgets/custom_textform_field.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../products/models/product_model.dart';
import '../shopping_cart/bloc/shopping_cart_bloc.dart';
import '../../shared/utils/auth_utils.dart';
import '../../shared/widgets/cart_item.dart';

class CheckoutPage extends StatefulWidget {
  const CheckoutPage({super.key});

  @override
  State<CheckoutPage> createState() => _CheckoutPageState();
}

class _CheckoutPageState extends State<CheckoutPage> {
  String? token;

  @override
  void initState() {
    super.initState();
    AuthUtils.getAuthToken().then((value) {
      setState(() {
        token = value;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return token != '' ? const ChecckOutWidget() : const LoginPage();
  }
}

class ChecckOutWidget extends StatefulWidget {
  const ChecckOutWidget({super.key});

  @override
  State<ChecckOutWidget> createState() => _ChecckOutWidgetState();
}

class _ChecckOutWidgetState extends State<ChecckOutWidget> {
  final GlobalKey<FormState> _cformKey = GlobalKey<FormState>();
  String? _selectedPaymentMethod;
  final _nameController = TextEditingController();
  final _cityController = TextEditingController();
  final _countryController = TextEditingController();
  final _phoneNumberController = TextEditingController();

  @override
  initState() {
    super.initState();
    context.read<ShoppingCartBloc>().add(GetCartItems());
    context.read<CheckoutBloc>().add(FetchContactInfos());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Cartopia Checkout'),
        ),
        body: SingleChildScrollView(
          child: SizedBox(
            height: MediaQuery.of(context).size.height,
            child: Column(
              children: [
                Container(
                  height: MediaQuery.of(context).size.height / 5.h,
                  child: BlocBuilder<ShoppingCartBloc, ShoppingCartState>(
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
                            Results product =
                                Results.fromJson(cartItems[index]['product']);
                            Color color = Color(int.parse(
                                'FF${cartItems[index]['productColor'].substring(1)}',
                                radix: 16));
                            return Dismissible(
                                key: Key(cartItems[index]['id'].toString()),
                                direction: DismissDirection.endToStart,
                                onDismissed: (direction) {
                                  context.read<ShoppingCartBloc>().add(
                                      RemoveCartItem(
                                          id: cartItems[index]['id']));
                                },
                                background: Container(
                                    color: Colors.red,
                                    child: const Icon(Icons.delete,
                                        color: Colors.white)),
                                child: CartItem(
                                  product: product,
                                  cartItems: cartItems[index],
                                  selectedColor: color,
                                ));
                          },
                        );
                      }
                      return Container();
                    },
                  ),
                ),
                BlocBuilder<CheckoutBloc, CheckoutState>(
                  builder: (context, state) {
                    if (state is UserContactInfosLoaded) {
                      return Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          Expanded(
                            child: RadioListTile<String>(
                              title: const Text("Use the current address"),
                              value: 'Use the current address',
                              groupValue: _selectedPaymentMethod,
                              onChanged: (String? value) {
                                setState(() {
                                  _selectedPaymentMethod = value;
                                  _nameController.text =
                                      state.userContactInfos.address!;
                                  _cityController.text =
                                      state.userContactInfos.city!;
                                  _countryController.text =
                                      state.userContactInfos.country!;
                                  _phoneNumberController.text =
                                      state.userContactInfos.phoneNumber!;
                                });
                              },
                            ),
                          ),
                        ],
                      );
                    }
                    return Container();
                  },
                ),
                Container(
                  // height: MediaQuery.of(context).size.height / 3.5,
                  padding: const EdgeInsets.all(8),
                  child: Form(
                    key: _cformKey,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        CustomTextFormField(
                          controller: _nameController,
                          hintText: 'address',
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter your address';
                            }
                            return null;
                          },
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        CustomTextFormField(
                          controller: _cityController,
                          hintText: 'city',
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter your city';
                            }
                            return null;
                          },
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        CustomTextFormField(
                          controller: _countryController,
                          hintText: 'Country',
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter your country';
                            }
                            return null;
                          },
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        CustomTextFormField(
                          controller: _phoneNumberController,
                          hintText: 'phone number',
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter your phone number';
                            }
                            return null;
                          },
                        ),
                      ],
                    ),
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Expanded(
                      child: RadioListTile<String>(
                        title: ClipRRect(
                          borderRadius: BorderRadius.circular(50),
                          child: Image.asset('assets/images/airte_money.jpeg',
                              fit: BoxFit.cover),
                        ),
                        value: 'Airte Money',
                        groupValue: _selectedPaymentMethod,
                        onChanged: (String? value) {
                          setState(() {
                            _selectedPaymentMethod = value;
                          });
                        },
                      ),
                    ),
                    Expanded(
                      child: RadioListTile<String>(
                        title: ClipRRect(
                          borderRadius: BorderRadius.circular(50),
                          child: Image.asset('assets/images/tigo_money.png',
                              fit: BoxFit.cover),
                        ),
                        value: 'Tigo Money',
                        groupValue: _selectedPaymentMethod,
                        onChanged: (String? value) {
                          setState(() {
                            _selectedPaymentMethod = value;
                          });
                        },
                      ),
                    ),
                    Expanded(
                      child: RadioListTile<String>(
                        title: ClipRRect(
                          borderRadius: BorderRadius.circular(100),
                          child: Image.asset('assets/images/mpsesa.jpg',
                              fit: BoxFit.cover),
                        ),
                        value: 'Mpesa',
                        groupValue: _selectedPaymentMethod,
                        onChanged: (String? value) {
                          setState(() {
                            _selectedPaymentMethod = value;
                          });
                        },
                      ),
                    ),
                  ],
                )
              ],
            ),
          ),
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
                              backgroundColor: Colors.green,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                              )),
                          onPressed: () {
                            if (_cformKey.currentState!.validate()) {
                              // submin
                            }
                          },
                          child: const Text('Confirm Purchase',
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
