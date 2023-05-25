import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:order_payments/model/enterprise_history.dart';
import 'package:order_payments/repository/enterprise_history_repository.dart';
import 'package:order_payments/ui/main_menu/umkm/history/history_enterprise.dart';
part 'enterprise_history_state.dart';


class EnterpriseHistoryCubit extends Cubit<EnterpriseHistoryState> {
  final EnterpriseHistoryRepository _enterpriseHistoryRepository;
  EnterpriseHistoryCubit(this._enterpriseHistoryRepository) : super(EnterpriseHistoryInitState());
  Future <void> fetchEnterpriseHistory (int page) async{
    if (state is EnterpriseHistoryLoadingState) return;
    final currentState = state;
    var oldTransaction = <EnterpriseHistory>[];
    if (currentState is EnterpriseHistoryResponseState && page!=1) {
      oldTransaction = currentState.entepriseHistory;
    }
    emit(EnterpriseHistoryLoadingState(oldTransaction, isFirstFetch: page == 1));

    _enterpriseHistoryRepository.getAll(page).then((newTransaction) {
      final enterpriseHistory = (state as EnterpriseHistoryLoadingState).oldEnterpriseHistory;
      enterpriseHistory.addAll(newTransaction);

      emit(EnterpriseHistoryResponseState(enterpriseHistory));
    });
  }
}