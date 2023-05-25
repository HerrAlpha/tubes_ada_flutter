import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:order_payments/bloc/investment_history/investment_history_cubit.dart';
import 'package:order_payments/bloc/transaction_resto/transaction_resto_cubit.dart';
import 'package:order_payments/core/text_style.dart';
import 'package:order_payments/model/investment_history.dart';
import 'package:order_payments/model/transaction_resto.dart';
import 'package:order_payments/ui/main_menu/components/history_card_resto.dart';
import 'package:order_payments/ui/main_menu/components/history_investment_card.dart';
import 'package:order_payments/ui/main_menu/components/loading_indicator.dart';

class HistoryInvestmen extends StatefulWidget {
  const HistoryInvestmen({Key? key}) : super(key: key);

  @override
  State<HistoryInvestmen> createState() => _HistoryInvestmenState();
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

class _HistoryInvestmenState extends State<HistoryInvestmen> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    BlocProvider.of<InvestmentHistoryCubit>(context)
        .fetchInvestmentHistory(page);
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
            child: BlocBuilder<InvestmentHistoryCubit, InvestmentHistoryState>(
              builder: (context, state) {
                if (state is InvestmentHistoryLoadingState &&
                    state.isFirstFetch) {
                  return LoadingIndicator(context);
                }
                List<InvestmentHistory> investmentHistory = [];
                bool isLoading = false;
                if (state is InvestmentHistoryLoadingState) {
                  investmentHistory = state.oldInvestmentHistory;
                  isLoading = true;
                } else if (state is InvestmentHistoryResponseState) {
                  investmentHistory= state.investmentHistory;
                }
                return Container(
                  child: ListView.builder(
                      padding: EdgeInsets.zero,
                      itemCount: investmentHistory.length,
                      itemBuilder: (BuildContext context, int index) {
                        if (index < investmentHistory.length)
                          return HistoryInvestmentCard(investmentHistory[index], context);
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
