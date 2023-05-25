part of 'investment_cubit.dart';

@immutable
abstract class InvestmentState {}

class InvestmentInitialState extends InvestmentState {

}

class InvestmentLoadingState extends InvestmentState {
  final List<Investment> oldInvestment;
  final bool isFirstFetch;
  final bool isSearch;

  InvestmentLoadingState(this.oldInvestment, {this.isFirstFetch = false,this.isSearch = false});
}

class InvestmentErrorState extends InvestmentState {
  final String message;
  InvestmentErrorState(this.message);
}

class InvestmentResponseState extends InvestmentState {
  final List<Investment> investment;

  InvestmentResponseState(this.investment);
}
