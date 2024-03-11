part of 'product_bloc.dart';

@immutable
sealed class ProductState {}

final class ProductInitial extends ProductState {}

final class ProductsLoading extends ProductState {}

final class ProductsLoaded extends ProductState {
  final ProductModel products;
  ProductsLoaded({required this.products});
}

final class ProductsError extends ProductState {
  final String message;
  ProductsError({required this.message});
}

final class ProductDetailsLoading extends ProductState {}

final class ProductDetailsLoaded extends ProductState {
  final ProductDetailsModel productDetails;
  ProductDetailsLoaded({required this.productDetails});
}

final class ProductDetailsError extends ProductState {
  final String message;
  ProductDetailsError({required this.message});
}
