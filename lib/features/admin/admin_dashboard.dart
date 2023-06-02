import 'package:flutter/material.dart';
import 'package:meal_plan/features/admin/add_user.dart';
import 'package:meal_plan/features/admin/add_vendor.dart';
import 'package:meal_plan/features/admin/list_users.dart';
import 'package:meal_plan/features/admin/list_vendor.dart';

class AdminDashboard extends StatelessWidget {
  const AdminDashboard({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Meal Plan", style: TextStyle(fontSize: 25),),
      ),
      body: Column(
        children: [
          GestureDetector(
            onTap: () {
              Navigator.of(context).push(MaterialPageRoute(
                  builder: (context) => const ListUsers()));
            },
            child: Container(
              width: MediaQuery.of(context).size.width,
              height: 80,
              margin: const EdgeInsets.all(20),
              child: Card(
                elevation: 5,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20)),
                child: const Align(
                  alignment: Alignment.center,
                  child: Text(
                    "Users",
                    style: TextStyle(fontWeight: FontWeight.w600, fontSize: 25),
                  ),
                ),
              ),
            ),
          ),
          GestureDetector(
            onTap: () {
              Navigator.of(context).push(MaterialPageRoute(
                  builder: (context) => const ListVendors()));
            },
            child: Container(
              width: MediaQuery.of(context).size.width,
              height: 80,
              margin: const EdgeInsets.only(left: 20,right: 20, bottom: 20),
              child: Card(
                elevation: 5,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20)),
                child: const Align(
                  alignment: Alignment.center,
                  child: Text(
                    "Service Providers",
                    style: TextStyle(fontWeight: FontWeight.w600, fontSize: 25),
                  ),
                ),
              ),
            ),
          ),
          GestureDetector(
            onTap: () {
              Navigator.of(context).push(MaterialPageRoute(
                  builder: (context) => const ListVendors()));
            },
            child: Container(
              width: MediaQuery.of(context).size.width,
              height: 80,
              margin: const EdgeInsets.only(left: 20,right: 20, bottom: 20),
              child: Card(
                elevation: 5,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20)),
                child: const Align(
                  alignment: Alignment.center,
                  child: Text(
                    "Orders",
                    style: TextStyle(fontWeight: FontWeight.w600, fontSize: 25),
                  ),
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}
