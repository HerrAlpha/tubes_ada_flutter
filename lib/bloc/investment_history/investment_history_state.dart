part of 'investment_history_cubit.dart';

@immutable
abstract class InvestmentHistoryState {}
class InvestmentHistoryInitState extends InvestmentHistoryState {

}
class InvestmentHistoryLoadingState extends InvestmentHistoryState {
  final List<InvestmentHistory> oldInvestmentHistory;
  final bool isFirstFetch;

  InvestmentHistoryLoadingState(this.oldInvestmentHistory, {this.isFirstFetch = false});
}

class InvestmentHistoryErrorState extends InvestmentHistoryState {
  final String message;
  InvestmentHistoryErrorState(this.message);
}

class InvestmentHistoryResponseState extends InvestmentHistoryState {
  final List<InvestmentHistory> investmentHistory;
  InvestmentHistoryResponseState(this.investmentHistory);
}
