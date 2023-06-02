import 'dart:ffi';
import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:meal_plan/features/models/product.dart';

import '../admin/admin_home.dart';
import '../user/user_home.dart';

class AddProduct extends StatefulWidget {
  const AddProduct({Key? key}) : super(key: key);

  @override
  State<AddProduct> createState() => _AddProductState();
}

class _AddProductState extends State<AddProduct> {
  var nameController = TextEditingController();
  var descController = TextEditingController();
  var priceController = TextEditingController();

  bool _isLoading = false;
  XFile? image;

  @override
  void dispose() {
    nameController.dispose();
    descController.dispose();
    priceController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Stack(children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                height: 50,
              ),
              Container(
                  margin: EdgeInsets.only(left: 20),
                  child: const Text(
                    "Add Product",
                    style: TextStyle(
                        color: Colors.black,
                        fontSize: 30,
                        fontWeight: FontWeight.w500),
                  )),
              SizedBox(
                height: 20,
              ),
              Container(
                alignment: Alignment.center,
                child: Stack(
                  children: [
                    ClipRRect(
                        borderRadius: BorderRadius.circular(60),
                        child: image != null
                            ? Image.file(
                                File(image!.path),
                                height: 120,
                                width: 120,
                                fit: BoxFit.cover,
                              )
                            : Image.network(
                                "https://thumbs.dreamstime.com/b/food-icon-cafe-fork-spoon-knife-logo-design-isolated-blue-background-food-icon-cafe-fork-spoon-knife-logo-design-219365333.jpg",
                                height: 120,
                                width: 120,
                                fit: BoxFit.cover,
                              )),
                    Positioned(
                        bottom: 3,
                        right: 1,
                        child: GestureDetector(
                            onTap: () async {
                              await _getFromGallery();
                            },
                            child: const Icon(
                              Icons.add_circle,
                              size: 30,
                            )))
                  ],
                ),
              ),
              SizedBox(
                height: 20,
              ),
              Container(
                width: MediaQuery.of(context).size.width,
                margin: EdgeInsets.only(left: 20, right: 30, top: 20),
                child: Column(
                  children: [
                    TextField(
                      controller: nameController,
                      decoration: InputDecoration(
                          prefixIcon: Icon(Icons.add_circle_outline_rounded),
                          focusedBorder: OutlineInputBorder(
                              borderSide:
                                  BorderSide(color: Colors.blue, width: 1.0),
                              borderRadius: BorderRadius.circular(15)),
                          enabledBorder: OutlineInputBorder(
                              borderSide:
                                  BorderSide(color: Colors.grey, width: 1.0),
                              borderRadius: BorderRadius.circular(15)),
                          hintText: "Enter Product Title",
                          hintStyle: TextStyle(color: Colors.grey)),
                      style: TextStyle(
                        fontSize: 15,
                      ),
                      textAlignVertical: TextAlignVertical.center,
                    ),
                    SizedBox(
                      height: 15,
                    ),
                    TextField(
                      controller: descController,
                      maxLines: 5,
                      decoration: InputDecoration(
                          prefixIcon: Icon(Icons.description_outlined),
                          focusedBorder: OutlineInputBorder(
                              borderSide:
                                  BorderSide(color: Colors.blue, width: 1.0),
                              borderRadius: BorderRadius.circular(15)),
                          enabledBorder: OutlineInputBorder(
                              borderSide:
                                  BorderSide(color: Colors.grey, width: 1.0),
                              borderRadius: BorderRadius.circular(15)),
                          hintText: "Enter Product Description",
                          hintStyle: TextStyle(color: Colors.grey)),
                      style: TextStyle(
                        fontSize: 15,
                      ),
                      textAlignVertical: TextAlignVertical.center,
                    ),
                    const SizedBox(
                      height: 15,
                    ),
                    TextField(
                      controller: priceController,
                      keyboardType: TextInputType.number,
                      decoration: InputDecoration(
                          prefixIcon: const Icon(Icons.currency_bitcoin),
                          focusedBorder: OutlineInputBorder(
                              borderSide:
                                  BorderSide(color: Colors.blue, width: 1.0),
                              borderRadius: BorderRadius.circular(15)),
                          enabledBorder: OutlineInputBorder(
                              borderSide:
                                  BorderSide(color: Colors.grey, width: 1.0),
                              borderRadius: BorderRadius.circular(15)),
                          hintText: "Enter Product Price",
                          hintStyle: TextStyle(color: Colors.grey)),
                      style: const TextStyle(
                        fontSize: 15,
                      ),
                      textAlignVertical: TextAlignVertical.center,
                    ),
                  ],
                ),
              ),
              Container(
                width: MediaQuery.of(context).size.width,
                margin: EdgeInsets.only(left: 30, right: 30, top: 30),
                decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      colors: [Color(0xff00b0e9), Color(0xff017be9)],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    borderRadius: BorderRadius.circular(15)),
                child: ElevatedButton(
                    onPressed: () {
                      setState(() {
                        _isLoading = true;
                      });

                      if (nameController.text.isNotEmpty &&
                          descController.text.isNotEmpty &&
                          priceController.text.isNotEmpty) {
                        addProduct();
                      } else {
                        ScaffoldMessenger.of(context)
                            .showSnackBar(const SnackBar(
                          content: Text("Name and desc cannot be empty"),
                          backgroundColor: Colors.red,
                          duration: Duration(seconds: 2),
                        ));
                        setState(() {
                          _isLoading = false;
                        });
                      }
                    },
                    style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.transparent,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(15)),
                        shadowColor: Colors.transparent),
                    child: const Text("Add A Product")),
              ),
              const SizedBox(
                height: 15,
              ),
            ],
          ),
          Container(
            height: MediaQuery.of(context).size.height,
            alignment: Alignment.center,
            child: _isLoading ? CircularProgressIndicator() : SizedBox(),
          )
        ]),
      ),
    );
  }

  uploadImage(XFile imagePath, String vendorId, String productId) async {
    try {
      FirebaseStorage _storage = FirebaseStorage.instance;

      final reference = _storage.ref().child("productImages/$productId");

      String filePath = image!.path;

      File file = File(filePath);

      await reference.putFile(file);

      print("ImageUrl ${reference.getDownloadURL()}");
      //returns the download url
      return reference.getDownloadURL();
    } on FirebaseException catch (e) {
      setState(() {
        _isLoading = false;
      });
    }
  }

  void addProduct() async {
    FirebaseAuth auth = FirebaseAuth.instance;
    String imageUrl;
    String vendorId = auth.currentUser!.uid;
    final databaseRef = FirebaseDatabase.instance
        .ref("products/$vendorId/items");

    String? productId = databaseRef.push().key;

    if (image != null) {
      imageUrl = await uploadImage(image!, vendorId, productId!);
    } else {
      imageUrl = "";
    }

    print("ImageUrl1 $imageUrl");



    ProductModel product = ProductModel(
        productName: nameController.text,
        productDesc: descController.text,
        productPrice: int.parse(priceController.text),
        productImage: imageUrl,
        vendorId: vendorId,
        productId: productId!);

    await databaseRef.child(productId).set(product.toJson());

    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
      content: Text("Product Uploaded"),
      backgroundColor: Colors.green,
      duration: Duration(seconds: 2),
    ));

    Navigator.pop(context);

    setState(() {
      _isLoading = false;
    });
    /* await databaseRef.push().set(
            {'name': name, 'email': email, 'value': 'user', 'isBan': false});*/
  }

  _getFromGallery() async {
    print("Gallery");
    XFile? pickedFile = await ImagePicker().pickImage(
      source: ImageSource.gallery,
      maxWidth: 1800,
      maxHeight: 1800,
    );
    if (pickedFile != null) {
      setState(() {
        image = pickedFile;
      });
    }
  }
}
