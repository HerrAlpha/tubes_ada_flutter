import 'dart:convert';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:order_payments/core/text_style.dart';
import 'package:order_payments/repository/auth_repository.dart';
import 'package:order_payments/repository/profile_repository.dart';
import 'package:order_payments/ui/login/login_page.dart';
import 'package:order_payments/utils/format_currency.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Profile extends StatefulWidget {
  const Profile({Key? key}) : super(key: key);

  @override
  State<Profile> createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  final _authRepository = new AuthRepository();
  final _profileRepository = new ProfileRepository();
  Map<String, dynamic>? profile = new Map();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    () async {
      await _getProfile();
      setState(() {
        // Update your UI with the desired changes.
      });
    }();
  }

  _getProfile() async {
    var response = await _profileRepository.getProfile();
    profile = response['data'];
    print(profile!);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 30, vertical: 40),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(
                width: 75,
                height: 75,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.lightBlue,
                  image: DecorationImage(
                      image: NetworkImage(profile!['profile_pict'] != null
                          ? "${dotenv.env['STORAGE_URL_API']}" +
                          profile!['profile_pict']
                          : ""),
                      fit: BoxFit.cover),
                ),
              ),
              SizedBox(
                width: 20,
              ),
              Flexible(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      profile!['name'] ?? '-',
                      style: headline1Black,
                    ),
                    Text(
                      "Vendor/Resto",
                      style: paragraphBlack,
                    )
                  ],
                ),
              )
            ],
          ),
          SizedBox(
            height: 20,
          ),
          Text(
            "Profil",
            style: TextStyle(
              fontWeight: FontWeight.w600,
              fontSize: 16,
            ),
          ),
          Container(
            width: double.infinity,
            child: Divider(
              thickness: 2,
              color: Colors.black87,
            ),
          ),
          SizedBox(
            height: 10,
          ),
          _cardProfile("Nama", profile!['name']),
          SizedBox(
            height: 10,
          ),
          _cardProfile("Email", profile!['email']),
          SizedBox(
            height: 10,
          ),
          _cardProfile("No Telepon", profile!['phone']),
          SizedBox(
            height: 30,
          ),
          Container(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () {
                _logout();
              },
              style: ButtonStyle(
                  textStyle: MaterialStateProperty.all(TextStyle(fontSize: 18,fontWeight: FontWeight.bold,letterSpacing: 2)),
                  padding: MaterialStateProperty.all(EdgeInsets.all(15)),
                  shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                      RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(18.0),
                      ))),
              child: Text("Logout"),
            ),
          ),
        ],
      ),
    );

    //Center(
    //   child: ElevatedButton(onPressed: () {
    //     _logout();
    //   }, child: Text("logout"),
    //
    //   ),
    // );
  }

  _cardProfile(String key, dynamic value) {
    return (Container(
      width: double.infinity,
      child: Row(
        children: [
          Container(
              child: Text(
                key,
                style: TextStyle(
                  fontWeight: FontWeight.w300,
                  fontSize: 16,
                ),
              )),
          Expanded(
              child: Text(
                value == null? "-" : value,
                textAlign: TextAlign.right,
                style: TextStyle(
                  fontWeight: FontWeight.w600,
                  fontSize: 16,
                ),
              )),
        ],
      ),
    ));
  }

  _logout() async {
    var response = await _authRepository.logout();
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.clear();
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => LoginPage()),
    );
  }
}
