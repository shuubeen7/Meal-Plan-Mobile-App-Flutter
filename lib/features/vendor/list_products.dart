import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:meal_plan/features/admin/add_user.dart';
import 'package:meal_plan/features/vendor/add_product.dart';
import 'package:meal_plan/features/vendor/edit_product.dart';

import '../models/product.dart';
import '../models/user.dart';

class ListProducts extends StatefulWidget {
  const ListProducts({Key? key}) : super(key: key);

  @override
  State<ListProducts> createState() => _ListProductsState();
}

class _ListProductsState extends State<ListProducts> {
  List<ProductModel> products = [];
  var productsList = FirebaseDatabase.instance
      .ref("products/${FirebaseAuth.instance.currentUser!.uid}/items");

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("List Meals"),
      ),
      floatingActionButton: FloatingActionButton(
          onPressed: () {
            Navigator.of(context).push(
                MaterialPageRoute(builder: (context) => const AddProduct()));
          },
          child: Icon(Icons.add)),
      body: StreamBuilder<DatabaseEvent>(
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
                ? const Center(
                    child: Text(
                    "No Meals Yet!",
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
                  ))
                : ListView.builder(
                    itemBuilder: (context, index) {
                      return InkWell(
                        onTap: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) =>
                                      EditProduct(product: products[index])));
                        },
                        child: Card(
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
                                    products[index].productImage == ""
                                        ? "https://thumbs.dreamstime.com/b/food-icon-cafe-fork-spoon-knife-logo-design-isolated-blue-background-food-icon-cafe-fork-spoon-knife-logo-design-219365333.jpg"
                                        : products[index].productImage,
                                    height: 80,
                                    width: 80,
                                    fit: BoxFit.cover,
                                  ),
                                ),
                              ),
                              Text(products[index].productName),
                              Spacer(),
                              IconButton(
                                  onPressed: () async {
                                    FirebaseAuth auth = FirebaseAuth.instance;
                                    DatabaseReference ref =
                                        FirebaseDatabase.instance.ref(
                                            "products/${auth.currentUser!.uid}/items/${products[index].productId}");
                                    await ref.remove();
                                    ScaffoldMessenger.of(context)
                                        .showSnackBar(const SnackBar(
                                      content: Text("Product Deleted"),
                                      backgroundColor: Colors.red,
                                      duration: Duration(seconds: 2),
                                    ));
                                  },
                                  icon: const Icon(
                                    Icons.delete_rounded,
                                    size: 25,
                                  )),
                              SizedBox(
                                width: 10,
                              )
                            ],
                          ),
                        ),
                      );
                    },
                    itemCount: products.length,
                  );
          }
        },
      ),
    );
  }
}
