import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:order_payments/model/investment.dart';
import 'package:order_payments/model/product.dart';
import 'package:order_payments/repository/investment_feed_repository.dart';

import '../../repository/product_feed_repository.dart';

part 'investment_state.dart';

class InvestmentCubit extends Cubit<InvestmentState> {
  final InvestmentRepository _investmentRepository;
  InvestmentCubit(this._investmentRepository) : super(InvestmentInitialState());
  int page = 1;

  Future<void> fetchInvestment(int page,String query) async {
    if (state is InvestmentLoadingState) return;

    final currentState = state;

    var oldInvestment = <Investment>[];
    if (currentState is InvestmentResponseState && page != 1) {
      oldInvestment = currentState.investment;
    }
    emit(InvestmentLoadingState(oldInvestment, isFirstFetch: page == 1));

    _investmentRepository.getAll(page,query).then((newInvestment) {

      final investments = (state as InvestmentLoadingState).oldInvestment;
      investments.addAll(newInvestment);

      emit(InvestmentResponseState(investments));
    });
  }
}
