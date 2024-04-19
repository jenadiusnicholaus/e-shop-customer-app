import 'dart:developer';

import 'package:bloc/bloc.dart';
import 'package:eshop/features/products/models/product_model.dart';
import 'package:eshop/features/products/repository.dart';
import 'package:meta/meta.dart';

import '../models/prodict_details_model.dart';

part 'product_event.dart';
part 'product_state.dart';

class ProductBloc extends Bloc<ProductEvent, ProductState> {
  ProductRepository? repository;
  ProductBloc({this.repository}) : super(ProductInitial()) {
    on<ProductEvent>((event, emit) {});

    on<FetchProductDetails>((event, emit) async {
      emit(ProductsLoading());
      try {
        final products =
            await repository!.getProductDetails(event.productId.toString());
        emit(ProductDetailsLoaded(productDetails: products));
      } catch (e) {
        log(e.toString());
        emit(ProductDetailsError(message: e.toString()));
      }
    });
  }
}
