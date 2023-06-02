
import 'dart:convert';

import '../hiveModels/product_model.dart';

class OrderProductModel {

  final String orderId;
  final String productName;
  final String productDesc;
  final int productPrice;
  final String productImage;
  final String vendorId;
  final String userId;
  final String productId;
  final int qty;
  final int totalAmount;
  final bool? isConfirmed;
  final bool isPaid;
  final String timestamp;
  final bool isDelivered;


  OrderProductModel(
      {required this.orderId,
        required this.productId,
        required this.productName,
        this.isConfirmed,
        required this.productDesc,
        required this.productPrice,
        required this.productImage,
        required this.isPaid,
        required this.vendorId,
        required this.userId,
        required this.qty,
        required this.totalAmount, required this.timestamp, required this.isDelivered});

  OrderProductModel.fromJson(Map<dynamic, dynamic> json)
      : orderId = json['orderId'] as String,
        isConfirmed = json['isConfirmed'] as bool?,
        isPaid = json['isPaid'] as bool,
        productId = json['productId'] as String,
        productName = json['productName'] as String,
        productDesc = json['productDesc'] as String,
        productPrice = json['productPrice'] as int,
        productImage = json['productImage'] as String,
        qty = json['qty'] as int,
        totalAmount = json['totalAmount'] as int,
        timestamp = json['timestamp'] as String,
        vendorId = json['vendorId'] as String,
        userId = json['userId'] as String,
        isDelivered = json['isDelivered'] as bool;




  Map<dynamic, dynamic> toJson() => <dynamic, dynamic>{
    'productName': productName,
    'productDesc': productDesc,
    'productPrice': productPrice,
    'productImage': productImage,
    'vendorId' : vendorId,
    'userId' : userId,
    'productId' : productId,
    'qty' : qty,
    'totalAmount' : totalAmount,
    'isConfirmed' : isConfirmed,
    'timestamp' : timestamp,
    "isPaid": isPaid,
    "orderId":orderId,
    "isDelivered":isDelivered
  };

}
