class Product {
  String productId;
  String productName;
  String price;
  String amount;

  Product({
    required this.productId,
    required this.productName,
    required this.price,
    required this.amount,
  });

  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(
      productId: json["_id"] as String,
      productName: json["proserName"] as String,
      price: json["proserCost"] as String,
      amount: json["proserCost"] as String,
    );
  }
  // Product.fromJson(Map<String, dynamic> json) {
  //   productId = json['_id'];
  //   productName = json['proserName'];
  //   price = json['proserCost'];
  //   amount = json['productAmount'];
  // }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['_id'] = productId;
    data['proserName'] = productName;
    data['proserCost'] = price;
    data['productAmount'] = amount;
    return data;
  }
}
