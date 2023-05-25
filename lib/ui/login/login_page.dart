import 'dart:convert';

import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:order_payments/core/colors.dart';
import 'package:order_payments/core/space.dart';
import 'package:order_payments/core/text_style.dart';
import 'package:order_payments/model/user.dart';
import 'package:order_payments/repository/auth_repository.dart';
import 'package:order_payments/ui/login/component/main_button.dart';
import 'package:order_payments/ui/login/component/text_field.dart';
import 'package:order_payments/ui/main_menu/main_page.dart';
import 'package:order_payments/ui/register/register_page.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _authRepository = new AuthRepository();
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  User? user;
  @override
  void initState() {
    // TODO: implement initState
    () async {
      await _getDataUser();

      setState(() {
        // Update your UI with the desired changes.
      });
    }();
    super.initState();
  }

  _getDataUser() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    String? acces_token = prefs.getString('acces_token');
    if (acces_token != null) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => MainPage()),
      );
    }
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: blackBG,
      body: Padding(
        padding: EdgeInsets.only(top: 50.0),
        child: SingleChildScrollView(
          child: Column(
            children: [
              SpaceVH(height: 50.0),
              Text(
                'Welcome Back!',
                style: headline1,
              ),
              SpaceVH(height: 10.0),
              Text(
                'Please sign in to your account',
                style: headline3,
              ),
              SpaceVH(height: 60.0),
              TextFieldComponent(
                controller: emailController,
                image: 'user.svg',
                hintTxt: 'Email',
              ),
              TextFieldComponent(
                controller: passwordController,
                image: 'hide.svg',
                isObs: true,
                hintTxt: 'Password',
              ),
              SpaceVH(height: 10.0),
              Align(
                alignment: Alignment.bottomCenter,
                child: Column(
                  children: [
                    Mainbutton(
                      onTap: () {
                        _submitLogin();
                      },
                      text: 'Sign in',
                      btnColor: blueButton,
                    ),
                    SpaceVH(height: 20.0),
                    SpaceVH(height: 20.0),
                    TextButton(
                      onPressed: () {},
                      child: RichText(
                        text: TextSpan(children: [
                          TextSpan(
                            text: 'Don\' have an account? ',
                            style: headline.copyWith(
                              fontSize: 14.0,
                            ),
                          ),
                          TextSpan(
                            text: ' Sign Up',
                            style: headlineDot.copyWith(
                              fontSize: 14.0,
                            ),
                            recognizer: TapGestureRecognizer()..onTap = () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(builder: (context) => RegisterPage()),
                              );
                            },
                          ),
                        ]),
                      ),
                    )
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  _submitLogin() async {

    var response = await _authRepository.login(emailController.text, passwordController.text);
    if(response["error"] != null){
      print("error");
      AwesomeDialog(
          context: context,
          animType: AnimType.scale,
          dialogType: DialogType.error,
          title: 'Error',
          desc: response["Message"],
          btnOkIcon: Icons.check_circle,
          autoHide: const Duration(seconds: 3)
      ).show();
    }else{
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      prefs.setString('user_data', jsonEncode(response['data']['user']));
      prefs.setString('acces_token', response['data']['token']);
      AwesomeDialog(
          context: context,
          animType: AnimType.scale,
          dialogType: DialogType.success,
          title: 'Success',
          desc:
          'Login Berhasil.',
          btnOkIcon: Icons.check_circle,
          autoHide: const Duration(seconds: 3),
          onDismissCallback: (type) {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => MainPage()),
            );
          }).show();
    }
  }
  void _openDialog(context) {

  }
}
