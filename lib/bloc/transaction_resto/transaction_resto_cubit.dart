import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:order_payments/model/transaction_resto.dart';
import 'package:order_payments/repository/transaction_resto_repository.dart';

part 'transaction_resto_state.dart';

class TransactionRestoCubit extends Cubit<TransactionRestoState> {
  final TransactionRestoRepository _transactionRestoRepository;
  TransactionRestoCubit(this._transactionRestoRepository) : super(TransactionRestoInitState());
  Future <void> fetchTransactionResto (int page) async{
    if (state is TransactionRestoLoadingState) return;
    final currentState = state;
    var oldTransaction = <TransactionResto>[];
    if (currentState is TransactionRestoResponseState && page!=1) {
      oldTransaction = currentState.transactionResto;
    }
    emit(TransactionRestoLoadingState(oldTransaction, isFirstFetch: page == 1));

    _transactionRestoRepository.getAll(page).then((newTransaction) {
      final transactionRestos = (state as TransactionRestoLoadingState).oldTransaction;
      transactionRestos.addAll(newTransaction);

      emit(TransactionRestoResponseState(transactionRestos));
    });
  }
}
