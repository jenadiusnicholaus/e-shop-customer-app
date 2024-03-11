part of 'product_bloc.dart';

@immutable
sealed class ProductEvent {}

class FetchProducts extends ProductEvent {
  final int? pageNo;
  FetchProducts({this.pageNo});
}

class FetchProductDetails extends ProductEvent {
  final int? productId;
  FetchProductDetails({this.productId});
}
