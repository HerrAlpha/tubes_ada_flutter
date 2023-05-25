import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:order_payments/bloc/transaction_resto/transaction_resto_cubit.dart';
import 'package:order_payments/core/text_style.dart';
import 'package:order_payments/model/transaction_resto.dart';
import 'package:order_payments/ui/main_menu/components/history_card_resto.dart';
import 'package:order_payments/ui/main_menu/components/loading_indicator.dart';

class History extends StatefulWidget {
  const History({Key? key}) : super(key: key);

  @override
  State<History> createState() => _HistoryState();
}
int page = 1 ;
final scrollController = ScrollController();
void setupScrollController(context) {
  scrollController.addListener(() {
    if (scrollController.position.maxScrollExtent ==
        scrollController.position.pixels) {
      BlocProvider.of<TransactionRestoCubit>(context).fetchTransactionResto(page++);
    }
  });
}
class _HistoryState extends State<History> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    BlocProvider.of<TransactionRestoCubit>(context).fetchTransactionResto(page);
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
          SizedBox(height: 10,),
          Flexible(
            fit: FlexFit.tight,
            child: BlocBuilder<TransactionRestoCubit, TransactionRestoState>(
              builder: (context, state) {
                if (state is TransactionRestoLoadingState && state.isFirstFetch) {
                  return LoadingIndicator(context);
                }
                List<TransactionResto> transactionRestos = [];
                bool isLoading = false;
                if (state is TransactionRestoLoadingState) {
                  transactionRestos = state.oldTransaction;
                  isLoading = true;
                } else if (state is TransactionRestoResponseState) {
                  transactionRestos = state.transactionResto;
                }
                return Container(
                  child: ListView.builder(
                    padding: EdgeInsets.zero,
                      itemCount: transactionRestos.length,
                      itemBuilder: (BuildContext context, int index) {
                        if (index < transactionRestos.length)
                          return HistoryCard(transactionRestos[index], context);
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
