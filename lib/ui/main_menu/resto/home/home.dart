import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:order_payments/bloc/product/product_cubit.dart';
import 'package:order_payments/model/product.dart';
import 'package:order_payments/model/user.dart';
import 'package:order_payments/ui/main_menu/components/loading_indicator.dart';
import 'package:order_payments/ui/main_menu/components/product_card.dart';

import 'package:order_payments/utils/constant.dart' as Constants;
import 'package:shared_preferences/shared_preferences.dart';

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  State<Home> createState() => _HomeState();
}

final scrollController = ScrollController();
var page = 1;
TextEditingController searchController = TextEditingController();
void setupScrollController(context) {
  scrollController.addListener(() {
    if (scrollController.position.maxScrollExtent ==
        scrollController.position.pixels) {
      BlocProvider.of<ProductCubit>(context)
          .fetchProduct(page += 1, searchController.text);
    }
  });
}

class _HomeState extends State<Home> {
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
    BlocProvider.of<ProductCubit>(context).fetchProduct(page, "");
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
    var _screenWidth = MediaQuery.of(context).size.width;
    var _itemCount = (_screenWidth / 100).ceil();
    print(_itemCount);
    return Container(
      color: Color(0xFFF4F6F8),
      child: Column(
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
                            "Resto/Vendor",
                            style: TextStyle(
                                color: Constants.PRIMARY_COLOR, fontSize: 12),
                          ),
                        ],
                      )
                    ],
                  ),
                  SizedBox(
                    height: 25,
                  ),
                  Container(
                    child: TextField(
                      controller: searchController,
                      cursorColor: Colors.grey,
                      textInputAction: TextInputAction.go,
                      onSubmitted: (value) {
                        page = 1;
                        BlocProvider.of<ProductCubit>(context)
                            .fetchProduct(1, searchController.text);
                      },
                      decoration: InputDecoration(
                          fillColor: Colors.white,
                          filled: true,
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(30),
                              borderSide: BorderSide.none),
                          contentPadding: EdgeInsets.all(0),
                          hintText: 'Cari Paket...',
                          hintStyle:
                              TextStyle(color: Colors.grey, fontSize: 14),
                          prefixIcon: Container(
                            padding: EdgeInsets.symmetric(
                                horizontal: 15, vertical: 1),
                            child: Icon(Icons.search),
                            width: 20,
                          )),
                    ),
                  ),
                ],
              ),
            ),
          ),
          Expanded(
              child: Container(
            padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 20),
            width: MediaQuery.of(context).size.width,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  "Pilihan Paket",
                  style:
                      TextStyle(fontWeight: FontWeight.bold, letterSpacing: 1),
                ),
                Flexible(
                  fit: FlexFit.tight,
                  child: BlocBuilder<ProductCubit, ProductState>(
                      builder: (context, state) {
                    if (state is ProductLoadingState && state.isFirstFetch) {
                      print("disini");
                      return LoadingIndicator(context);
                    }
                    List<Products> products = [];
                    bool isLoading = false;

                    if (state is ProductLoadingState) {
                      products = state.oldProduct;
                      isLoading = true;
                    } else if (state is ProductResponseState) {
                      products = state.product;
                    }
                    return GridView.builder(
                      padding: EdgeInsets.symmetric(vertical: 5),
                      controller: scrollController,
                      gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
                          maxCrossAxisExtent: 200,
                          childAspectRatio: MediaQuery.of(context).size.width /
                              (MediaQuery.of(context).size.height / 1.2),
                          crossAxisSpacing: 10,
                          mainAxisSpacing: 20),
                      itemBuilder: (context, index) {
                        if (index < products.length)
                          return ProductCard(products[index], context);
                        else {
                          Timer(Duration(milliseconds: 30), () {
                            scrollController.jumpTo(
                                scrollController.position.maxScrollExtent);
                          });
                          return LoadingIndicator(context);
                        }
                      },
                      itemCount: products.length + (isLoading ? 1 : 0),
                    );
                  }),
                )
              ],
            ),
          ))
        ],
      ),
    );
  }
}
