import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:order_payments/model/investment_history.dart';
import 'package:order_payments/repository/investment_history_repository.dart';

part 'investment_history_state.dart';

class InvestmentHistoryCubit extends Cubit<InvestmentHistoryState> {
  final InvestmentHistoryRepository _investmentHistoryRepository;
  InvestmentHistoryCubit(this._investmentHistoryRepository) : super(InvestmentHistoryInitState());
  Future <void> fetchInvestmentHistory (int page) async{
    if (state is InvestmentHistoryLoadingState) return;
    final currentState = state;
    var oldTransaction = <InvestmentHistory>[];
    if (currentState is InvestmentHistoryResponseState && page!=1) {
      oldTransaction = currentState.investmentHistory;
    }
    emit(InvestmentHistoryLoadingState(oldTransaction, isFirstFetch: page == 1));

    _investmentHistoryRepository.getAll(page).then((newTransaction) {
      final investmentHistory = (state as InvestmentHistoryLoadingState).oldInvestmentHistory;
      investmentHistory.addAll(newTransaction);

      emit(InvestmentHistoryResponseState(investmentHistory));
    });
  }
}

