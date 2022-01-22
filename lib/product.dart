class Product {
  String? productID;
  String? productName;
  String? productDescription;
  String? productPrice;
  String? productQuantity;
  String? productState;
  String? productLoc;

Product({required this.productID,
        required this.productName,
        required this.productDescription,
        required this.productPrice,
        required this.productQuantity,
        required this.productState,
        required this.productLoc});

Product.fromJson(Map<String, dynamic> json) {
  productID = json['productID'];
  productName = json['productName'];
  productDescription = json['productDescription'];
  productPrice = json['productPrice'];
  productQuantity = json['productQuantity'];
  productState = json['productState'];
  productLoc = json['productLoc'];
}

Map<String, dynamic> toJson() {
  final Map<String, dynamic> data = <String, dynamic>{};
  data['productID'] = productID;
  data['productName'] = productName;
  data['productDescription'] = productDescription;
  data['productPrice'] = productPrice;
  data['productQuantity'] = productQuantity;
  data['productState'] = productState;
  data['productLoc'] = productLoc; 
  return data; } 
}