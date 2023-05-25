part of 'enterprise_history_cubit.dart';

@immutable
abstract class EnterpriseHistoryState {}

class EnterpriseHistoryInitState extends EnterpriseHistoryState {}
class EnterpriseHistoryLoadingState extends EnterpriseHistoryState {
  final List<EnterpriseHistory> oldEnterpriseHistory;
  final bool isFirstFetch;

  EnterpriseHistoryLoadingState(this.oldEnterpriseHistory, {this.isFirstFetch = false});
}

class EnterpriseHistoryErrorState extends EnterpriseHistoryState {
  final String message;
  EnterpriseHistoryErrorState(this.message);
}

class EnterpriseHistoryResponseState extends EnterpriseHistoryState {
  final List<EnterpriseHistory> entepriseHistory;
  EnterpriseHistoryResponseState(this.entepriseHistory);
}

