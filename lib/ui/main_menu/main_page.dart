import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:order_payments/model/user.dart';
import 'package:order_payments/ui/main_menu/investor/history/history_investor.dart';
import 'package:order_payments/ui/main_menu/investor/home/home_investor.dart';
import 'package:order_payments/ui/main_menu/investor/profile/profile_investor.dart';
import 'package:order_payments/ui/main_menu/resto/history/history.dart';
import 'package:order_payments/ui/main_menu/resto/home/home.dart';
import 'package:order_payments/ui/main_menu/umkm/history/history_enterprise.dart';
import 'package:order_payments/ui/main_menu/umkm/home/home_umkm.dart';
import 'package:order_payments/ui/main_menu/resto/profile/profile.dart';
import 'package:order_payments/ui/main_menu/umkm/product/product.dart';
import 'package:order_payments/utils/constant.dart' as Constants;
import 'package:shared_preferences/shared_preferences.dart';

class MainPage extends StatefulWidget {
  const MainPage({Key? key}) : super(key: key);

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  int _selectedIndex = 0;
  User? user;
  var isLoading = false;
  static const List<Widget> _widgetOptionsVendor = <Widget>[
    Home(),
    History(),
    Profile(),
  ];
  static const List<Widget> _widgetOptionUmkm = <Widget>[
    HomeUmkm(),
    HistoryEnterprise(),
    Product(),
    ProfileInvestor(),
  ];
  static const List<Widget> _widgetOptionsInvestor = <Widget>[
    HomeInvestor(),
    HistoryInvestmen(),
    ProfileInvestor(),
  ];
  List<Widget> _widgetOptions = [];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    () async {
      isLoading = true;
      await _getDataUser();
      setState(() {
        // Update your UI with the desired changes.
      });
    }();
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  _getDataUser() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    String? data = prefs.getString('user_data');

    if (data != null) {
      final user_data = jsonDecode(data);
      user = await User.fromJson(user_data);
      print(user?.role);
      if (user?.role == "INVESTOR") {
        _widgetOptions = _widgetOptionsInvestor;
      } else if (user?.role == "ENTERPRISE") {
        print("dia rolenya enterprise");
        _widgetOptions = _widgetOptionUmkm;
      } else if (user?.role == "RESTO") {
        _widgetOptions = _widgetOptionsVendor;
      }
      isLoading = false;
    }
  }

  Widget _buildContainer() {
    if (user!.role == "INVESTOR") {
      return SafeArea(
        child: _widgetOptionsInvestor.elementAt(_selectedIndex),
      );
    } else if (user!.role == "ENTERPRISE") {
      return SafeArea(
        child: _widgetOptionUmkm.elementAt(_selectedIndex),
      );
    } else {
      return SafeArea(
        child: _widgetOptionsVendor.elementAt(_selectedIndex),
      );
    }
  }

  List<BottomNavigationBarItem> _buildNavigationBarItem() {
    if (user!.role == "ENTERPRISE") {
      List<BottomNavigationBarItem> listNavBarItem = [
        BottomNavigationBarItem(
          icon: Icon(Icons.home),
          label: 'Home',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.history),
          label: 'History',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.add_business_sharp),
          label: 'My Product',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.person),
          label: 'Profile',
        ),
      ];
      return listNavBarItem;
    } else {
      List<BottomNavigationBarItem> listNavBarItem = [
        BottomNavigationBarItem(
          icon: Icon(Icons.home),
          label: 'Home',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.history),
          label: 'History',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.person),
          label: 'Profile',
        ),
      ];
      return listNavBarItem;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: isLoading ? CircularProgressIndicator() : _buildContainer(),
      bottomNavigationBar: BottomNavigationBar(
        selectedItemColor: Color(0xFF1F2430),
        showSelectedLabels: false,
        showUnselectedLabels: false,
        unselectedItemColor: Color(0xffD3D3D3),
        items: _buildNavigationBarItem(),
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
      ),
    );
  }
}
