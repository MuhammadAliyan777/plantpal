import 'dart:math';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:test_application/enums/product_type_enum.dart';
import 'package:test_application/models/plant_attributes.dart';
import 'package:test_application/models/product.dart';
import 'package:test_application/widgets/front_bottom_appbar.dart';
import 'package:test_application/widgets/product_card.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final String fontFamily = "Nunito";
  List<Map<String, dynamic>> products = [];

  @override
  void initState() {
    super.initState();

    initializeProducts();
  }

  void initializeProducts() async {
    List<Map<String, dynamic>> productList = [];

    final firestore = FirebaseFirestore.instance;
    final QuerySnapshot querySnapshot =
        await firestore.collection('products').get();

    for (QueryDocumentSnapshot document in querySnapshot.docs) {
      Map<String, dynamic> productData =
          document.data() as Map<String, dynamic>;

      productList.add(productData);
      break;
    }

    setState(() {
      products = productList;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: true,
        elevation: 0,
        backgroundColor: Colors.transparent,
        title: Text(
          "Home",
          style: GoogleFonts.getFont(fontFamily,
              color: Colors.black, fontSize: 24, fontWeight: FontWeight.bold),
        ),
        leading: const Padding(
          padding: EdgeInsets.only(left: 40.0),
          child: Icon(
            Icons.arrow_back,
            color: Colors.black,
          ),
        ),
      ),
      bottomNavigationBar: FrontBottomAppBar(),
      body: SingleChildScrollView(
        child: Container(
          padding: const EdgeInsets.all(40.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Expanded(
                    child: Container(
                      padding:
                          EdgeInsets.symmetric(vertical: 10, horizontal: 15),
                      decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(20),
                          boxShadow: [
                            BoxShadow(color: Colors.black12, blurRadius: 10)
                          ]),
                      child: TextField(
                        style: TextStyle(color: Colors.black),
                        decoration: InputDecoration(
                            prefixIcon: Icon(
                              Icons.search,
                              color: Colors.grey,
                            ),
                            hintText: 'Search plants & accessories',
                            // contentPadding: EdgeInsets.symmetric(vertical: 30),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                              borderSide: BorderSide.none,
                            ),
                            filled: true,
                            fillColor: Colors.white,
                            hoverColor: Colors.white),
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(
                height: 20,
              ),
              Padding(
                padding: const EdgeInsets.only(bottom: 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Plants",
                      style: GoogleFonts.getFont(fontFamily,
                          color: Colors.black,
                          fontSize: 20,
                          fontWeight: FontWeight.bold),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    CarouselSlider(
                      options: CarouselOptions(
                          height: 300,
                          viewportFraction:
                              0.5), // Set to 0.5 for two cards per view),
                      items: products
                          .where((product) =>
                              product['type'] == ProductTypeEnum.plant.name)
                          .map((product) {
                        return Builder(
                          builder: (BuildContext context) {
                            return ProductCard(
                                product: product, fontFamily: fontFamily);
                          },
                        );
                      }).toList(),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Text(
                          "View all",
                          style: GoogleFonts.getFont(fontFamily,
                              color: Colors.green, fontSize: 16),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(bottom: 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Accessories",
                      style: GoogleFonts.getFont(fontFamily,
                          color: Colors.black,
                          fontSize: 20,
                          fontWeight: FontWeight.bold),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    CarouselSlider(
                      options: CarouselOptions(
                          height: 300,
                          viewportFraction:
                              0.5), // Set to 0.5 for two cards per view),
                      items: products
                          .where((product) =>
                              product['type'] ==
                              ProductTypeEnum.accessories.name)
                          .map((product) {
                        return Builder(
                          builder: (BuildContext context) {
                            return ProductCard(
                                product: product, fontFamily: fontFamily);
                          },
                        );
                      }).toList(),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Text(
                          "View all",
                          style: GoogleFonts.getFont(fontFamily,
                              color: Colors.green, fontSize: 16),
                        ),
                      ],
                    ),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
