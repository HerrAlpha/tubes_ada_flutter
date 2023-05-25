part of 'transaction_resto_cubit.dart';

@immutable
abstract class TransactionRestoState {}
class TransactionRestoInitState extends TransactionRestoState {

}
class TransactionRestoLoadingState extends TransactionRestoState {
  final List<TransactionResto> oldTransaction;
  final bool isFirstFetch;

  TransactionRestoLoadingState(this.oldTransaction, {this.isFirstFetch = false});
}

class TransactionRestoErrorState extends TransactionRestoState {
  final String message;
  TransactionRestoErrorState(this.message);
}

class TransactionRestoResponseState extends TransactionRestoState {
  final List<TransactionResto> transactionResto;

  TransactionRestoResponseState(this.transactionResto);
}
