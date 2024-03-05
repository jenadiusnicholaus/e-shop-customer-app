part of 'product_bloc.dart';

@immutable
sealed class ProductEvent {}

class FetchProducts extends ProductEvent {
  String? pageNo;
  FetchProducts({this.pageNo});
}
