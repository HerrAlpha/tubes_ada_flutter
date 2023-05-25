part of 'product_detail_cubit.dart';

@immutable
abstract class ProductDetailState {}

class ProductDetailInitialState extends ProductDetailState {

}

class ProductDetailLoadingState extends ProductDetailState {

}

class ProductDetailErrorState extends ProductDetailState {
  final String message;
  ProductDetailErrorState(this.message);
}

class ProductDetailResponseState extends ProductDetailState {
  final ProductDetail product;
  ProductDetailResponseState(this.product);
}