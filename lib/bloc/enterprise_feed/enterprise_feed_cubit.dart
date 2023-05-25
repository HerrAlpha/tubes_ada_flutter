import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:order_payments/model/enterprise.dart';
import 'package:order_payments/repository/enterprise_feed_repository.dart';

part 'enterprise_feed_state.dart';

class EnterpriseFeedCubit extends Cubit<EnterpriseFeedState> {
  final EntepriseFeedRepository _entepriseFeedRepository;
  EnterpriseFeedCubit(this._entepriseFeedRepository) : super(EnterpriseFeedInitial());
  int page = 1;

  Future<void> fetchEnterprise(int page,String query) async {
    if (state is EnterpriseFeedLoadingState) return;

    final currentState = state;

    var oldData = <Enterprise>[];
    if (currentState is EnterpriseFeedResponseState && page != 1) {
      oldData = currentState.enterprise;
    }
    emit(EnterpriseFeedLoadingState(oldData, isFirstFetch: page == 1));

    _entepriseFeedRepository.getAll(page,query).then((newEnterpriseFeed) {

      final investments = (state as EnterpriseFeedLoadingState).oldEnterprise;
      investments.addAll(newEnterpriseFeed);

      emit(EnterpriseFeedResponseState(investments));
    });
  }
}
