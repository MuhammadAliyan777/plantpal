class OrderItem {
  var product;
  String price;
  int quantity;

  OrderItem({
    required this.product,
    required this.price,
    required this.quantity
  });

  Map<String, dynamic> toMap() {
    return {"product": product, "price": price, "quantity": quantity};
  }
}
