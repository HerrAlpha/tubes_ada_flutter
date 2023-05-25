import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:order_payments/bloc/investment/investment_cubit.dart';
import 'package:order_payments/bloc/product/product_cubit.dart';
import 'package:order_payments/bloc/transaction_resto/transaction_resto_cubit.dart';
import 'package:order_payments/core/text_style.dart';
import 'package:order_payments/model/investment.dart';
import 'package:order_payments/model/transaction_resto.dart';
import 'package:order_payments/repository/investment_feed_repository.dart';
import 'package:order_payments/repository/transaction_resto_repository.dart';
import 'package:order_payments/ui/main_menu/components/loading_indicator.dart';
import 'package:order_payments/ui/main_menu/components/status_card.dart';
import 'package:order_payments/utils/constant.dart' as Constants;
import 'package:order_payments/utils/format_currency.dart';
import 'package:order_payments/utils/format_date.dart';

Widget InvestmentCard(Investment investment, BuildContext context) {
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
                          investment.productPict!,
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
                            investment.name!,
                            style: TextStyle(
                                fontSize: 13, fontWeight: FontWeight.w600),
                          ),
                          Text(
                            DateFormatter.formatDate(investment.createdAt!),
                            style: TextStyle(
                                fontSize: 10,
                                color: Colors.grey,
                                fontWeight: FontWeight.normal),
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          Text(
                            "qty: " + investment.qty!.toString(),
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
                                investment.productionPrice, 0),
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
                        Text(CurrencyFormat.convertToIdr(investment.profit, 0),
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
              children: [
                Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Total Invest",
                      style: paragraphBlack,
                    ),
                    Text(CurrencyFormat.convertToIdr(investment.total, 0),
                        style: TextStyle(
                            color: Colors.black87,
                            fontSize: 18,
                            fontWeight: FontWeight.bold)),
                  ],
                ),
                SizedBox(
                  width: 20,
                ),
                Expanded(
                  child: ElevatedButton(
                    onPressed: () {
                      AwesomeDialog(
                        context: context,
                        animType: AnimType.scale,
                        dialogType: DialogType.warning,
                        body: Container(
                          padding: EdgeInsets.symmetric(horizontal: 20),
                          child: Column(
                            children: [
                              Text(
                                'Perhatian',
                                textAlign: TextAlign.center,
                                style: headline2Black,
                              ),
                              Text("1. Business Plan yang jelas dan realistis."
                                  "Investor harus memastikan bahwa UMKM memiliki rencana bisnis yang terperinci, termasuk proyeksi pendapatan, biaya, dan arus kas yang realistis."
                                  " Business plan ini harus menunjukkan bahwa UMKM mampu menghasilkan keuntungan yang cukup untuk membayar kembali pinjaman",
                                textAlign: TextAlign.justify,
                              ),
                              Text("2.  Jumlah pinjaman dan jangka waktu pinjaman yang jelas. "
                                  "Investor harus menentukan jumlah pinjaman dan jangka waktu "
                                  "pinjaman yang sesuai dengan kebutuhan UMKM.",
                                textAlign: TextAlign.justify,
                              ),
                              Text("3.  Rencana pengembalian pinjaman yang jelas. UMKM harus memiliki "
                                  "rencana pengembalian pinjaman yang jelas dan terperinci, "
                                  "termasuk tanggal jatuh tempo dan jumlah pembayaran yang "
                                  "harus dilakukan selama periode pinjaman.",
                                textAlign: TextAlign.justify,
                              ),
                              Text("4.  Penggunaan dana yang jelas. UMKM harus memastikan bahwa dana yang diberikan "
                                  "oleh investor digunakan dengan tepat untuk memenuhi pesanan "
                                  "dari vendor dan tidak digunakan untuk tujuan lain yang tidak "
                                  "berkaitan dengan kesepakatan pendanaan.",
                                textAlign: TextAlign.justify,
                              )
                            ],
                          ),
                        ),
                        btnCancelText: "Tidak",
                        btnCancelOnPress: () {},
                        btnOkOnPress: () {
                          _ambiLTawaran(investment.id!, context);
                        },
                      ).show();
                    },
                    child: Text("Ambil Tawaran"),
                    style: ButtonStyle(
                        backgroundColor:
                            MaterialStateProperty.all(Color(0xFF1F2430))),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    ),
  ));
}

_ambiLTawaran(int transaction_id, context) async {
  var isLoading = true;
  if (isLoading) {
    CircularProgressIndicator();
  }
  InvestmentRepository _investmentRepository = InvestmentRepository();
  var response = await _investmentRepository.checkoutInvestment(transaction_id);
  isLoading = false;
  if (response["error"] != null) {
    print("error");
    AwesomeDialog(
            context: context,
            animType: AnimType.scale,
            dialogType: DialogType.error,
            title: 'Error',
            desc: response["Message"],
            btnOkIcon: Icons.check_circle,
            autoHide: const Duration(seconds: 2))
        .show();
  } else {
    isLoading = false;
    AwesomeDialog(
        context: context,
        animType: AnimType.scale,
        dialogType: DialogType.success,
        title: 'Success',
        desc: 'Pesanan akan segera diproses',
        btnOkIcon: Icons.check_circle,
        autoHide: const Duration(seconds: 3),
        onDismissCallback: (type) {
          BlocProvider.of<InvestmentCubit>(context).fetchInvestment(1,"");
        }).show();
  }
}
