import 'package:flutter/material.dart';

Widget StatusCard(int status) {
  String _statusName = "";
  Color _cardColor = Colors.blueAccent;
  if(status == 1){
    _statusName = "Menunggu Investor";
  }else if (status ==2){
    _statusName = "Pesanan Diproses";
    _cardColor = Colors.indigo;
  }else if (status ==3){
    _statusName = "Pesanan Selesai Dibuat";
    _cardColor = Colors.teal;
  }else if (status ==4){
    _statusName = "Pesanan Selesai";
    _cardColor = Colors.green;
  }else if (status ==5){
    _statusName = "Pesanan Dibatalkan";
    _cardColor = Colors.red;
  }else if (status ==6){
    _statusName = "Menunggu Konfirmasi UMKM";
    _cardColor = Colors.red;
  }
  return Container(
      padding: EdgeInsets.all(5),
      decoration: BoxDecoration(
          color: _cardColor,
          borderRadius: BorderRadius.all(Radius.circular(10))),
      child: Text(
      _statusName,
        style: TextStyle(
            fontSize: 10,
            color: Colors.white,
            fontWeight: FontWeight.w600),
      )
  );
}