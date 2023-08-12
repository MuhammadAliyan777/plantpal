import 'dart:html';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:note_app/models/order_item.dart';
import 'package:note_app/models/order_model.dart';
import 'package:note_app/widgets/splash_screen.dart';

class CartScreen extends StatefulWidget {
  final String current_user_id;

  const CartScreen({super.key, required this.current_user_id});

  @override
  State<CartScreen> createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  FirebaseFirestore firestoreInstance = FirebaseFirestore.instance;

  // Checout form key
  GlobalKey<FormState> _checkoutFormKey = new GlobalKey<FormState>();

  // Controllers
  TextEditingController addressController = new TextEditingController();
  TextEditingController zipCodeController = new TextEditingController();

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();

    addressController.dispose();
    zipCodeController.dispose();
  }

  final String fontFamily = "Nunito";
  bool showSplashScreen = true;
  bool showCheckoutLoadingBtn = false;

  // Cart items
  List<Map<String, dynamic>> cartItems = [];
  double totalAmount = 0;

  @override
  void initState() {
    super.initState();
    initializeCartItems();
  }

  void initializeCartItems() async {
    List<Map<String, dynamic>> cartItemList = [];

    final firestoreInstance = FirebaseFirestore.instance;
    final QuerySnapshot querySnapshot = await firestoreInstance
        .collection('carts')
        .where('user_id', isEqualTo: widget.current_user_id)
        .get();

    for (QueryDocumentSnapshot document in querySnapshot.docs) {
      // Get the entire data of the document
      Map<String, dynamic> cartData = document.data() as Map<String, dynamic>;

      String product_id = cartData['product_id'];
      DocumentSnapshot productDoc = await FirebaseFirestore.instance
          .collection('products')
          .doc(product_id)
          .get();
      Map<String, dynamic> productData =
          productDoc.data() as Map<String, dynamic>;

      cartData['product'] = productData;

      cartItemList.add(cartData);
    }

    setState(() {
      cartItems = cartItemList;
      totalAmount = cartItems.fold(
          0,
          (previousValue, element) =>
              previousValue +
              element['quantity'] * double.parse(element['product']['price']));

      showSplashScreen = false;
    });
  }

  Future<void> createOrder() async {
    setState(() {
      showCheckoutLoadingBtn = true;
    });

    if (_checkoutFormKey.currentState!.validate()) {
      try {
        // Check if the product is already in the cart
        final cartItems = await firestoreInstance
              .collection('carts')
              .where('user_id', isEqualTo: widget.current_user_id)
              .get();

        if (!cartItems.docs.isEmpty) {
          // Create order
          String orderId = firestoreInstance.collection('carts').doc().id;

          await FirebaseFirestore.instance.collection('orders').doc().set(
              OrderModel(
                      orderid: orderId,
                      total_price: totalAmount.toString(),
                      date: DateTime.now().toString(),
                      address: addressController.text.trim(),
                      zipcode: zipCodeController.text.trim())
                  .toMap());

          // Create order items and update product quantities
          for (var cartItem in cartItems.docs) {
            Map<String, dynamic> cartItemData =
                cartItem.data() as Map<String, dynamic>;

            DocumentReference productRef = firestoreInstance
                .collection('products')
                .doc(cartItemData['product_id']);
            DocumentSnapshot productSnapshot = await productRef.get();
            Map<String, dynamic> productData =
                productSnapshot.data() as Map<String, dynamic>;

            // Create order item
            await firestoreInstance
                .collection('orders')
                .doc(orderId)
                .collection('order_items')
                .doc()
                .set(OrderItem(
                        product: productRef,
                        price: productData['price'].toString(),
                        quantity: cartItemData['quantity'])
                    .toMap());

            // print(productData['stock']);
            // print(cartItemData['quantity']);
            // Update product quantity (assuming you have a 'products' collection)
            await productRef.update({
              'stock': int.parse(productData['stock']) -
                  int.parse(cartItemData['quantity']),
            });

            // Remove item
            cartItem.reference.delete();
          }
        }

        // Show a success message or navigate to the cart screen
      } catch (e) {
        print("Add to cart error: $e");
      }
    }

    setState(() {
      showCheckoutLoadingBtn = false;
    });
  }

  void _showFillAddressBottomSheet(BuildContext context) {
    showModalBottomSheet(
      backgroundColor: Colors.transparent,
      context: context,
      builder: (BuildContext context) {
        return Container(
          height: 800,
          decoration: BoxDecoration(
            color: Colors.transparent, // Transparent background
          ),
          child: BackdropFilter(
            filter:
                ImageFilter.blur(sigmaX: 10, sigmaY: 10), // Apply blur effect
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white
                    .withOpacity(0.8), // Semi-transparent white background
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(30),
                  topRight: Radius.circular(30),
                ),
              ),
              padding: EdgeInsets.all(30),
              child: Form(
                key: _checkoutFormKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Container(
                      margin: EdgeInsets.only(bottom: 20),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Full Address',
                            style: GoogleFonts.getFont(
                              fontFamily,
                              color: Colors.black,
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          SizedBox(height: 10),
                          Container(
                            padding: EdgeInsets.symmetric(
                                vertical: 5, horizontal: 10),
                            decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(20),
                                border:
                                    Border.all(color: Colors.green, width: 3)),
                            child: TextFormField(
                              controller: addressController,
                              validator: ((value) {
                                if (value == "") return "Address is required";
                              }),
                              keyboardType: TextInputType.number,
                              style: GoogleFonts.getFont(fontFamily,
                                  color: Colors.black),
                              decoration: InputDecoration(
                                hintText: 'Streat address',
                                border: InputBorder.none,
                                filled: true,
                                fillColor: Colors.white,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Container(
                      margin: EdgeInsets.only(bottom: 20),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Zip code',
                            style: GoogleFonts.getFont(
                              fontFamily,
                              color: Colors.black,
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          SizedBox(height: 10),
                          Container(
                            padding: EdgeInsets.symmetric(
                                vertical: 5, horizontal: 10),
                            decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(20),
                                border:
                                    Border.all(color: Colors.green, width: 3)),
                            child: TextFormField(
                              controller: zipCodeController,
                              validator: ((value) {
                                if (value == "") return "Zip code is required";
                              }),
                              keyboardType: TextInputType.streetAddress,
                              style: GoogleFonts.getFont(fontFamily,
                                  color: Colors.black),
                              decoration: InputDecoration(
                                hintText: 'Zip code',
                                border: InputBorder.none,
                                filled: true,
                                fillColor: Colors.white,
                              ),
                            ),
                          ),
                          SizedBox(
                            height: 40,
                          ),
                          Row(
                            children: [
                              Expanded(
                                child: GestureDetector(
                                  onTap:
                                      showCheckoutLoadingBtn || totalAmount == 0
                                          ? null
                                          : () async {
                                              await createOrder();
                                            },
                                  child: showCheckoutLoadingBtn
                                      ? Center(
                                          child: CircularProgressIndicator(
                                              color: Colors.white))
                                      : Container(
                                          margin: EdgeInsets.only(top: 20),
                                          padding: EdgeInsets.all(20),
                                          decoration: BoxDecoration(
                                              color: Colors.green,
                                              borderRadius:
                                                  BorderRadius.circular(200)),
                                          child: Text(
                                            "Checkout",
                                            style: GoogleFonts.getFont(
                                                fontFamily,
                                                fontWeight: FontWeight.bold,
                                                fontSize: 16,
                                                color: Colors.white),
                                            textAlign: TextAlign.center,
                                          ),
                                        ),
                                ),
                              ),
                            ],
                          )
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return showSplashScreen
        ? SplashScreen()
        : Scaffold(
            appBar: AppBar(
              automaticallyImplyLeading: true,
              elevation: 0,
              backgroundColor: Colors.transparent,
              title: Text(
                "Cart",
                style: GoogleFonts.getFont(fontFamily,
                    color: Colors.black,
                    fontSize: 24,
                    fontWeight: FontWeight.bold),
              ),
              leading: Padding(
                padding: const EdgeInsets.only(left: 40.0),
                child: Icon(
                  Icons.arrow_back,
                  color: Colors.black,
                ),
              ),
            ),
            body: Container(
              padding: EdgeInsets.all(40),
              child: ListView.builder(
                  itemCount: cartItems.length,
                  itemBuilder: ((context, index) {
                    return Padding(
                      padding: const EdgeInsets.only(bottom: 20),
                      child: Card(
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10)),
                        elevation: 20,
                        shadowColor: Colors.black26,
                        child: Stack(children: [
                          Padding(
                            padding: const EdgeInsets.all(15.0),
                            child: Row(children: [
                              ClipRRect(
                                borderRadius: BorderRadius.circular(10),
                                child: Container(
                                  color: Colors.black26,
                                  child: Image.network(
                                    'https://placehold.co/60.png',
                                    height: 60,
                                    width: 60,
                                    fit: BoxFit.contain,
                                  ),
                                ),
                              ),
                              SizedBox(width: 15),
                              Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    cartItems[index]['product']['name'],
                                    style: GoogleFonts.getFont(fontFamily,
                                        fontSize: 16,
                                        color: Colors.black,
                                        fontWeight: FontWeight.bold),
                                  ),
                                  SizedBox(height: 10),
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Row(
                                        children: [
                                          GestureDetector(
                                            onTap: () => {},
                                            child: Container(
                                                decoration: BoxDecoration(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            5),
                                                    color: Colors.green[100]),
                                                padding: EdgeInsets.all(2),
                                                child: Icon(
                                                  Icons.remove,
                                                  size: 20,
                                                )),
                                          ),
                                          Padding(
                                            padding: const EdgeInsets.symmetric(
                                                horizontal: 10.0),
                                            child: Text(
                                                cartItems[index]['quantity']
                                                    .toString(),
                                                style: GoogleFonts.getFont(
                                                    fontFamily,
                                                    fontWeight:
                                                        FontWeight.bold)),
                                          ),
                                          GestureDetector(
                                            onTap: () => {},
                                            child: Container(
                                                decoration: BoxDecoration(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            5),
                                                    color: Colors.green),
                                                padding: EdgeInsets.all(2),
                                                child: Icon(
                                                  Icons.add,
                                                  size: 20,
                                                )),
                                          ),
                                        ],
                                      ),
                                      SizedBox(
                                        width: 20,
                                      ),
                                      Text(
                                        "\$" +
                                            (cartItems[index]['quantity'] *
                                                    double.parse(
                                                        cartItems[index]
                                                                ['product']
                                                            ['price']))
                                                .toString(),
                                        style: GoogleFonts.getFont(fontFamily,
                                            fontSize: 16,
                                            color: Colors.black,
                                            fontWeight: FontWeight.bold),
                                      )
                                    ],
                                  )
                                ],
                              )
                            ]),
                          ),
                          Positioned(
                              right: 8,
                              top: 8,
                              child: IconButton(
                                onPressed: () => {},
                                icon: Icon(
                                  Icons.close,
                                  color: Colors.red[200],
                                ),
                                splashRadius: 20,
                              )),
                        ]),
                      ),
                    );
                  })),
            ),
            bottomNavigationBar: Container(
              decoration: BoxDecoration(
                  color: Colors.green,
                  borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(20),
                      topRight: Radius.circular(20))),
              child: Padding(
                padding: EdgeInsets.all(20),
                child: Column(mainAxisSize: MainAxisSize.min, children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "Total",
                        style: GoogleFonts.getFont(fontFamily,
                            fontSize: 20,
                            color: Colors.white,
                            fontWeight: FontWeight.bold),
                      ),
                      Text(
                        "\$${totalAmount}",
                        style: GoogleFonts.getFont(fontFamily,
                            fontSize: 20,
                            color: Colors.white,
                            fontWeight: FontWeight.bold),
                      )
                    ],
                  ),
                  Row(
                    children: [
                      Expanded(
                        child: GestureDetector(
                          onTap: () {
                            _showFillAddressBottomSheet(context);
                          },
                          child: Container(
                            margin: EdgeInsets.only(top: 20),
                            padding: EdgeInsets.all(20),
                            decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(200)),
                            child: Text(
                              "Checkout",
                              style: GoogleFonts.getFont(fontFamily,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16,
                                  color: Colors.green),
                              textAlign: TextAlign.center,
                            ),
                          ),
                        ),
                      ),
                    ],
                  )
                ]),
              ),
            ),
          );
    ;
  }
}
