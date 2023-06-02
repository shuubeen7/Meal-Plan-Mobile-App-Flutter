
class ProductModel {
  final String productName;
  final String productDesc;
  final int productPrice;
  final String productImage;
  final String vendorId;
  final String productId;

  ProductModel(
      {required this.productName,
      required this.productDesc,
      required this.productPrice,
      required this.productImage,
      required this.vendorId,
      required this.productId});

  ProductModel.fromJson(Map<dynamic, dynamic> json)
      : productName = json['productName'] as String,
        productDesc = json['productDesc'] as String,
        productPrice = json['productPrice'] as int,
        productImage = json['productImage'] as String,
        vendorId = json['vendorId'] as String,
        productId = json['productId'] as String;


  Map<dynamic, dynamic> toJson() => <dynamic, dynamic>{
    'productName': productName,
    'productDesc': productDesc,
    'productPrice': productPrice,
    'productImage': productImage,
    'vendorId' : vendorId,
    'productId' : productId
  };

}
