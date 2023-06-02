import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:meal_plan/features/models/order.dart';
import 'package:meal_plan/features/models/product.dart';

import '../hiveModels/product_model.dart';

class Cart extends StatefulWidget {
  @override
  _CartState createState() => _CartState();
}

class _CartState extends State<Cart> {
  late final Box cartBox;
  int totalAmount = 0;

  bool _isLoading = false;

  // Delete info from people box
  _deleteInfo(int index) {
    cartBox.deleteAt(index);
    print('Item deleted from box at index: $index');
  }

  @override
  void initState() {
    super.initState();
    // Get reference to an already opened box
    cartBox = Hive.box('cart');

    cartBox.keys.map((e) {
      final item = cartBox.get(e) as HiveProductModel;
      print("Item $item");
      setState(() {
        totalAmount += item.totalAmount;
      });
      //return {"cartProductKey": e, "productName": item['productName']};
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('My Cart'),
          backgroundColor: Colors.transparent,
          centerTitle: true,
          iconTheme: const IconThemeData(color: Colors.black),
          shadowColor: Colors.transparent,
          titleTextStyle: const TextStyle(
              color: Colors.black, fontSize: 20, fontWeight: FontWeight.w600),
        ),
        body: ValueListenableBuilder(
          valueListenable: cartBox.listenable(),
          builder: (context, Box box, widget) {
            if (box.isEmpty) {
              return const Center(
                child: Text(
                  'No Meals Added!!',
                  style: TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: 30,
                      color: Colors.blue),
                ),
              );
            } else {
              return SizedBox(
                height: MediaQuery
                    .of(context)
                    .size
                    .height,
                child: ListView.builder(
                  itemCount: box.length,
                  itemBuilder: (context, index) {
                    var currentBox = box;
                    var product = currentBox.getAt(index)! as HiveProductModel;

                    return Container(
                      margin: EdgeInsets.all(10),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: [
                              ClipRRect(
                                borderRadius: BorderRadius.circular(8),
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(15),
                                  child: Image.network(
                                    product.productImage == ""
                                        ? "https://thumbs.dreamstime.com/b/food-icon-cafe-fork-spoon-knife-logo-design-isolated-blue-background-food-icon-cafe-fork-spoon-knife-logo-design-219365333.jpg"
                                        : product.productImage,
                                    height: 90,
                                    width: 90,
                                    fit: BoxFit.cover,
                                  ),
                                ),
                              ),
                              SizedBox(
                                width: 10,
                              ),
                              Container(
                                height: 90,
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisAlignment:
                                  MainAxisAlignment.spaceAround,
                                  children: [
                                    Text(
                                      product.productName.length > 15
                                          ? '${product.productName.substring(
                                          0, 15)}...'
                                          : product.productName,
                                      style: const TextStyle(
                                        fontWeight: FontWeight.w600,
                                        fontSize: 18,
                                      ),
                                    ),
                                    Text(
                                      "\$ ${product.totalAmount.toString()}",
                                      style: const TextStyle(
                                          fontWeight: FontWeight.w600,
                                          fontSize: 20),
                                    )
                                  ],
                                ),
                              )
                            ],
                          ),
                          Column(
                            children: [
                              IconButton(
                                  onPressed: () {
                                    product.qty = product.qty + 1;
                                    product.totalAmount =
                                        product.productPrice * product.qty;
                                    product.save();

                                    setState(() {
                                      totalAmount += product.productPrice;
                                    });
                                  },
                                  icon: const Icon(
                                    Icons.add,
                                    color: Colors.grey,
                                  )),
                              Text(
                                product.qty.toString(),
                                style: const TextStyle(
                                    color: Colors.black,
                                    fontSize: 15,
                                    fontWeight: FontWeight.w600),
                              ),
                              IconButton(
                                  onPressed: () {
                                    product.qty = product.qty - 1;
                                    if (product.qty == 0) {
                                      _deleteInfo(index);
                                      setState(() {
                                        totalAmount -= product.productPrice;
                                      });
                                    }
                                    product.totalAmount =
                                        product.productPrice * product.qty;
                                    product.save();

                                    setState(() {
                                      totalAmount -= product.productPrice;
                                    });
                                  },
                                  icon: const Icon(
                                    Icons.minimize,
                                    color: Colors.grey,
                                  )),
                            ],
                          )
                        ],
                      ),
                    );
                  },
                ),
              );
            }
          },
        ),
        bottomNavigationBar: totalAmount == 0
            ? SizedBox()
            : Container(
            height: 50,
            width: MediaQuery
                .of(context)
                .size
                .width,
            margin: const EdgeInsets.all(20),
            child: ElevatedButton(
              onPressed: () {
                showSheet(totalAmount);
              },
              style: ElevatedButton.styleFrom(
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20))),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "\$ $totalAmount",
                    style: const TextStyle(
                        fontSize: 22, fontWeight: FontWeight.w600),
                  ),
                  const Text(
                    "Proceed to Pay",
                    style: TextStyle(
                        fontSize: 18, fontWeight: FontWeight.w600),
                  ),
                ],
              ),
            )));
  }

  showSheet(int totalAmount) {
    showModalBottomSheet(
      context: context,
      builder: (context) {
        return SizedBox(
          height: 200,
          child: Column(
            children: [
              const SizedBox(
                height: 20,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    "   Amount to pay: ",
                    style: TextStyle(fontWeight: FontWeight.w600, fontSize: 18),
                  ),
                  Text(
                    "\$ $totalAmount   ",
                    style: TextStyle(fontWeight: FontWeight.w600, fontSize: 20),
                  ),
                ],
              ),
              const SizedBox(
                height: 10,
              ),
              RadioListTile(
                title: Text("Cash on Delivery"),
                value: "cash",
                groupValue: "cash",
                onChanged: (value) {
                  setState(() {});
                },
              ),
              SizedBox(
                  height: 45,
                  width: 180,
                  child: ElevatedButton(
                    onPressed: () async {
                      addOrder();
                    },
                    style: ElevatedButton.styleFrom(
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20))),
                    child: const Text("Pay"),
                  ))
            ],
          ),
        );
      },
    );
  }

  void addOrder() async {
    FirebaseAuth auth = FirebaseAuth.instance;

    final databaseRef = FirebaseDatabase.instance.ref("orders");

    //   List<HiveProductModel> products =[];

    await cartBox.keys.map((e) async {
      final item = cartBox.get(e) as HiveProductModel;

      String? orderId = databaseRef
          .push()
          .key;

      OrderProductModel order = OrderProductModel(
          orderId: orderId!,
          productId: item.productId,
          productName: item.productName,
          productDesc: item.productDesc,
          productPrice: item.productPrice,
          productImage: item.productImage,
          isPaid: true,
          vendorId: item.vendorId,
          userId: auth.currentUser!.uid,
          qty: item.qty,
          totalAmount: item.totalAmount,
          isDelivered: false,
          timestamp: DateTime
              .now()
              .microsecondsSinceEpoch
              .toString());

      await databaseRef.child(orderId).set(order.toJson());
    }).toList();

    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
      content: Text("Order placed successfully"),
      backgroundColor: Colors.green,
      duration: Duration(seconds: 2),
    ));

    Navigator.pop(context);
    cartBox.clear();
    Navigator.pop(context);

    setState(() {
      _isLoading = false;
    });
  }
}
