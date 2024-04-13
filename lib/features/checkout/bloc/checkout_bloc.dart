import 'dart:developer';

import 'package:bloc/bloc.dart';
import 'package:eshop/features/checkout/repository.dart';
import 'package:meta/meta.dart';

import '../models/contact_models.dart';

part 'checkout_event.dart';
part 'checkout_state.dart';

class CheckoutBloc extends Bloc<CheckoutEvent, CheckoutState> {
  final CheckoutRepository repository;
  CheckoutBloc({required this.repository}) : super(CheckoutInitial()) {
    on<CheckoutEvent>((event, emit) {});

    on<FetchContactInfos>((event, emit) async {
      emit(UserContactInfosLoading());
      try {
        final userContactInfos = await repository.getContactInfos();
        emit(UserContactInfosLoaded(userContactInfos: userContactInfos));
      } catch (e) {
        log(e.toString());
        emit(UserContactInfosError(error: 'Error loading user contact infos'));
      }
    });
  }
}
