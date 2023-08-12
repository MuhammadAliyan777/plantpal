import 'package:cloud_firestore/cloud_firestore.dart';
class Cart {
  var product_id;
  String user_id;
  int quantity;

  Cart(
      {required this.product_id,
      required this.user_id,
      required this.quantity});

  Map<String, dynamic> toMap() {
    return {'product_id': product_id, 'user_id': user_id, 'quantity': quantity};
  }
}
