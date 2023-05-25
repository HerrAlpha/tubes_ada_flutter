import 'dart:convert';
import 'dart:ffi';

import 'package:http/http.dart' as http;
import 'package:order_payments/model/product_detail.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:shared_preferences/shared_preferences.dart';

class CheckoutProductRepository {
  Future checkoutProduct(int product_id, int qty) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    var token = await prefs.getString('acces_token').toString();

    var url = "${dotenv.env['BASE_URL_API']}checkout/product";
    final uri = Uri.parse(url);
    Map<String, String> headers = {
      'x-api-key': "${dotenv.env['X_API_KEY']}",
      'Accept': 'application/json',
      'Authorization': "Bearer " + token
    };
    final response = await http.post(uri, headers: headers, body: {
      'product_id': product_id.toString(), 'qty': qty.toString()
    });
    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      Map data = {'error': "Something Wrong", 'Message': jsonDecode(response.body)["message"]};
      return data;
    }
  }
}
