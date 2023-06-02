import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:intl/intl.dart';
import 'package:lottie/lottie.dart';
import 'package:meal_plan/features/models/product.dart';
import 'package:meal_plan/features/user/cart.dart';

import '../hiveModels/product_model.dart';
import '../models/user.dart';

class ProductDetails extends StatefulWidget {
  const ProductDetails({
    Key? key,
    required this.productModel,
  }) : super(key: key);
  final ProductModel productModel;

  @override
  State<ProductDetails> createState() => _ProductDetailsPageState();
}

class _ProductDetailsPageState extends State<ProductDetails>
    with SingleTickerProviderStateMixin {
  var page = 0;

  late final AnimationController _controller;
  var qty = 1;
  var vendorName = "...";

  bool present = false;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    getVendorName().then((value) => setState(() {
          vendorName = value;
        }));
    _controller = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 500));

    check();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();

    _controller.dispose();
  }

  bool bookmarked = false;

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(
              height: size.height * 0.60,
              width: double.maxFinite,
              child: Stack(
                children: [
                  Hero(
                    tag: widget.productModel.productImage,
                    child: Container(
                      height: size.height * 0.60,
                      decoration: BoxDecoration(
                        borderRadius: const BorderRadius.vertical(
                            bottom: Radius.circular(0)),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.4),
                            spreadRadius: 0,
                            blurRadius: 20,
                            offset: const Offset(0, 10),
                          ),
                        ],
                      ),
                      child: Image.network(
                        widget.productModel.productImage == ""
                            ? "https://thumbs.dreamstime.com/b/food-icon-cafe-fork-spoon-knife-logo-design-isolated-blue-background-food-icon-cafe-fork-spoon-knife-logo-design-219365333.jpg"
                            : widget.productModel.productImage,
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  Positioned(
                    top: 50,
                    left: 0,
                    child: Container(
                      width: MediaQuery.of(context).size.width,
                      child: Row(
                        children: [
                          Container(
                            margin: EdgeInsets.only(left: 20, right: 10),
                            decoration: const BoxDecoration(
                              color: Colors.white,
                              shape: BoxShape.circle,
                            ),
                            child: IconButton(
                              onPressed: () {
                                Navigator.pop(context);
                              },
                              constraints:
                                  const BoxConstraints.tightFor(width: 37),
                              color: Colors.black,
                              icon: const Icon(
                                Icons.arrow_back_ios_new_rounded,
                                size: 22,
                              ),
                            ),
                          ),
                          Spacer(),
                          Container(
                              margin: EdgeInsets.only(right: 20),
                              decoration: const BoxDecoration(
                                color: Colors.white,
                                shape: BoxShape.circle,
                              ),
                              child: GestureDetector(
                                onTap: () {
                                  if (bookmarked == false) {
                                    bookmarked = true;
                                    _controller.forward();
                                  } else {
                                    bookmarked = false;
                                    _controller.reverse();
                                  }
                                },
                                child: Lottie.network(
                                    "https://assets6.lottiefiles.com/packages/lf20_VkOh76.json",
                                    height: 38,
                                    width: 38,
                                    controller: _controller),
                              )),
                        ],
                      ),
                    ),
                  )
                ],
              ),
            ),
            Container(
              transform: Matrix4.translationValues(0.0, -50, 0.0),
              width: MediaQuery.of(context).size.width,
              padding: EdgeInsets.only(left: 20, right: 20, top: 5),
              decoration: const BoxDecoration(
                  color: Colors.white,
                  boxShadow: [
                    BoxShadow(
                        spreadRadius: 0,
                        blurRadius: 0,
                        offset: Offset(0, 12),
                        color: Colors.white)
                  ],
                  borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(30),
                      topRight: Radius.circular(30))),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(
                    width: MediaQuery.of(context).size.width,
                    child: Center(
                      child: Container(
                        margin: const EdgeInsets.only(top: 5.0),
                        height: 4,
                        width: 50,
                        decoration: BoxDecoration(
                            color: Colors.black,
                            borderRadius: BorderRadius.circular(20.0)),
                      ),
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.only(top: 10.0, bottom: 10.0),
                    child: Column(
                      children: [
                        Row(
                          children: [
                            Text(
                              "Sold By: ${vendorName}",
                              style:
                                  TextStyle(color: Colors.blue, fontSize: 16),
                            ),
                            const Spacer(),
                            const Icon(
                              Icons.star_rounded,
                              color: Colors.amber,
                            ),
                            const Text(
                              "4.5",
                              style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 16,
                                  fontWeight: FontWeight.w800),
                            ),
                            const Text(
                              "(4500)",
                              style: TextStyle(
                                color: Colors.grey,
                                fontSize: 13,
                              ),
                            )
                          ],
                        )
                      ],
                    ),
                  ),
                  Text(
                    widget.productModel.productName,
                    style: const TextStyle(
                        fontSize: 20,
                        color: Colors.black,
                        fontWeight: FontWeight.w500),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  Text(
                    widget.productModel.productDesc,
                    maxLines: 6,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(color: Colors.grey),
                  )
                ],
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: Container(
        margin: EdgeInsets.only(left: 30, right: 20, top: 10, bottom: 10),
        height: 50,
        width: double.maxFinite,
        alignment: Alignment.center,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text(
                  "Price",
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
                ),
                const SizedBox(
                  height: 3,
                ),
                Text(
                  "\$ " + widget.productModel.productPrice.toString(),
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w700,
                    color: Theme.of(context).primaryColor,
                  ),
                ),
              ],
            ),
            Container(
              width: 160,
              height: 50,
              child: ElevatedButton(
                  onPressed: () async {


                    if(present){
                      Navigator.of(context).push(MaterialPageRoute(builder: (context) => Cart()));
                    }
                    else{
                      await save();
                      check();
                      ScaffoldMessenger.of(context)
                          .showSnackBar(const SnackBar(content: Text("Added to Cart Successfully..."), backgroundColor: Colors.green,));
                    }




                  },
                  style: ButtonStyle(
                      backgroundColor:
                          MaterialStateProperty.all<Color>(Colors.blue),
                      shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                          RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(50)))),
                  child: Text(
                    present?"Go To Cart": "Add to Cart",
                    style: TextStyle(color: Colors.white),
                  )),
            )
          ],
        ),
      ),
    );
  }

