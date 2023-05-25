import 'package:flutter/material.dart';

Widget LoadingIndicator(context) {
  return Container(
    width: MediaQuery.of(context).size.width,
    child: Padding(
      padding: const EdgeInsets.all(8.0),
      child: Center(child: CircularProgressIndicator()),
    ),
  );
}