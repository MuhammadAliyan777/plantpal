class OrderModel {
  String orderid;
  String total_price;
  String date;
  String address;
  String zipcode;

  OrderModel(
      {required this.orderid, required this.total_price, required this.date, required this.address, required this.zipcode});

  Map<String, dynamic> toMap() {
    return {"orderid": orderid, "total_price": total_price, "date": date, "address" : address, "zipcode" : zipcode};
  }
}
