import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:order_payments/core/colors.dart';
import 'package:order_payments/core/text_style.dart';

Widget TextFieldComponent({
  required String hintTxt,
  required String image,
  required TextEditingController controller,
  bool isObs = false,
  TextInputType? keyBordType,
}) {
  return Container(
    height: 70.0,
    padding: EdgeInsets.symmetric(horizontal: 30.0),
    margin: EdgeInsets.symmetric(
      horizontal: 20.0,
      vertical: 10.0,
    ),
    decoration: BoxDecoration(
      color: blackTextFild,
      borderRadius: BorderRadius.circular(20.0),
    ),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Expanded(
          child: TextField(
            controller: controller,
            textAlignVertical: TextAlignVertical.center,
            obscureText: isObs,
            keyboardType: keyBordType,
            decoration: InputDecoration(
              border: InputBorder.none,
              hintText: hintTxt,
              hintStyle: hintStyle,
            ),
            style: headline2,
          ),
        ),
        SvgPicture.asset(
          'assets/icon/$image',
          height: 20.0,
          color: grayText,
        )
      ],
    ),
  );
}
