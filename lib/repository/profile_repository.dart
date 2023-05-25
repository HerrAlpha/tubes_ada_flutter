
import 'dart:convert';

import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
class ProfileRepository {
  Future getProfile() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    var token = await prefs.getString('acces_token').toString();
    var url = "${dotenv.env['BASE_URL_API']}profile";
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
      return jsonDecode(response.body);
    } else {
      print("Something wrong  ${response.statusCode}");
      throw "Something wrong  ${response.statusCode}";
    }
  }
}