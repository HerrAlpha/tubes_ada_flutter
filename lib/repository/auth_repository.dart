import 'dart:convert';
import 'dart:ffi';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:order_payments/model/product.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:order_payments/ui/main_menu/resto/home/home.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthRepository {
  Future login(String? email, String? password) async {
    var url = "${dotenv.env['BASE_URL_API']}auth/login";
    var uri = Uri.parse(url);
    Map data = {'email': email, 'password': password};
    var body = json.encode(data);

    final response = await http.post(
      uri,
      headers: {
        'x-api-key': "${dotenv.env['X_API_KEY']}",
        'Accept': 'application/json',
        "Content-Type": "application/json",
        "Accept": "application/json"
      },
      body: body,
    );

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      Map data = {'error': "Something Wrong", 'Message': jsonDecode(response.body)["message"]};
      return data;
    }
  }

  Future logout() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    var token = await prefs.getString('acces_token').toString();
    var url = "${dotenv.env['BASE_URL_API']}auth/logout";
    var uri = Uri.parse(url);
    final response = await http.post(
      uri,
      headers: {
        'x-api-key': "${dotenv.env['X_API_KEY']}",
        'Accept': 'application/json',
        "Content-Type": "application/json",
        "Accept": "application/json",
        'Authorization': "Bearer " + token
      },
    );

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      Map data = {'error': "Something Wrong", 'Message': jsonDecode(response.body)["message"]};
      return data;
    }
  }
  Future register(String name,String email,String phone,String role,String password) async {
    Map data = {
      'name': name,
      'email': email,
      'phone': phone,
      'role': role,
      'password': password,
      'password_confirmation': password,

    };
    var body = json.encode(data);
    var url = "${dotenv.env['BASE_URL_API']}auth/register";
    var uri = Uri.parse(url);
    final response = await http.post(
      uri,
      headers: {
        'x-api-key': "${dotenv.env['X_API_KEY']}",
        'Accept': 'application/json',
        "Content-Type": "application/json",
        "Accept": "application/json",
      },
      body: body
    );

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      Map data = {'error': "Something Wrong", 'Message': jsonDecode(response.body)["message"]};
      return data;
    }
  }

}
