import 'dart:developer';

import 'package:eshop/shared/widgets/custom_textform_field.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_sign_in/google_sign_in.dart';

import 'bloc/login_bloc.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final GlobalKey<FormState> _logformKey = GlobalKey<FormState>();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  bool googleSigningIn = false;

  Future<UserCredential> signInWithGoogle(context) async {
    setState(() {
      googleSigningIn = true;
    });
    // googleSigningIn = true;
    try {
      // Trigger the authentication flow
      final GoogleSignInAccount? googleUser = await GoogleSignIn(
        scopes: <String>[
          'email',
          // 'https://www.googleapis.com/auth/contacts.readonly',
        ],
      ).signIn();

      // Obtain the auth details from the request
      final GoogleSignInAuthentication? googleAuth =
          await googleUser?.authentication;

      // Create a new credential
      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth?.accessToken,
        idToken: googleAuth?.idToken,
      );

      BlocProvider.of<LoginBloc>(context)
          .add(OnGoogeLoginButtonPressed(idToken: credential.idToken!));

      log(credential.idToken.toString());

      // Once signed in, return the UserCredential
      return await FirebaseAuth.instance.signInWithCredential(credential);
    } catch (e) {
      log(e.toString());
      rethrow;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Stack(
      children: [
        Container(
          height: MediaQuery.of(context).size.height,
          width: MediaQuery.of(context).size.width,
          child: SafeArea(
              child: SingleChildScrollView(
            child: Form(
              key: _logformKey,
              child: Padding(
                padding: const EdgeInsets.all(12.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    // SizedBox(
                    //   height: 100,
                    //   child: Image.asset('assets/images/logo.png'),
                    // ),
                    // const SizedBox(
                    //   height: 20,
                    // ),
                    // CustomTextFormField(
                    //   controller: emailController,
                    //   hintText: 'Enter your email',
                    //   validator: (value) {
                    //     if (value!.isEmpty) {
                    //       return 'Please enter your email';
                    //     }
                    //     return null;
                    //   },

                    //   // ignore: avoid_print
                    // ),
                    // const SizedBox(
                    //   height: 20,
                    // ),
                    // CustomTextFormField(
                    //   controller: passwordController,
                    //   hintText: 'Enter your password',
                    //   obscureText: true,
                    //   validator: (value) {
                    //     if (value!.isEmpty) {
                    //       return 'Please enter your password';
                    //     }
                    //     return null;
                    //   },
                    // ),
                    // ElevatedButton(
                    //   onPressed: () {
                    //     if (_formKey.currentState!.validate()) {
                    //       ScaffoldMessenger.of(context).showSnackBar(
                    //           const SnackBar(content: Text('Processing Data')));
                    //     }
                    //   },
                    //   child: const Text('Login'),
                    // ),

                    // const SizedBox(
                    //   height: 20,
                    // ),

                    // TextButton(
                    //   onPressed: () {
                    //     Navigator.pushNamed(context, '/register');
                    //   },
                    //   child: const Text('Register'),
                    // ),

                    // TextButton(
                    //   onPressed: () {
                    //     Navigator.pushNamed(context, '/forgot-password');
                    //   },
                    //   child: const Text('Forgot Password'),
                    // ),

                    // ignore: avoid_print

                    // or connect with google

                    Center(
                      child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.red,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                              )),
                          onPressed: () {
                            signInWithGoogle(context);
                          },
                          child: const Text('Google',
                              style: TextStyle(color: Colors.white))),
                    ),
                  ],
                ),
              ),
            ),
          )),
        ),
        Positioned(
          child: BlocBuilder<LoginBloc, LoginState>(
            builder: (context, state) {
              if (state is LoginGoogleLoading) {
                return const Center(
                    child: CircularProgressIndicator(
                  strokeWidth: 1,
                ));
              }
              return Text('');
            },
          ),
        ),
      ],
    ));
  }
}
