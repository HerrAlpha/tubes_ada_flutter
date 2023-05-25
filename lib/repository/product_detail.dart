import 'dart:convert';
import 'dart:ffi';

import 'package:http/http.dart' as http;
import 'package:order_payments/model/product_detail.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ProductDetailRepository {


  Future<ProductDetail> getDetail(int id) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    var token = await prefs.getString('acces_token').toString();

    var url = "${dotenv.env['BASE_URL_API']}feed/product/${id}";
    final uri = Uri.parse(url);
    Map <String,String> headers = {
      'x-api-key': "${dotenv.env['X_API_KEY']}",
      'Accept': 'application/json',
      'Authorization' : "Bearer "+token
    };
    final response = await http.get(uri,
        headers: headers
    );

    if (response.statusCode == 200) {
      final json = jsonDecode(response.body)['data'];
      final result = ProductDetail.fromJson(json);
      return result;
    } else {
      print("Something wrong  ${response.statusCode}");
      throw "Something wrong  ${response.statusCode}";
    }
  }


}
