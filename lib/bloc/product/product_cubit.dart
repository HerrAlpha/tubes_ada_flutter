import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:order_payments/model/product.dart';

import '../../repository/product_feed_repository.dart';

part 'product_state.dart';

class ProductCubit extends Cubit<ProductState> {
  final ProductRepository _productRepository;
  ProductCubit(this._productRepository) : super(ProductInitialState());
  int page = 1;

  Future<void> fetchProduct(int page,String query) async {
    if (state is ProductLoadingState) return;

    final currentState = state;

    var oldProduct = <Products>[];
    if (currentState is ProductResponseState && page != 1) {
      oldProduct = currentState.product;
    }
    emit(ProductLoadingState(oldProduct, isFirstFetch: page == 1));

    _productRepository.getAll(page,query).then((newProduct) {

      final products = (state as ProductLoadingState).oldProduct;
      products.addAll(newProduct);

      emit(ProductResponseState(products));
    });
  }
}
