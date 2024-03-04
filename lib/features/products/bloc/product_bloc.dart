import 'dart:developer';

import 'package:bloc/bloc.dart';
import 'package:eshop/features/products/models.dart';
import 'package:eshop/features/products/repository.dart';
import 'package:meta/meta.dart';

part 'product_event.dart';
part 'product_state.dart';

class ProductBloc extends Bloc<ProductEvent, ProductState> {
  ProductRepository? repository;
  ProductBloc({this.repository}) : super(ProductInitial()) {
    on<ProductEvent>((event, emit) {});

    on<FetchProducts>((event, emit) async {
      try {
        final products = await repository!.fetchProducts();
        emit(ProductsLoaded(products: products));
      } catch (e, s) {
        log(e.toString());
        print(s);
        emit(ProductsError(message: e.toString()));
      }
    });
  }
}
