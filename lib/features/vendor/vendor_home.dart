import 'package:flutter/material.dart';
import 'package:meal_plan/features/admin/admin_dashboard.dart';
import 'package:meal_plan/features/user/user_profile.dart';
import 'package:meal_plan/features/vendor/vendor_dashboard.dart';
import 'package:meal_plan/features/vendor/vendor_profile.dart';

import 'list_accepted_orders.dart';
import 'list_orders.dart';


class VendorHome extends StatefulWidget {
  const VendorHome({Key? key}) : super(key: key);

  @override
  State<VendorHome> createState() => _VendorHomeState();
}

class _VendorHomeState extends State<VendorHome> {
  int _selectedIndex = 0;

  static const List<Widget> _widgetOptions = [
    VendorDashboard(),
    ListOrders(),
    VendorProfile()
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _widgetOptions.elementAt(_selectedIndex),
      bottomNavigationBar: BottomNavigationBar(
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: "Home"),
          BottomNavigationBarItem(icon: Icon(Icons.list_outlined), label: "All Orders"),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: "Profile"),
        ],
        type: BottomNavigationBarType.shifting,
        selectedItemColor: Colors.blue,
        elevation: 5,
        currentIndex: _selectedIndex,
        unselectedItemColor: Colors.grey,
        onTap: _onItemTapped,
      ),
    );
  }

}
