part of 'product_cubit.dart';

@immutable
abstract class ProductState {}

class ProductInitialState extends ProductState {

}

class ProductLoadingState extends ProductState {
  final List<Products> oldProduct;
  final bool isFirstFetch;
  final bool isSearch;

  ProductLoadingState(this.oldProduct, {this.isFirstFetch = false,this.isSearch = false});
}

class ProductErrorState extends ProductState {
  final String message;
  ProductErrorState(this.message);
}

class ProductResponseState extends ProductState {
  final List<Products> product;

  ProductResponseState(this.product);
}
