import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:order_payments/bloc/investment/investment_cubit.dart';
import 'package:order_payments/bloc/product/product_cubit.dart';
import 'package:order_payments/model/investment.dart';
import 'package:order_payments/model/product.dart';
import 'package:order_payments/model/user.dart';
import 'package:order_payments/ui/main_menu/components/investment_card.dart';
import 'package:order_payments/ui/main_menu/components/loading_indicator.dart';
import 'package:order_payments/ui/main_menu/components/product_card.dart';

import 'package:order_payments/utils/constant.dart' as Constants;
import 'package:shared_preferences/shared_preferences.dart';

class HomeInvestor extends StatefulWidget {
  const HomeInvestor({Key? key}) : super(key: key);

  @override
  State<HomeInvestor> createState() => _HomeInvestorState();
}

final scrollController = ScrollController();
var page = 1;
TextEditingController searchController = TextEditingController();
void setupScrollController(context) {
  scrollController.addListener(() {
    if (scrollController.position.maxScrollExtent ==
        scrollController.position.pixels) {
      BlocProvider.of<InvestmentCubit>(context)
          .fetchInvestment(page += 1, searchController.text);
    }
  });
}

class _HomeInvestorState extends State<HomeInvestor> {
  User? user;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    setupScrollController(context);
    () async {
      await _getDataUser();
      setState(() {
        // Update your UI with the desired changes.
      });
    }();
    BlocProvider.of<InvestmentCubit>(context).fetchInvestment(page, "");
  }

  _getDataUser() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    String? data = prefs.getString('user_data');
    if (data != null) {
      final user_data = jsonDecode(data);
      user = User.fromJson(user_data);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Color(0xFFF4F6F8),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Container(
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 40, horizontal: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: <Widget>[
                      Container(
                        width: 50,
                        height: 50,
                        child: Image(
                          image: AssetImage("assets/icon/avatar.png"),
                        ),
                      ),
                      SizedBox(width: 15),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Text(
                            "HI " + (user?.name ?? ''),
                            style: TextStyle(
                                color: Constants.PRIMARY_COLOR,
                                fontSize: 16,
                                fontWeight: FontWeight.bold),
                          ),
                          Text(
                            "Investor",
                            style: TextStyle(
                                color: Constants.PRIMARY_COLOR, fontSize: 12),
                          ),
                        ],
                      )
                    ],
                  ),
                ],
              ),
            ),
          ),
          SizedBox(
            height: 10,
          ),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 20),
            child: Text(
              "Tawaran Investasi",
              style: TextStyle(fontWeight: FontWeight.bold, letterSpacing: 1),
            ),
          ),
          SizedBox(
            height: 10,
          ),
          Flexible(
            fit: FlexFit.tight,
            child: BlocBuilder<InvestmentCubit, InvestmentState>(
              builder: (context, state) {
                if (state is InvestmentLoadingState && state.isFirstFetch) {
                  return LoadingIndicator(context);
                }
                List<Investment> investment = [];
                bool isLoading = false;
                if (state is InvestmentLoadingState) {
                  investment = state.oldInvestment;
                  isLoading = true;
                } else if (state is InvestmentResponseState) {
                  investment = state.investment;
                }
                return Container(
                  padding: EdgeInsets.symmetric(horizontal: 10),
                  child: ListView.builder(
                      padding: EdgeInsets.zero,
                      itemCount: investment.length,
                      itemBuilder: (BuildContext context, int index) {
                        if (index < investment.length)
                          return InvestmentCard(investment[index], context);
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
