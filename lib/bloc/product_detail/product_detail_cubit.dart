import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:order_payments/model/product_detail.dart';
import 'package:order_payments/repository/product_detail.dart';

part 'product_detail_state.dart';

class ProductDetailCubit extends Cubit<ProductDetailState> {
  final ProductDetailRepository _productDetailRepository;

  ProductDetailCubit(this._productDetailRepository) : super(ProductDetailInitialState());

  Future<void> fetchDetailProduct(int id) async {
    emit(ProductDetailLoadingState());
    try{
      final response = await _productDetailRepository.getDetail(id);
      emit(ProductDetailResponseState(response));
    }catch(e){
      emit(ProductDetailErrorState(e.toString()));
    }
  }
}
