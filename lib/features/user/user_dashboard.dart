import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:meal_plan/features/user/cart.dart';
import 'package:meal_plan/features/user/product_details.dart';
import 'package:meal_plan/features/vendor/list_products.dart';

import '../models/product.dart';

class UserDashboard extends StatefulWidget {
  const UserDashboard({Key? key}) : super(key: key);

  @override
  State<UserDashboard> createState() => _UserDashboardState();
}

class _UserDashboardState extends State<UserDashboard> {
  List<ProductModel> products = [];

  @override
  void initState() {
    getProducts();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(10.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(
                height: 40,
              ),
              const Text(
                "Get your",
                style: TextStyle(color: Colors.grey, fontSize: 15),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    "Meal Plan!",
                    style: TextStyle(
                        color: Colors.blue,
                        fontSize: 30,
                        fontWeight: FontWeight.w600),
                  ),
                  ValueListenableBuilder<Box>(
                    valueListenable: Hive.box('cart').listenable(),
                    builder: (BuildContext context, value, Widget? child) {
                      return Stack(
                        children: [
                          IconButton(
                            color: Colors.blue,
                            onPressed: () {
                              Navigator.of(context).push(
                                  MaterialPageRoute(builder: (context) => Cart()));
                            },
                            icon: const Icon(
                              Icons.shopping_cart,
                              size: 30,
                            ),
                          ),
                          Positioned(
                            child: Text(
                              value.length.toString(),
                              style: const TextStyle(
                                  color: Colors.blue,
                                  fontWeight: FontWeight.w600,
                                  fontSize: 15),
                            ),
                            right: 3,
                          )
                        ],
                      );
                    },
                  )
                ],
              ),
              const SizedBox(
                height: 20,
              ),
              Container(
                height: 150,
                child: ListView(
                  scrollDirection: Axis.horizontal,
                  physics: PageScrollPhysics(),
                  children: [
                    Container(
                      width: MediaQuery.of(context).size.width * 0.8,
                      height: 150,
                      child: Card(
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10)),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(8),
                          child: Image.network(
                            "https://images.squarespace-cdn.com/content/v1/5a0b700329f1871d181e96ae/1519365497321-VF57ZZUDRZHZF3URA1NO/recipes+banner+.jpg?format=1500w",
                            height: 150,
                            fit: BoxFit.fill,
                          ),
                        ),
                      ),
                    ),
                    Container(
                      width: MediaQuery.of(context).size.width * 0.8,
                      height: 150,
                      child: Card(
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10)),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(8),
                          child: Image.network(
                            "https://c8.alamy.com/comp/2D4Y728/traditional-indian-cuisine-indian-recipes-food-various-panorama-banner-2D4Y728.jpg",
                            height: 150,
                            fit: BoxFit.fill,
                          ),
                        ),
                      ),
                    ),
                    Container(
                      width: MediaQuery.of(context).size.width * 0.8,
                      height: 150,
                      child: Card(
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10)),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(8),
                          child: Image.network(
                            "https://www.shutterstock.com/image-photo/food-background-black-kitchen-table-260nw-1750457477.jpg",
                            height: 150,
                            fit: BoxFit.fill,
                          ),
                        ),
                      ),
                    ),
                    Container(
                      width: MediaQuery.of(context).size.width * 0.8,
                      height: 150,
                      child: Card(
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10)),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(8),
                          child: Image.network(
                            "https://www.daburhoney.com/images/recipes-category-banner.jpg",
                            height: 150,
                            fit: BoxFit.fill,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              const Text(
                "Popular Now",
                style: TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 20,
                    color: Colors.black),
              ),
              const SizedBox(
                height: 15,
              ),
              products.isEmpty
                  ? const Text(
                      "No Meals Yet!",
                      style:
                          TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
                    )
                  : SizedBox(
                      height: 140,
                      child: ListView.builder(
                        physics: const BouncingScrollPhysics(),
                        scrollDirection: Axis.horizontal,
                        itemBuilder: (context, index) {
                          return GestureDetector(
                            onTap: () {
                              Navigator.of(context).push(MaterialPageRoute(
                                  builder: (context) => ProductDetails(
                                        productModel: products[index],
                                      )));
                            },
                            child: SizedBox(
                              width: 140,
                              height: 140,
                              child: Card(
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(15)),
                                child: Stack(
                                  children: [
                                    ClipRRect(
                                      borderRadius: BorderRadius.circular(15),
                                      child: Image.network(
                                        products[index].productImage == ""
                                            ? "https://thumbs.dreamstime.com/b/food-icon-cafe-fork-spoon-knife-logo-design-isolated-blue-background-food-icon-cafe-fork-spoon-knife-logo-design-219365333.jpg"
                                            : products[index].productImage,
                                        width: 140,
                                        height: 140,
                                        fit: BoxFit.cover,
                                      ),
                                    ),
                                    Container(
                                      height: 140,
                                      width: 140,
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(15),
                                        color: Colors.black12,
                                      ),
                                    ),
                                    Positioned(
                                        bottom: 5,
                                        left: 10,
                                        child: Text(
                                          products[index].productName.length > 15
                                              ? '${products[index].productName.substring(
                                              0, 15)}...'
                                              : products[index].productName,
                                          style: const TextStyle(
                                              fontSize: 15,
                                              color: Colors.white,
                                              fontWeight: FontWeight.w600),
                                        ))
                                  ],
                                ),
                              ),
                            ),
                          );
                        },
                        itemCount: products.length > 5 ? 5 : products.length,
                      ),
                    ),
              const SizedBox(
                height: 20,
              ),
              const Text(
                "Recommended",
                style: TextStyle(
                  fontWeight: FontWeight.w600,
                  fontSize: 20,
                ),
              ),
              products.isEmpty
                  ? const Text(
                      "No Meals Yet!",
                      style:
                          TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
                    )
                  : ListView.builder(
                      shrinkWrap: true,
                      physics: BouncingScrollPhysics(),
                      scrollDirection: Axis.vertical,
                      itemBuilder: (context, index) {
                        return GestureDetector(
                          onTap: () {
                            Navigator.of(context).push(MaterialPageRoute(
                                builder: (context) => ProductDetails(
                                      productModel: products[index],
                                    )));
                          },
                          child: Card(
                            elevation: 5,
                            margin: const EdgeInsets.only(
                                bottom: 10, left: 5, right: 5),
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(15)),
                            child: Row(
                              children: [
                                Padding(
                                  padding: const EdgeInsets.all(8),
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.circular(8),
                                    child: Image.network(
                                      products[index].productImage == ""
                                          ? "https://thumbs.dreamstime.com/b/food-icon-cafe-fork-spoon-knife-logo-design-isolated-blue-background-food-icon-cafe-fork-spoon-knife-logo-design-219365333.jpg"
                                          : products[index].productImage,
                                      height: 80,
                                      width: 80,
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                ),
                                SizedBox(
                                  width: 10,
                                ),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      products[index].productName.length > 20
                                          ? '${products[index].productName.substring(
                                          0, 20)}...'
                                          : products[index].productName,
                                      style: const TextStyle(
                                          fontWeight: FontWeight.w600,
                                          fontSize: 17),
                                    ),
                                    const SizedBox(
                                      height: 10,
                                    ),
                                    Text(
                                      "\$ ${products[index]
                                              .productPrice}",
                                      style: const TextStyle(
                                          fontWeight: FontWeight.w600,
                                          fontSize: 20,
                                          color: Colors.blue),
                                    ),
                                  ],
                                )
                              ],
                            ),
                          ),
                        );
                      },
                      itemCount: products.length,
                    ),
            ],
          ),
        ),
      ),
    );
  }

  getProducts() async {
    var vendorList = FirebaseDatabase.instance.ref("products");

    await vendorList.onValue.forEach((element) {
      if (!element.snapshot.exists) {
        products.clear();
      } else {
        if (element.snapshot.value == null) {
          products.clear();
        } else {
          Map<dynamic, dynamic> values = element.snapshot.value as Map;
          print("Values${values.keys}");

          for (var element in values.keys) {
            var productsList = vendorList.child("$element/items");
            productsList.onValue.forEach((element) {
              Map<dynamic, dynamic> values = element.snapshot.value as Map;

              values.forEach((key, value) {
                setState(() {
                  products.add(ProductModel.fromJson(value));
                });

                print("Products ${products}");
              });
            });
          }
        }
      }
    });
  }
}
