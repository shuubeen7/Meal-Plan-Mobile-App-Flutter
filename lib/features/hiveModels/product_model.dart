import 'package:hive/hive.dart';
part 'product_model.g.dart';

@HiveType(typeId: 0)
class HiveProductModel extends HiveObject {

  @HiveField(0)
  late String productName;
  @HiveField(1)
  late String productDesc;
  @HiveField(2)
  late int productPrice;
  @HiveField(3)
  late String productImage;
  @HiveField(4)
  late String vendorId;
  @HiveField(5)
  late String productId;
  @HiveField(6)
  late int qty;
  @HiveField(7)
  late int totalAmount;


  Map<dynamic, dynamic> toJson() => <dynamic, dynamic>{
    'productName': productName,
    'productDesc': productDesc,
    'productPrice': productPrice,
    'productImage': productImage,
    'vendorId' : vendorId,
    'productId' : productId,
    'qty' : qty,
    'totalAmount' : totalAmount,
  };
}