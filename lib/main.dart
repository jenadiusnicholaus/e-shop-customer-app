import 'package:eshop/features/checkout/bloc/checkout_bloc.dart';
import 'package:eshop/features/checkout/repository.dart';
import 'package:eshop/features/auth/login/bloc/login_bloc.dart';
import 'package:eshop/features/auth/login/login.dart';
import 'package:eshop/features/auth/repository.dart';
import 'package:eshop/features/products/bloc/product_bloc.dart';
import 'package:eshop/features/products/repository.dart';
import 'package:eshop/features/shopping_cart/bloc/shopping_cart_bloc.dart';
import 'package:eshop/features/shopping_cart/repository.dart';
import 'package:eshop/home_page.dart';
import 'package:eshop/shared/utils/auth_utils.dart';
import 'package:eshop/theming.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get_navigation/src/root/get_material_app.dart';

import 'features/checkout/checkout.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    name: 'cartopia',
    options: DefaultFirebaseOptions.currentPlatform,
  );

  String? token = await AuthUtils.getAuthToken();

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
        RepositoryProvider(
          create: (context) => AuthRepository(),
        ),
        RepositoryProvider(
          create: (context) => CheckoutRepository(),
        ),
      ],
      child: MultiBlocProvider(
          providers: [
            BlocProvider<ProductBloc>(
              create: (BuildContext context) => ProductBloc(
                repository: context.read<ProductRepository>(),
              ),
            ),
            BlocProvider<LoginBloc>(
              create: (BuildContext context) => LoginBloc(
                repository: context.read<AuthRepository>(),
              ),
            ),
            BlocProvider<ShoppingCartBloc>(
              create: (BuildContext context) => ShoppingCartBloc(
                repository: context.read<ShoppingCartRepo>(),
              ),
            ),
            BlocProvider<CheckoutBloc>(
              create: (BuildContext context) => CheckoutBloc(
                repository: context.read<CheckoutRepository>(),
              ),
            ),
          ],
          child: ScreenUtilInit(
              designSize: const Size(360, 690),
              minTextAdapt: true,
              splitScreenMode: true,
              // Use builder only if you need to use library outside ScreenUtilInit context
              builder: (context, child) {
                return GetMaterialApp(
                  supportedLocales: const <Locale>[
                    Locale('en', ''),
                    Locale('ar', ''),
                  ],
                  title: 'Cartopia',
                  debugShowCheckedModeBanner: false,
                  theme: CustomTheme.lightTheme,
                  darkTheme: CustomTheme.darkTheme,
                  themeMode:
                      isDarkModeEnabled ? ThemeMode.dark : ThemeMode.light,
                  home: widget.token != ''
                      ? const HomePage()
                      : const HomePage() /*LoginPage()*/,
                  routes: {
                    '/login': (context) => const LoginPage(),
                    '/home': (context) => const HomePage(),
                    '/checkout': (context) => const CheckoutPage(),
                    // '/registration': (context) => const Registration(),
                    // '/validate_account': (p0) => const ValidateAccount(),
                    // '/reset_password': (context) => const ResetPassWord(),
                    // '/confirm_reset_password': (context) =>
                    //     const ConfirmRestPassword(),
                    // '/user_profile': (context) => const UserProfile(),
                    // '/change_password': (context) => const ChangePasswordPage(),
                  },
                );
              })),
    );
  }
}
