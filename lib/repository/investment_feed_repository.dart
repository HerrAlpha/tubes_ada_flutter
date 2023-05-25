import 'dart:convert';
import 'dart:ffi';

import 'package:http/http.dart' as http;
import 'package:order_payments/model/investment.dart';
import 'package:order_payments/model/product.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:shared_preferences/shared_preferences.dart';

class InvestmentRepository {
  Future<List<Investment>> getAll(int page, [String search = ""]) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    var token = await prefs.getString('acces_token').toString();
    print(page);
    print("--");
    print(search);
    var url =
        "${dotenv.env['BASE_URL_API']}feed/investment?page=${page}&keyword=${search}";
    final uri = Uri.parse(url);
    Map<String, String> headers = {
      'x-api-key': "${dotenv.env['X_API_KEY']}",
      'Accept': 'application/json',
      'Authorization': "Bearer " + token
    };
    final response = await http.get(uri, headers: headers);

    if (response.statusCode == 200) {
      final json = jsonDecode(response.body)['data']['data'] as List;
      final result = json.map((e) {
        return Investment(
            id: e['id'],
            name: e['name'],
            createdAt: e['created_at'],
            qty: e['qty'],
            productPict: e['product_pict'],
            productionPrice: e['production_price'],
            profit: e['profit'],
            total: e['total']);
      }).toList();
      return result;
    } else {
      print("Something wrong  ${response.statusCode}");
      throw "Something wrong  ${response.statusCode}";
    }
  }

  Future checkoutInvestment(int product_id) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    var token = await prefs.getString('acces_token').toString();

    var url = "${dotenv.env['BASE_URL_API']}checkout/investment";
    final uri = Uri.parse(url);
    Map<String, String> headers = {
      'x-api-key': "${dotenv.env['X_API_KEY']}",
      'Accept': 'application/json',
      'Authorization': "Bearer " + token
    };
    final response = await http.post(uri,
        headers: headers,
        body: {'investment_id': product_id.toString()});
    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      Map data = {
        'error': "Something Wrong",
        'Message': jsonDecode(response.body)["message"]
      };
      return data;
    }
  }
}
