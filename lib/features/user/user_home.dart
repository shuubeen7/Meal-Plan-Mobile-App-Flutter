import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:meal_plan/features/admin/admin_dashboard.dart';
import 'package:meal_plan/features/user/cart.dart';
import 'package:meal_plan/features/user/user_dashboard.dart';
import 'package:meal_plan/features/user/user_profile.dart';

class UserHome extends StatefulWidget {
  const UserHome({Key? key}) : super(key: key);

  @override
  State<UserHome> createState() => _UserHomeState();
}

class _UserHomeState extends State<UserHome> {
  int _selectedIndex = 0;
  bool loading = false;

  static final List<Widget> _widgetOptions = [UserDashboard(), UserProfile()];

  @override
  void initState() {
    openBox();
    super.initState();
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: loading
          ? const Center(child: CircularProgressIndicator())
          : _widgetOptions.elementAt(_selectedIndex),
      bottomNavigationBar: BottomNavigationBar(
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: "Home"),
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

  void openBox() async {
    setState(() {
      loading = true;
    });
    await Hive.openBox('cart');

    setState(() {
      loading = false;
    });
  }
}
