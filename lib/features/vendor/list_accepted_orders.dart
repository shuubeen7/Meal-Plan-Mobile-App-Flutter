import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:meal_plan/features/admin/add_user.dart';
import 'package:meal_plan/features/models/order.dart';
import 'package:meal_plan/features/vendor/add_product.dart';
import 'package:meal_plan/features/vendor/edit_product.dart';

import '../models/product.dart';
import '../models/user.dart';

class ListAcceptedOrders extends StatefulWidget {
  const ListAcceptedOrders({Key? key}) : super(key: key);

  @override
  State<ListAcceptedOrders> createState() => _ListAcceptedOrdersState();
}

class _ListAcceptedOrdersState extends State<ListAcceptedOrders> {
  List<OrderProductModel> orders = [];
  var orderList = FirebaseDatabase.instance
      .ref("orders")
      .orderByChild("vendorId")
      .equalTo(FirebaseAuth.instance.currentUser!.uid);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamBuilder<DatabaseEvent>(
        stream: orderList.onValue,
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          } else {
            print("List${snapshot.data?.snapshot.value}");
            if (snapshot.data?.snapshot.value == null) {
              orders.clear();
            } else {
              Map<dynamic, dynamic> values =
                  snapshot.data?.snapshot.value as Map;
              orders.clear();
              values.forEach((key, value) {
                var item = OrderProductModel.fromJson(value);

                if (item.isConfirmed != null && item.isConfirmed!) {
                  orders.add(item);
                }
              });
            }

            return orders.isEmpty
                ? const Center(
                    child: Text(
                    "No Orders Yet!",
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
                  ))
                : ListView.builder(
                    reverse: true,
                    shrinkWrap: true,
                    itemBuilder: (context, index) {
                      return Card(
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10)),
                        margin:
                            const EdgeInsets.only(left: 10, right: 10, top: 20),
                        child: Column(
                          children: [
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
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
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    SizedBox(
                                      height: 5,
                                    ),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text(
                                          orders[index].productName.length > 10
                                              ? '${orders[index].productName.substring(0, 10)}...'
                                              : orders[index].productName,
                                          style: const TextStyle(
                                            fontSize: 17,
                                            fontWeight: FontWeight.w600,
                                          ),
                                        ),
                                      ],
                                    ),
                                    SizedBox(
                                      height: 2,
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
                                    SizedBox(
                                      height: 2,
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
                                    SizedBox(
                                      height: 2,
                                    ),
                                    Row(
                                      children: [
                                        const Text(
                                          "On: ",
                                          style: TextStyle(
                                              fontSize: 15,
                                              fontWeight: FontWeight.w200),
                                        ),
                                        Text(
                                          DateFormat.yMMMd().format(
                                            DateTime.fromMicrosecondsSinceEpoch(
                                                int.parse(
                                                    orders[index].timestamp)),
                                          ),
                                          style: const TextStyle(
                                              fontSize: 15,
                                              fontWeight: FontWeight.w600),
                                        )
                                      ],
                                    ),
                                    SizedBox(
                                      height: 2,
                                    ),
                                    Row(
                                      children: [
                                        Text(
                                          orders[index].isDelivered
                                              ? "Delivered"
                                              : "Not Delivered",
                                          style: TextStyle(
                                            fontSize: 15,
                                            fontWeight: FontWeight.w600,
                                            color: orders[index].isDelivered
                                                ? Colors.green
                                                : Colors.red
                                          ),
                                        ),
                                      ],
                                    ),
                                    const SizedBox(
                                      height: 5,
                                    ),
                                  ],
                                ),
                              ],
                            ),
                            Container(
                              alignment: Alignment.centerRight,
                              margin: EdgeInsets.all(10),
                              child: orders[index].isDelivered
                                  ? const SizedBox()
                                  : ElevatedButton(
                                      onPressed: () async{
                                        DatabaseReference ref = FirebaseDatabase.instance
                                            .ref("orders")
                                            .child(orders[index].orderId);
                                        await ref.update({"isDelivered": true});
                                      },
                                      child: const Text("Product Delivered")),
                            )
                          ],
                        ),
                      );
                    },
                    itemCount: orders.length,
                  );
          }
        },
      ),
    );
  }
}
