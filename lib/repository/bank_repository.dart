
import 'dart:convert';

import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
class BankRepository {
  Future getBank() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    var token = await prefs.getString('acces_token').toString();

    var url = "${dotenv.env['BASE_URL_API']}bank";
    final uri = Uri.parse(url);
    Map<String, String> headers = {
      'x-api-key': "${dotenv.env['X_API_KEY']}",
      'Accept': 'application/json',
      'Authorization': "Bearer " + token
    };
    final response = await http.get(uri, headers: headers);
    if (response.statusCode == 200) {
      return jsonDecode(response.body)['data'];
    } else {
      Map data = {'error': "Something Wrong", 'Message': jsonDecode(response.body)["message"]};
      return data;
    }
  }
}