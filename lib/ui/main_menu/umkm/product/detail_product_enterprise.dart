import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:order_payments/bloc/counter/counter_cubit.dart';
import 'package:order_payments/bloc/product_detail/product_detail_cubit.dart';
import 'package:order_payments/model/product_detail.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:order_payments/ui/detail_product/component/counter.dart';
import 'package:order_payments/ui/main_menu/main_page.dart';
import 'package:order_payments/utils/constant.dart' as Constants;
import 'package:order_payments/utils/format_currency.dart';


class DetailProductEnterprise extends StatefulWidget {
  final int id;

  const DetailProductEnterprise({Key? key, required this.id}) : super(key: key);

  @override
  State<DetailProductEnterprise> createState() => _DetailProductEnterpriseState(this.id);
}

class _DetailProductEnterpriseState extends State<DetailProductEnterprise> {
  final int id;
  int total = 1;

  _DetailProductEnterpriseState(this.id);

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    BlocProvider.of<ProductDetailCubit>(context).fetchDetailProduct(id);
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ProductDetailCubit, ProductDetailState>(
      builder: (context, state) {
        ProductDetail productDetail = ProductDetail();
        if (state is ProductDetailLoadingState) {
          return Center(child: CircularProgressIndicator());
        } else if (state is ProductDetailResponseState) {
          productDetail = state.product;
        }
        return Scaffold(
          resizeToAvoidBottomInset: false,
          backgroundColor: Color(0xFFF4F6F8),
          body: Container(
            child: Column(
              children: <Widget>[
                BlocBuilder<ProductDetailCubit, ProductDetailState>(
                    builder: (context, state) {
                      ProductDetail productDetail = ProductDetail();
                      if (state is ProductDetailLoadingState) {
                        return Center(child: CircularProgressIndicator());
                      } else if (state is ProductDetailResponseState) {
                        productDetail = state.product;
                      }

                      return Expanded(
                        child: Column(
                          children: [
                            CachedNetworkImage(
                              width: double.infinity,
                              height: MediaQuery.of(context).size.height / 2,
                              fit: BoxFit.cover,
                              imageUrl: "${dotenv.env['STORAGE_URL_API']}" +
                                  productDetail.productPict!,
                              placeholder: (context, url) =>
                                  CircularProgressIndicator(),
                              errorWidget: (context, url, error) =>
                                  Icon(Icons.error),
                            ),
                            Container(
                              padding: EdgeInsets.symmetric(
                                  horizontal: 20, vertical: 25),
                              width: double.infinity,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    productDetail.name!,
                                    style: TextStyle(
                                      fontFamily: 'Poppins',
                                      fontSize: 16,
                                      color: Color(0xFF1F2430),
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  SizedBox(
                                    height: 8,
                                  ),
                                  Row(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                    children: [
                                      Flexible(
                                        child: Row(
                                          children: [
                                            Icon(
                                              Icons.star_rounded,
                                              color: Colors.orange,
                                              size: 20.0,
                                              semanticLabel:
                                              'Text to announce in accessibility modes',
                                            ),
                                            SizedBox(
                                              width: 5,
                                            ),
                                            Text(
                                              "4.3",
                                              style: TextStyle(
                                                fontFamily: 'Poppins',
                                                fontSize: 14,
                                                color: Color(0xFF1F2430),
                                                fontWeight: FontWeight.w600,
                                              ),
                                            ),
                                            SizedBox(
                                              width: 4,
                                            ),
                                            Text(
                                              "(342 Review)",
                                              style: TextStyle(
                                                fontFamily: 'Poppins',
                                                fontSize: 12,
                                                color: Colors.black54,
                                                fontWeight: FontWeight.w400,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),

                                    ],
                                  ),
                                  SizedBox(
                                    height: 20,
                                  ),
                                  Text(
                                    "Deskripsi produk",
                                    style: TextStyle(
                                      fontFamily: 'Poppins',
                                      fontSize: 14,
                                      color: Color(0xFF1F2430),
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                  SizedBox(
                                    height: 8,
                                  ),
                                  Text(
                                    productDetail.name! +
                                        " merupakan makanan asli indonesia yang memiliki cita rasa khas rumahan \n" +
                                        productDetail.description!,
                                    textAlign: TextAlign.justify,
                                    style: TextStyle(
                                      fontFamily: 'Poppins',
                                      fontSize: 13,
                                      letterSpacing: 1,
                                      color: Colors.black54,
                                      fontWeight: FontWeight.normal,
                                    ),
                                  ),
                                ],
                              ),
                            )
                          ],
                        ),
                      );
                    }),
              ],
            ),
          ),
          bottomSheet: Container(
            padding: EdgeInsets.symmetric(horizontal: 20, vertical: 16),
            width: MediaQuery.of(context).size.width,
            color: Colors.white,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Flexible(
                  flex: 1,
                  child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Price",
                          textAlign: TextAlign.justify,
                          style: TextStyle(
                            fontFamily: 'Poppins',
                            fontSize: 14,
                            letterSpacing: 1,
                            color: Colors.black54,
                            fontWeight: FontWeight.normal,
                          ),
                        ),
                        BlocBuilder<CounterCubit, CounterInitial>(
                          builder: (context, state) {
                            return Text(
                              CurrencyFormat.convertToIdr(
                                  productDetail.price! * state.counterValue, 0),
                              textAlign: TextAlign.justify,
                              style: TextStyle(
                                fontFamily: 'Poppins',
                                fontSize: 18,
                                letterSpacing: 1,
                                color: Constants.PRIMARY_COLOR,
                                fontWeight: FontWeight.bold,
                              ),
                            );
                          },
                        ),
                      ]),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
