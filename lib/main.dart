import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:order_payments/bloc/counter/counter_cubit.dart';
import 'package:order_payments/bloc/enterprise_history/enterprise_history_cubit.dart';
import 'package:order_payments/bloc/investment/investment_cubit.dart';
import 'package:order_payments/bloc/investment_history/investment_history_cubit.dart';
import 'package:order_payments/bloc/product/product_cubit.dart';
import 'package:order_payments/bloc/product_detail/product_detail_cubit.dart';
import 'package:order_payments/bloc/transaction_resto/transaction_resto_cubit.dart';
import 'package:order_payments/model/enterprise_history.dart';
import 'package:order_payments/model/investment_history.dart';
import 'package:order_payments/repository/enterprise_feed_repository.dart';
import 'package:order_payments/repository/enterprise_history_repository.dart';
import 'package:order_payments/repository/investment_feed_repository.dart';
import 'package:order_payments/repository/investment_history_repository.dart';
import 'package:order_payments/repository/product_detail.dart';
import 'package:order_payments/repository/product_feed_repository.dart';
import 'package:order_payments/repository/transaction_resto_repository.dart';
import 'package:order_payments/ui/login/login_page.dart';
import 'package:order_payments/ui/main_menu/main_page.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:order_payments/utils/constant.dart' as Constants;
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

import 'bloc/enterprise_feed/enterprise_feed_cubit.dart';

Future main() async {
  await dotenv.load(fileName: ".env");
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<ProductCubit>(
          create: (context) => ProductCubit(ProductRepository()),
        ),
        BlocProvider<ProductDetailCubit>(
          create: (context) => ProductDetailCubit(ProductDetailRepository()),
        ),
        BlocProvider<CounterCubit>(
          create: (context) => CounterCubit(),
        ),
        BlocProvider<TransactionRestoCubit>(
          create: (context) => TransactionRestoCubit(TransactionRestoRepository()),
        ),
        BlocProvider<InvestmentCubit>(
          create: (context) => InvestmentCubit(InvestmentRepository()),
        ),
        BlocProvider<InvestmentHistoryCubit>(
          create: (context) => InvestmentHistoryCubit(InvestmentHistoryRepository()),
        ),
        BlocProvider<EnterpriseFeedCubit>(
          create: (context) => EnterpriseFeedCubit(EntepriseFeedRepository()),
        ),
        BlocProvider<EnterpriseHistoryCubit>(
          create: (context) => EnterpriseHistoryCubit(EnterpriseHistoryRepository()),
        ),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          primaryColor: Constants.PRIMARY_COLOR,
          fontFamily: 'Poppins',
        ),
        home: Scaffold(
          body: Center(
            child: LoginPage(),
          ),
        ),
      ),
    );
  }
}
