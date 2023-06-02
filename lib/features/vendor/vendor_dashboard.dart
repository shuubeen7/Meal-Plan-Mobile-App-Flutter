import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:meal_plan/features/vendor/list_products.dart';

import '../models/order.dart';
import '../models/product.dart';
import 'package:intl/intl.dart';


class VendorDashboard extends StatefulWidget {
  const VendorDashboard({Key? key}) : super(key: key);

  @override
  State<VendorDashboard> createState() => _VendorDashboardState();
}

class _VendorDashboardState extends State<VendorDashboard> {
  List<OrderProductModel> orders = [];
  var orderList = FirebaseDatabase.instance
      .ref("orders")
      .orderByChild("vendorId")
      .equalTo(FirebaseAuth.instance.currentUser!.uid);

  @override
  Widget build(BuildContext context) {
    List<ProductModel> products = [];
    var productsList = FirebaseDatabase.instance
        .ref("products/${FirebaseAuth.instance.currentUser!.uid}/items")
        .limitToLast(5);

    return Scaffold(
      appBar: AppBar(
        title: Text("Meal Plan"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(10.0),
        child: SingleChildScrollView(
          physics: const ScrollPhysics(),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const Text(
                    "Products",
                    style: TextStyle(fontWeight: FontWeight.w600, fontSize: 25),
                  ),
                  GestureDetector(
                      onTap: () {
                        Navigator.of(context).push(MaterialPageRoute(
                            builder: (context) => const ListProducts()));
                      },
                      child: RichText(
                        text: const TextSpan(
                          children: [
                            TextSpan(
                                text: "View All ",
                                style: TextStyle(
                                    color: Colors.blue, fontSize: 15)),
                            WidgetSpan(
                              child: Icon(
                                Icons.navigate_next,
                                size: 14,
                                color: Colors.blue,
                              ),
                            ),
                          ],
                        ),
                      ))
                ],
              ),
              const SizedBox(
                height: 15,
              ),
              StreamBuilder<DatabaseEvent>(
                stream: productsList.onValue,
                builder: (context, snapshot) {
                  if (!snapshot.hasData) {
                    return const Center(
                      child: CircularProgressIndicator(),
                    );
                  } else {
                    print("List${snapshot.data?.snapshot.value}");
                    if (snapshot.data?.snapshot.value == null) {
                      products.clear();
                    } else {
                      Map<dynamic, dynamic> values =
                          snapshot.data?.snapshot.value as Map;
                      products.clear();
                      values.forEach((key, value) {
                        products.add(ProductModel.fromJson(value));
                      });
                    }

                    return products.isEmpty
                        ? const Text(
                            "No Meals Yet!",
                            style: TextStyle(
                                fontSize: 20, fontWeight: FontWeight.w600),
                          )
                        : SizedBox(
                            height: 120,
                            child: ListView.builder(
                              scrollDirection: Axis.horizontal,
                              itemBuilder: (context, index) {
                                return Container(
                                  width: 120,
                                  height: 120,
                                  child: Card(
                                    shape: RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(10)),
                                    child: Stack(
                                      children: [
                                        ClipRRect(
                                          borderRadius:
                                              BorderRadius.circular(8),
                                          child: Image.network(
                                            products[index].productImage == ""
                                                ? "https://thumbs.dreamstime.com/b/food-icon-cafe-fork-spoon-knife-logo-design-isolated-blue-background-food-icon-cafe-fork-spoon-knife-logo-design-219365333.jpg"
                                                : products[index].productImage,
                                            width: 120,
                                            height: 120,
                                            fit: BoxFit.cover,
                                          ),
                                        ),
                                        Container(
                                          height: 120,
                                          width: 120,
                                          decoration: BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(8),
                                            color: Colors.black12,
                                          ),
                                        ),
                                        Positioned(
                                            bottom: 5,
                                            left: 10,
                                            child: Text(
                                              products[index].productName,
                                              style: TextStyle(
                                                  fontSize: 15,
                                                  color: Colors.white,
                                                  fontWeight: FontWeight.w600),
                                            ))
                                      ],
                                    ),
                                  ),
                                );
                              },
                              itemCount: products.length,
                            ),
                          );
                  }
                },
              ),
              const SizedBox(
                height: 15,
              ),
              const Text(
                "Pending Orders",
                style: TextStyle(
                  fontWeight: FontWeight.w600,
                  fontSize: 25,
                ),
              ),
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

                        if (item.isConfirmed == null) {
                          orders.add(item);
                        }
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
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Row(
                                          children: [
                                            Text(
                                              orders[index].productName.length > 10 ? '${orders[index].productName.substring(0, 10)}...' : orders[index].productName,
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
                                              "\$" + orders[index].totalAmount.toString(),
                                              style: const TextStyle(
                                                  fontSize: 17,
                                                  fontWeight: FontWeight.w600),
                                            )
                                          ],
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
                                              DateFormat.yMd().format(DateTime.fromMicrosecondsSinceEpoch(int.parse(orders[index].timestamp)),
                              ),
                                              style: const TextStyle(
                                                  fontSize: 15,
                                                  fontWeight: FontWeight.w600),
                                            )
                                          ],
                                        )
                                      ],
                                    ),
                                    Spacer(),
                                    IconButton(
                                        onPressed: () async {

                                          DatabaseReference ref = FirebaseDatabase.instance
                                              .ref("orders")
                                              .child(orders[index].orderId);
                                          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                                            content: Text("Order Rejected"),
                                            backgroundColor: Colors.red,
                                            duration: Duration(seconds: 2),
                                          ));
                                         await ref.update({"isConfirmed": false});



                                        },
                                        icon: const Icon(
                                          Icons.close,
                                          size: 25,
                                          color: Colors.red,
                                        )),
                                    IconButton(
                                        onPressed: () async {
                                          DatabaseReference ref = FirebaseDatabase.instance
                                              .ref("orders")
                                              .child(orders[index].orderId);

                                          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                                            content: Text("Order Accepted"),
                                            backgroundColor: Colors.green,
                                            duration: Duration(seconds: 2),
                                          ));

                                          await ref.update({"isConfirmed": true});


                                        },
                                        icon: const Icon(
                                          Icons.check,
                                          size: 25,
                                          color: Colors.green,
                                        )),
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
