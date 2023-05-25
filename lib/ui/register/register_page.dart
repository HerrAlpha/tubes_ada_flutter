import 'dart:convert';

import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:order_payments/core/colors.dart';
import 'package:order_payments/core/space.dart';
import 'package:order_payments/core/text_style.dart';
import 'package:order_payments/model/user.dart';
import 'package:order_payments/repository/auth_repository.dart';
import 'package:order_payments/ui/login/component/main_button.dart';
import 'package:order_payments/ui/login/component/text_field.dart';
import 'package:order_payments/ui/login/login_page.dart';
import 'package:order_payments/ui/main_menu/main_page.dart';
import 'package:shared_preferences/shared_preferences.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({Key? key}) : super(key: key);
  @override
  _RegisterPageState createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final _authRepository = new AuthRepository();
  TextEditingController nameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController phoneController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController passwordConfirmationController = TextEditingController();
  final List<String> items = [
    "Vendor",
    "Investor"
  ];
  String? selectedValue;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: blackBG,
      body: Padding(
        padding: EdgeInsets.only(top: 10.0),
        child: SingleChildScrollView(
          padding: EdgeInsets.only(top: 40.0),
          child: Column(
            children: [
              Center(
                child: Text(
                  'Selamat Datang di Aplikasi Investasi!',
                  style: headline1,
                  textAlign: TextAlign.center,
                ),
              ),
              SpaceVH(height: 10.0),
              Text(
                'Silahkan registrasi untuk melanjutkan',
                style: headline3,
              ),
              SpaceVH(height: 20.0),
              TextFieldComponent(
                controller: nameController,
                image: 'user.svg',
                hintTxt: 'Nama',
              ),
              TextFieldComponent(
                controller: emailController,
                image: 'user.svg',
                hintTxt: 'Email',
              ),
              TextFieldComponent(
                controller: phoneController,
                image: 'user.svg',
                hintTxt: 'Phone',
              ),
              SpaceVH(height: 10.0),
              Container(
                decoration: BoxDecoration(
                  color: blackTextFild,
                  borderRadius: BorderRadius.circular(20.0),
                ),
                margin: EdgeInsets.symmetric(horizontal: 20),
                padding: EdgeInsets.symmetric(horizontal: 20),
                width: double.infinity,
                height: 70.0,
                child: DropdownButtonHideUnderline(
                  child: DropdownButton2(
                    hint: Text(
                      'Pilih Role',
                      style: hintStyle,
                    ),
                    items: items
                        .map((item) => DropdownMenuItem<String>(
                      value: item,
                      child: Text(
                        item,
                        style: TextStyle(
                          color: Colors.grey
                        ),
                      ),
                    ))
                        .toList(),
                    value: selectedValue,
                    onChanged: (value) {
                      setState(() {
                        selectedValue = value as String;
                      });
                    },
                    buttonStyleData: const ButtonStyleData(
                      height: 40,

                    ),
                    menuItemStyleData: const MenuItemStyleData(
                      height: 40,
                    ),
                    dropdownStyleData: DropdownStyleData(
                        maxHeight: 200,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(14),
                          color: Color(0xFF1F2430),
                        ),
                        elevation: 8,
                        offset: const Offset(-20, 0),
                        scrollbarTheme: ScrollbarThemeData(
                          radius: const Radius.circular(40),
                          thickness: MaterialStateProperty.all(6),
                          thumbVisibility: MaterialStateProperty.all(true),
                        )),
                  ),
                ),
              ),
              SpaceVH(height: 10.0),
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
                        _submitRegister();
                      },
                      text: 'Sign Up',
                      btnColor: blueButton,
                    ),
                    SpaceVH(height: 20.0),
                    SpaceVH(height: 20.0),
                    TextButton(
                      onPressed: () {},
                      child: RichText(
                        text: TextSpan(children: [
                          TextSpan(
                            text: 'Sudah Punya akun? ',
                            style: headline.copyWith(
                              fontSize: 14.0,
                            ),
                          ),
                          TextSpan(
                            text: ' Klik Disini',
                            style: headlineDot.copyWith(
                              fontSize: 14.0,
                            ),
                            recognizer: TapGestureRecognizer()..onTap = () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(builder: (context) => LoginPage()),
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

  _submitRegister() async {
    var isLoading = true;
    if(isLoading){
      CircularProgressIndicator();
    }

    String role;
    if(selectedValue == "Vendor"){
      role = "RESTO";
    }else{
      role = "INVESTOR";
    }
    var response = await _authRepository.register(nameController.text,emailController.text,phoneController.text,role,passwordController.text);
    isLoading = false;
    if(response["error"] != null){
      print("error");
      AwesomeDialog(
          context: context,
          animType: AnimType.scale,
          dialogType: DialogType.error,
          title: 'Error',
          desc: response["Message"],
          btnOkIcon: Icons.check_circle,
          autoHide: const Duration(seconds: 2)
      ).show();
    }else{
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      prefs.setString('user_data', jsonEncode(response['data']['user']));
      prefs.setString('acces_token', response['data']['token']);
      isLoading = false;
      AwesomeDialog(
          context: context,
          animType: AnimType.scale,
          dialogType: DialogType.success,
          title: 'Success',
          desc:
          'Register Berhasil.',
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
}
