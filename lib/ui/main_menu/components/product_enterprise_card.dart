import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:order_payments/model/product.dart';
import 'package:order_payments/ui/detail_product/detail_product.dart';
import 'package:order_payments/ui/main_menu/components/loading_indicator.dart';
import 'package:order_payments/ui/main_menu/umkm/product/detail_product_enterprise.dart';
import 'package:order_payments/utils/format_currency.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

Widget ProductEnterpriseCard(Products product, BuildContext context) {
  return SizedBox(
      child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.all(Radius.circular(12)),
            color: Colors.white,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.all(4.0),
                child: Container(
                  width: double.infinity,
                  height: MediaQuery.of(context).size.height / 6,
                  child: CachedNetworkImage(
                    imageUrl: "${dotenv.env['STORAGE_URL_API']}" +
                        product.product_pict,
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
              ),
              Padding(
                padding: const EdgeInsets.all(12.0),
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(height: 10),
                      Text(
                        product.name,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                            fontWeight: FontWeight.w100, fontSize: 12),
                      ),
                      SizedBox(height: 5),
                      Row(
                        children: [
                          Text(
                            CurrencyFormat.convertToIdr(product.price, 0),
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                                fontWeight: FontWeight.w600, fontSize: 14),
                          ),
                          Text(
                            "/Paket",
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                                fontWeight: FontWeight.normal, fontSize: 8),
                          ),
                        ],
                      ),
                      SizedBox(
                          width: double.infinity, // <-- match_parent

                          child: ElevatedButton(
                            onPressed: () {
                              Navigator.of(context).push(MaterialPageRoute(
                                  builder: (context) => DetailProductEnterprise(id: product.id,)));
                            },
                            child: Text("Lihat Paket"),
                            style: ButtonStyle(
                                backgroundColor: MaterialStateProperty.all(
                                    Color(0xFF1F2430))),
                          )),
                    ]),
              ),
            ],
          )));
}
