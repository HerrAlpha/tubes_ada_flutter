part of 'enterprise_feed_cubit.dart';

@immutable
abstract class EnterpriseFeedState {}

class EnterpriseFeedInitial extends EnterpriseFeedState {}

class EnterpriseFeedLoadingState extends EnterpriseFeedState {
  final List<Enterprise> oldEnterprise;
  final bool isFirstFetch;
  final bool isSearch;

  EnterpriseFeedLoadingState(this.oldEnterprise, {this.isFirstFetch = false,this.isSearch = false});
}

class EnterpriseFeedErrorState extends EnterpriseFeedState {
  final String message;
  EnterpriseFeedErrorState(this.message);
}

class EnterpriseFeedResponseState extends EnterpriseFeedState {
  final List<Enterprise> enterprise;
  EnterpriseFeedResponseState(this.enterprise);
}