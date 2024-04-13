import 'dart:developer';

import 'package:bloc/bloc.dart';
import 'package:eshop/features/auth/repository.dart';
import 'package:eshop/shared/utils/secure_local_storage.dart';
import 'package:get/get.dart';
import 'package:get/route_manager.dart';
import 'package:meta/meta.dart';

part 'login_event.dart';
part 'login_state.dart';

class LoginBloc extends Bloc<LoginEvent, LoginState> {
  final AuthRepository? repository;
  LoginBloc({this.repository}) : super(LoginInitial()) {
    on<OnGoogeLoginButtonPressed>((event, emit) async {
      emit(LoginGoogleLoading());
      try {
        final googleRes =
            await repository!.loginWithGoogle(idToken: event.idToken);
        await SecureLocalStorage.writeValue("access_token", googleRes.access!);
        await SecureLocalStorage.writeValue(
            "refresh_token", googleRes.refresh!);

        Get.toNamed('/checkout');
        emit(LoginGoogleSuccess(message: googleRes.access!));
      } catch (e) {
        log(e.toString());
        emit(LoginGoogleFailure(error: e.toString()));
      }
    });
  }
}