/*
  IconButton(
  onPressed: () {},
  constraints:
  const BoxConstraints.tightFor(width: 37),
  color: Colors.black,
  icon: const Icon(
  Icons.favorite_border_rounded,
  size: 22,
  ),
  isSelected: true,
  selectedIcon: const Icon(
  Icons.favorite_rounded,
  size: 22,
  ),
  ),*/

  Future<String> getVendorName() async {
    final databaseRef = FirebaseDatabase.instance.ref("users");
    late UserModel? user;

    await databaseRef.child(widget.productModel.vendorId).once().then((value) {
      if (value.snapshot.value == null) {
        return "Vendor";
      }

      final json = value.snapshot.value as Map<dynamic, dynamic>;

      user = UserModel.fromJson(json);
      print("User Value Home ${user?.value}");
    });

    if (user == null) {
      return "Vendor";
    } else {
      return user!.name;
    }
  }

  save() async {
    var cart = Hive.box('cart');
    var product = HiveProductModel()
      ..productName = widget.productModel.productName
      ..productPrice = widget.productModel.productPrice
      ..productId = widget.productModel.productId
      ..productDesc = widget.productModel.productDesc
      ..productImage = widget.productModel.productImage
      ..vendorId = widget.productModel.vendorId
      ..qty = qty
      ..totalAmount = widget.productModel.productPrice * qty;

    cart.add(product);
  }


  void check(){
    final Box cartBox;
    cartBox = Hive.box('cart');

    cartBox.keys.map((e) {
      final item = cartBox.get(e) as HiveProductModel;
      print("Item $item");
      if(item.productId == widget.productModel.productId){
        setState(() {
          present = true;
        });

      }
      //return {"cartProductKey": e, "productName": item['productName']};
    }).toList();
    print(present);
  }
}
