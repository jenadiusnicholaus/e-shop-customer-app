part of 'product_bloc.dart';

@immutable
sealed class ProductState {}

final class ProductInitial extends ProductState {}

final class ProductsLoaded extends ProductState {
  final ProductModel products;
  ProductsLoaded({required this.products});
}

final class ProductsError extends ProductState {
  final String message;
  ProductsError({required this.message});
}
