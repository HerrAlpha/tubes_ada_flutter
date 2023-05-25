import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:order_payments/bloc/enterprise_history/enterprise_history_cubit.dart';
import 'package:order_payments/bloc/investment_history/investment_history_cubit.dart';
import 'package:order_payments/bloc/transaction_resto/transaction_resto_cubit.dart';
import 'package:order_payments/core/text_style.dart';
import 'package:order_payments/model/enterprise_history.dart';
import 'package:order_payments/model/investment_history.dart';
import 'package:order_payments/model/transaction_resto.dart';
import 'package:order_payments/ui/main_menu/components/enterprise_history_card.dart';
import 'package:order_payments/ui/main_menu/components/history_card_resto.dart';
import 'package:order_payments/ui/main_menu/components/history_investment_card.dart';
import 'package:order_payments/ui/main_menu/components/loading_indicator.dart';

class HistoryEnterprise extends StatefulWidget {
  const HistoryEnterprise({Key? key}) : super(key: key);

  @override
  State<HistoryEnterprise> createState() => _HistoryEnterpriseState();
}

int page = 1;

final scrollController = ScrollController();

void setupScrollController(context) {
  scrollController.addListener(() {
    if (scrollController.position.maxScrollExtent ==
        scrollController.position.pixels) {
      BlocProvider.of<InvestmentHistoryCubit>(context)
          .fetchInvestmentHistory(page++);
    }
  });
}

class _HistoryEnterpriseState extends State<HistoryEnterprise> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    BlocProvider.of<EnterpriseHistoryCubit>(context)
        .fetchEnterpriseHistory(page);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            margin: EdgeInsets.only(top: 40),
            child: Text("Riwayat", style: headline1Black),
          ),
          SizedBox(
            height: 10,
          ),
          Flexible(
            fit: FlexFit.tight,
            child: BlocBuilder<EnterpriseHistoryCubit, EnterpriseHistoryState>(
              builder: (context, state) {
                if (state is EnterpriseHistoryLoadingState &&
                    state.isFirstFetch) {
                  return LoadingIndicator(context);
                }
                List<EnterpriseHistory> enterpriseHistory = [];
                bool isLoading = false;
                if (state is EnterpriseHistoryLoadingState) {
                  enterpriseHistory = state.oldEnterpriseHistory;
                  isLoading = true;
                } else if (state is EnterpriseHistoryResponseState) {
                  enterpriseHistory= state.entepriseHistory;
                }
                return Container(
                  child: ListView.builder(
                      padding: EdgeInsets.zero,
                      itemCount: enterpriseHistory.length,
                      itemBuilder: (BuildContext context, int index) {
                        if (index < enterpriseHistory.length)
                          return HistoryEnterpriseCard(enterpriseHistory[index], context);
                        else {
                          Timer(Duration(milliseconds: 30), () {
                            scrollController.jumpTo(
                                scrollController.position.maxScrollExtent);
                          });
                          return LoadingIndicator(context);
                        }
                      }),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
