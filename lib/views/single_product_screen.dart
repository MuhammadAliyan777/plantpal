import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:note_app/models/cart.dart';
import 'package:note_app/widgets/splash_screen.dart';

class SingleProductScreen extends StatefulWidget {
  final String document_id;
  final String current_user_id;

  const SingleProductScreen(
      {super.key, required this.document_id, required this.current_user_id});

  @override
  State<SingleProductScreen> createState() => _SingleProductScreenState();
}

class _SingleProductScreenState extends State<SingleProductScreen> {
  // Cart collection
  final CollectionReference cartCollection =
  FirebaseFirestore.instance.collection('carts');

  // Font family
  final String fontFamily = "Nunito";

  // Product document id
  late String _document_id;

  // Lists
  Map<String, dynamic> product = {};

  // Tooglers
  bool showSplashScreen = false;
  bool showLoadingOnAddToCartBtn = false;

  // Init firestore
  FirebaseFirestore firestoreInstance = FirebaseFirestore.instance;

  @override
  void initState() {
    super.initState();
    _document_id = widget.document_id;
    initializeProduct();
  }

  void initializeProduct() async {
    setState(() {
      showSplashScreen = true;
    });
    try {
      DocumentSnapshot productSnapshot = await firestoreInstance
          .collection('products')
          .doc(_document_id)
          .get();

      setState(() {
        product = productSnapshot.data() as Map<String, dynamic>;
        showSplashScreen = false;
      });
    } catch (e) {
      print(e);
    }
  }

  Future<void> addToCart() async {
    setState(() {
      showLoadingOnAddToCartBtn = true;
    });
    try {
      if (product['stock'] > 0) {
        // Check if the product is already in the cart
        final cartItem = await cartCollection
            .where('product_id', isEqualTo: widget.document_id)
            .where('user_id', isEqualTo: widget.current_user_id)
            .get();

        if (cartItem.docs.isEmpty) {
          // If not, add the product to the cart
          await cartCollection.add(Cart(
              product_id: widget.document_id,
              user_id: widget.current_user_id,
              quantity: 1)
              .toMap());
        } else {
          // If it's already in the cart, update the quantity
          final cartItemId = cartItem.docs[0].id;
          final currentQuantity =
          (cartItem.docs[0].data() as Map<String, dynamic>)['quantity'];
          await cartCollection.doc(cartItemId).update({
            'quantity': currentQuantity + 1,
          });
        }
      } else {
        print("Out of stock");
      }

      // Show a success message or navigate to the cart screen
    } catch (e) {
      print("Add to cart error: $e");
    }

    setState(() {
      showLoadingOnAddToCartBtn = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return showSplashScreen
        ? secondsplash()
        : Scaffold(
        appBar: AppBar(
            automaticallyImplyLeading: true,
            elevation: 0,
            backgroundColor: Colors.transparent,
            leading: Padding(
              padding: const EdgeInsets.only(left: 40.0),
              child: Icon(
                Icons.arrow_back,
                color: Colors.black,
              ),
            ),
            actions: [
              Padding(
                padding: const EdgeInsets.fromLTRB(0, 20, 50, 0),
                child: Text(
                  "Product name",
                  style: GoogleFonts.getFont(fontFamily,
                      color: Colors.black, fontWeight: FontWeight.w600),
                ),
              )
            ]),
        bottomNavigationBar: Container(
          color: Color.fromARGB(255, 175, 247, 177),
          child: Row(
            children: [
              Expanded(
                child: GestureDetector(
                  onTap: showLoadingOnAddToCartBtn
                      ? null
                      : () async => await addToCart(),
                  child: Container(
                    margin:
                    EdgeInsets.symmetric(horizontal: 40, vertical: 20),
                    decoration: BoxDecoration(
                        color: Colors.green,
                        border: Border.all(
                            color: Color.fromARGB(255, 47, 110, 49),
                            width: 2),
                        borderRadius: BorderRadius.circular(20)),
                    padding: EdgeInsets.all(30),
                    child: showLoadingOnAddToCartBtn
                        ? CircularProgressIndicator(
                      color: Colors.white,
                    )
                        : Text(
                      "Buy for \$" + product['price'],
                      textAlign: TextAlign.center,
                      style: GoogleFonts.getFont(fontFamily,
                          fontSize: 20, color: Colors.white),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(50),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Image.network(
                      'https://images.unsplash.com/photo-1520412099551-62b6bafeb5bb?ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D&auto=format&fit=crop&w=687&q=80',
                      width: 100,
                      height: 100,
                      fit: BoxFit.contain,
                      alignment: Alignment.topLeft,
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          product['name'],
                          style: GoogleFonts.getFont(fontFamily,
                              color: Colors.black,
                              fontWeight: FontWeight.bold,
                              fontSize: 24),
                        ),
                      ],
                    )
                  ],
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 20.0),
                  child: Text(
                    product['description'],
                    overflow: TextOverflow.ellipsis,
                    style: GoogleFonts.getFont(
                      fontFamily,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ));
  }
}
