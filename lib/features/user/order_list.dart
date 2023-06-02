import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:meal_plan/features/vendor/list_products.dart';

import '../models/order.dart';
import '../models/product.dart';
import 'package:intl/intl.dart';

class OrderList extends StatefulWidget {
  const OrderList({Key? key}) : super(key: key);

  @override
  State<OrderList> createState() => _OrderListState();
}

class _OrderListState extends State<OrderList> {
  List<OrderProductModel> orders = [];
  var orderList = FirebaseDatabase.instance
      .ref("orders")
      .orderByChild("userId")
      .equalTo(FirebaseAuth.instance.currentUser!.uid);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("My Orders"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(10.0),
        child: SingleChildScrollView(
          physics: const ScrollPhysics(),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              StreamBuilder<DatabaseEvent>(
                stream: orderList.onValue,
                builder: (context, snapshot) {
                  if (!snapshot.hasData) {
                    return const Center(
                      child: CircularProgressIndicator(),
                    );
                  } else {
                    if (snapshot.data?.snapshot.value == null) {
                      orders.clear();
                    } else {
                      Map<dynamic, dynamic> values =
                          snapshot.data?.snapshot.value as Map;
                      orders.clear();
                      values.forEach((key, value) {
                        var item = OrderProductModel.fromJson(value);

                        orders.add(item);
                      });
                    }
                    print("Order List${orders}");
                    return orders.isEmpty
                        ? const Text(
                            "No Orders Yet!",
                            style: TextStyle(
                                fontSize: 20, fontWeight: FontWeight.w600),
                          )
                        : ListView.builder(
                            physics: const NeverScrollableScrollPhysics(),
                            shrinkWrap: true,
                            itemBuilder: (context, index) {
                              return Card(
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10)),
                                margin: const EdgeInsets.only(
                                    left: 10, right: 10, top: 20),
                                child: Row(
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.all(8),
                                      child: ClipRRect(
                                        borderRadius: BorderRadius.circular(8),
                                        child: Image.network(
                                          orders[index].productImage == ""
                                              ? "https://thumbs.dreamstime.com/b/food-icon-cafe-fork-spoon-knife-logo-design-isolated-blue-background-food-icon-cafe-fork-spoon-knife-logo-design-219365333.jpg"
                                              : orders[index].productImage,
                                          height: 80,
                                          width: 80,
                                          fit: BoxFit.cover,
                                        ),
                                      ),
                                    ),
                                    Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Row(
                                          children: [
                                            Text(
                                              orders[index].productName.length >
                                                      15
                                                  ? '${orders[index].productName.substring(0, 15)}...'
                                                  : orders[index].productName,
                                              style: const TextStyle(
                                                fontSize: 17,
                                                fontWeight: FontWeight.w600,
                                              ),
                                            ),
                                          ],
                                        ),
                                        Row(
                                          children: [
                                            const Text(
                                              "Qty: ",
                                              style: TextStyle(
                                                  fontSize: 15,
                                                  fontWeight: FontWeight.w200),
                                            ),
                                            Text(
                                              orders[index].qty.toString(),
                                              style: const TextStyle(
                                                  fontSize: 17,
                                                  fontWeight: FontWeight.w600),
                                            )
                                          ],
                                        ),
                                        Row(
                                          children: [
                                            const Text(
                                              "Total Amount: ",
                                              style: TextStyle(
                                                  fontSize: 15,
                                                  fontWeight: FontWeight.w200),
                                            ),
                                            Text(
                                              "\$" +
                                                  orders[index]
                                                      .totalAmount
                                                      .toString(),
                                              style: const TextStyle(
                                                  fontSize: 17,
                                                  fontWeight: FontWeight.w600),
                                            )
                                          ],
                                        ),
                                        Row(
                                          children: [
                                            const Text(
                                              "Ordered On: ",
                                              style: TextStyle(
                                                  fontSize: 15,
                                                  fontWeight: FontWeight.w200),
                                            ),
                                            Text(
                                              DateFormat.yMd().format(
                                                DateTime
                                                    .fromMicrosecondsSinceEpoch(
                                                        int.parse(orders[index]
                                                            .timestamp)),
                                              ),
                                              style: const TextStyle(
                                                  fontSize: 15,
                                                  fontWeight: FontWeight.w600),
                                            )
                                          ],
                                        ),
                                        Row(
                                          children: [
                                            const Text(
                                              "Status: ",
                                              style: TextStyle(
                                                  fontSize: 15,
                                                  fontWeight: FontWeight.w200),
                                            ),
                                            Text(
                                              orders[index].isConfirmed == null
                                                  ? "Confirmation Pending..."
                                                  : orders[index].isConfirmed ==
                                                              true &&
                                                          orders[index]
                                                              .isDelivered
                                                      ? "Order Delivered"
                                                      : orders[index]
                                                              .isConfirmed!
                                                          ? "Order Confirmed"
                                                          : "Order Rejected",
                                              style: TextStyle(
                                                  fontSize: 15,
                                                  fontWeight: FontWeight.w600,
                                                  color: orders[index]
                                                              .isConfirmed ==
                                                          null
                                                      ? Colors.blue
                                                      : orders[index]
                                                                  .isConfirmed ==
                                                              true
                                                          ? Colors.green
                                                          : Colors.red),
                                            )
                                          ],
                                        )
                                      ],
                                    ),
                                  ],
                                ),
                              );
                            },
                            itemCount: orders.length,
                          );
                  }
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
