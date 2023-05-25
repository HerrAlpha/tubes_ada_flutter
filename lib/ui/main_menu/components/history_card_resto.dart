import 'dart:convert';

import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:order_payments/bloc/product/product_cubit.dart';
import 'package:order_payments/bloc/transaction_resto/transaction_resto_cubit.dart';
import 'package:order_payments/core/text_style.dart';
import 'package:order_payments/model/transaction_resto.dart';
import 'package:order_payments/repository/bank_repository.dart';
import 'package:order_payments/repository/transaction_resto_repository.dart';
import 'package:order_payments/ui/main_menu/components/loading_indicator.dart';
import 'package:order_payments/ui/main_menu/components/status_card.dart';
import 'package:order_payments/utils/constant.dart' as Constants;
import 'package:order_payments/utils/format_currency.dart';
import 'package:order_payments/utils/format_date.dart';

Widget HistoryCard(TransactionResto transactionResto, BuildContext context) {
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
                          transactionResto.productPict!,
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
                            transactionResto.name!,
                            style: TextStyle(
                                fontSize: 13, fontWeight: FontWeight.w600),
                          ),
                          Text(
                            DateFormatter.formatDate(
                                transactionResto.createdAt!),
                            style: TextStyle(
                                fontSize: 10,
                                color: Colors.grey,
                                fontWeight: FontWeight.normal),
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          Text(
                            CurrencyFormat.convertToIdr(
                                transactionResto.total, 0),
                            style: TextStyle(
                                fontSize: 16,
                                color: Colors.black87,
                                fontWeight: FontWeight.w600),
                          ),
                        ],
                      ),
                    ),
                  )
                ],
              ),
            ),
            SizedBox(
              height: 30,
            ),
            Container(
              width: double.infinity,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Invoice",
                    style: headline2Black,
                  ),
                  Text(transactionResto.invoiceNumber!, style: paragraphBlack),
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
                if (transactionResto.status! != 1 &&
                    transactionResto.status! != 5 &&
                    transactionResto.status != 4 &&
                    transactionResto.status! != 6) ...[
                  OutlinedButton(
                      onPressed: () {
                        _bayarPesanan(transactionResto.total!, context);
                      },
                      child: Text(
                        "Bayar",
                        style: TextStyle(
                            fontSize: 18,
                            color: Colors.green,
                            fontWeight: FontWeight.w600),
                      ),
                      style: OutlinedButton.styleFrom(
                        side: BorderSide(color: Colors.green, width: 2),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(14), // <-- Radius
                        ),
                      )),
                ] else if (transactionResto.status == 1) ...[
                  OutlinedButton(
                      onPressed: () {
                        AwesomeDialog(
                          context: context,
                          animType: AnimType.scale,
                          dialogType: DialogType.warning,
                          title: 'Perhatian',
                          desc: "Apakah anda yakin ingin membatalkan pesanan?",
                          btnCancelText: "Tidak",
                          btnCancelOnPress: () {},
                          btnOkOnPress: () {
                            _cancelPesanan(transactionResto.id!, context);
                          },
                        ).show();
                      },
                      child: Text(
                        "Cancel",
                        style: TextStyle(
                            fontSize: 18,
                            color: Colors.red,
                            fontWeight: FontWeight.w600),
                      ),
                      style: OutlinedButton.styleFrom(
                        side: BorderSide(color: Colors.red, width: 2),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(14), // <-- Radius
                        ),
                      )),
                ] else ...[
                  Text("")
                ],
                Flexible(
                  child: Column(
                    children: [StatusCard(transactionResto.status!)],
                  ),
                ),
              ],
            )
          ],
        ),
      ),
    ),
  ));
}

_cancelPesanan(int transaction_id, context) async {
  TransactionRestoRepository transactionRestoRepository =
      TransactionRestoRepository();
  await transactionRestoRepository.cancelTransaction(transaction_id);
  BlocProvider.of<TransactionRestoCubit>(context).fetchTransactionResto(1);
}

_bayarPesanan(int total_pesanan, context) async {
  BankRepository bankRepository = new BankRepository();
  var response = await bankRepository.getBank();
  print(response);
  AwesomeDialog(
    context: context,
    animType: AnimType.scale,
    dialogType: DialogType.info,
    body: Container(
      padding: EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        children: [
          Text(
            'Silahkan lakukan pembayaran di rekening berikut',
            textAlign: TextAlign.center,
            style: paragraphBlack,
          ),
          SizedBox(
            height: 10,
          ),
          Text(
            response['bank_account_name'],
            style: headline2Black,
          ),
          Text(
            response['bank_account_number'],
            style: headline1Black,
          ),
          SizedBox(
            height: 10,
          ),
          Text(
            "Total " + CurrencyFormat.convertToIdr(total_pesanan, 0),
            style: headline2Black,
          ),
        ],
      ),
    ),
    title: 'This is Ignored',
    desc: 'This is also Ignored',
    btnOkOnPress: () {},
  ).show();
}
