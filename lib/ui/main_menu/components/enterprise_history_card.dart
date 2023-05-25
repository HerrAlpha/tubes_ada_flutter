import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:order_payments/bloc/product/product_cubit.dart';
import 'package:order_payments/bloc/transaction_resto/transaction_resto_cubit.dart';
import 'package:order_payments/core/text_style.dart';
import 'package:order_payments/model/enterprise_history.dart';
import 'package:order_payments/model/investment.dart';
import 'package:order_payments/model/investment_history.dart';
import 'package:order_payments/model/transaction_resto.dart';
import 'package:order_payments/repository/investment_feed_repository.dart';
import 'package:order_payments/repository/transaction_resto_repository.dart';
import 'package:order_payments/ui/main_menu/components/loading_indicator.dart';
import 'package:order_payments/ui/main_menu/components/status_card.dart';
import 'package:order_payments/utils/constant.dart' as Constants;
import 'package:order_payments/utils/format_currency.dart';
import 'package:order_payments/utils/format_date.dart';

Widget HistoryEnterpriseCard(
    EnterpriseHistory enterprise, BuildContext context) {
  return (Container(
    child: Card(
      elevation: 0.5,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              child: Row(
                children: [
                  Flexible(
                    flex: 1,
                    child: CachedNetworkImage(
                      width: double.infinity,
                      height: 80,
                      imageUrl: "${dotenv.env['STORAGE_URL_API']}" +
                          enterprise.productPict!,
                      progressIndicatorBuilder:
                          (context, url, downloadProgress) =>
                          LoadingIndicator(context),
                      imageBuilder: (context, imageProvider) => Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.all(Radius.circular(10)),
                          image: DecorationImage(
                              image: imageProvider, fit: BoxFit.cover),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.grey,
                              blurRadius: 14,
                              offset: Offset(3, 6), // Shadow position
                            ),
                          ],
                        ),
                      ),
                      errorWidget: (context, url, error) => Icon(Icons.error),
                    ),
                  ),
                  SizedBox(width: 20),
                  Flexible(
                    flex: 2,
                    fit: FlexFit.tight,
                    child: Container(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            enterprise.name!,
                            style: TextStyle(
                                fontSize: 13, fontWeight: FontWeight.w600),
                          ),
                          Text(
                            DateFormatter.formatDate(enterprise.createdAt!),
                            style: TextStyle(
                                fontSize: 10,
                                color: Colors.grey,
                                fontWeight: FontWeight.normal),
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          Text(
                            "qty: " + enterprise.qty!.toString(),
                            style: TextStyle(
                                fontSize: 14,
                                color: Colors.black87,
                                fontWeight: FontWeight.normal),
                          ),
                        ],
                      ),
                    ),
                  )
                ],
              ),
            ),
            SizedBox(
              height: 20,
            ),
            IntrinsicHeight(
              child: Row(
                children: [
                  Expanded(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Biaya Produksi",
                          style: paragraphBlack,
                        ),
                        Text(
                            CurrencyFormat.convertToIdr(
                                enterprise.productionPrice, 0),
                            style: headline2Black),
                      ],
                    ),
                  ),
                  VerticalDivider(
                    color: Colors.black12,
                    thickness: 2,
                  ),
                  Expanded(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.end,
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Text(
                          "Profit",
                          style: paragraphBlack,
                        ),
                        Text(CurrencyFormat.convertToIdr(enterprise.profit, 0),
                            style: headline2Black),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            Container(
              width: double.infinity,
              child: Divider(
                thickness: 2,
                color: Colors.black12,
              ),
            ),
            SizedBox(
              height: 10,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Total Invest",
                      style: paragraphBlack,
                    ),
                    Text(CurrencyFormat.convertToIdr(enterprise.total, 0),
                        style: TextStyle(
                            color: Colors.black87,
                            fontSize: 20,
                            fontWeight: FontWeight.bold)),
                  ],
                ),
                SizedBox(
                  width: 40,
                ),
                Column(
                  children: [
                    StatusCard(enterprise.status!)
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    ),
  ));
}

