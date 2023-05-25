import 'dart:convert';
import 'dart:ffi';

import 'package:http/http.dart' as http;
import 'package:order_payments/model/investment_history.dart';
import 'package:order_payments/model/product.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:order_payments/model/transaction_resto.dart';
import 'package:shared_preferences/shared_preferences.dart';

class InvestmentHistoryRepository {
  Future<List<InvestmentHistory>> getAll(int page) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    var token = await prefs.getString('acces_token').toString();

    var url = "${dotenv.env['BASE_URL_API']}transaction?page=${page}";
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
        return InvestmentHistory(
            id: e['id'],
            invoiceNumber: e['invoice_number'],
            qty: e['qty'],
            total: e['total'],
            status: e['status'],
            name: e['name'],
            productPict: e['product_pict'],
            createdAt: e['created_at'],
            productionPrice: e['production_price'],
            profit: e['profit']);
      }).toList();
      return result;
    } else {
      print("Something wrong  ${response.statusCode}");
      throw "Something wrong  ${response.statusCode}";
    }
  }

  Future cancelTransaction(int transaction_id) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    var token = await prefs.getString('acces_token').toString();

    var url =
        "${dotenv.env['BASE_URL_API']}transaction/cancel/${transaction_id}";
    final uri = Uri.parse(url);
    Map<String, String> headers = {
      'x-api-key': "${dotenv.env['X_API_KEY']}",
      'Accept': 'application/json',
      'Authorization': "Bearer " + token
    };
    final response = await http.post(uri, headers: headers);
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
