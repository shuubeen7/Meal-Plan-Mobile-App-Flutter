import 'package:flutter/material.dart';
import 'package:meal_plan/features/vendor/list_accepted_orders.dart';
import 'package:meal_plan/features/vendor/list_rejected_orders.dart';

class ListOrders extends StatelessWidget {
  const ListOrders({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Orders'),
          bottom: const TabBar(
            tabs: [
              Tab(text: "Accepted"),
              Tab(text: "Rejected")
            ],
          ),
        ),
        body: const TabBarView(
          children: [
            ListAcceptedOrders(),
            ListRejectedOrders()
          ],
        ),
      ),
    );
  }
}
