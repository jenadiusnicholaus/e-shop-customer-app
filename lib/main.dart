import 'package:eshop/features/auth/login/login.dart';
import 'package:eshop/features/products/bloc/product_bloc.dart';
import 'package:eshop/features/products/repository.dart';
import 'package:eshop/features/shopping_cart/bloc/shopping_cart_bloc.dart';
import 'package:eshop/features/shopping_cart/repository.dart';
import 'package:eshop/home_page.dart';
import 'package:eshop/theming.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

void main() async {
  String? token = 'jlll';
  runApp(MyApp(token: token));
}

class MyApp extends StatefulWidget {
  final String? token;
  const MyApp({super.key, this.token});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  bool isDarkModeEnabled = false;
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiRepositoryProvider(
      providers: [
        RepositoryProvider(
          create: (context) => ProductRepository(),
        ),
        RepositoryProvider(
          create: (context) => ShoppingCartRepo(),
        ),
      ],
      child: MultiBlocProvider(
          providers: [
            BlocProvider<ProductBloc>(
              create: (BuildContext context) => ProductBloc(
                repository: context.read<ProductRepository>(),
              ),
            ),
            BlocProvider<ShoppingCartBloc>(
              create: (BuildContext context) => ShoppingCartBloc(
                repository: context.read<ShoppingCartRepo>(),
              ),
            ),
          ],
          child: MaterialApp(
            title: 'Cartopia',
            debugShowCheckedModeBanner: false,
            theme: CustomTheme.lightTheme,
            darkTheme: CustomTheme.darkTheme,
            themeMode: isDarkModeEnabled ? ThemeMode.dark : ThemeMode.light,
            home: widget.token != '' ? const HomePage() : const LoginPage(),
          )),
    );
  }
}
