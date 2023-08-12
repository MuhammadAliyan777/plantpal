import 'dart:developer';
import 'dart:math';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:note_app/enums/product_sort_filter_enum.dart';
import 'package:note_app/enums/product_type_enum.dart';
import 'package:note_app/helpers/helper.dart';
import 'package:note_app/models/category.dart';
import 'package:note_app/models/plant_attributes.dart';
import 'package:note_app/models/product.dart';
import 'package:fluid_bottom_nav_bar/fluid_bottom_nav_bar.dart';
import 'package:note_app/widgets/front_bottom_appbar.dart';
import 'package:note_app/widgets/product_card.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:note_app/widgets/splash_screen.dart';

class ShopScreen extends StatefulWidget {
  const ShopScreen({super.key});

  @override
  State<ShopScreen> createState() => _ShopScreenState();
}

class _ShopScreenState extends State<ShopScreen> {
  final String fontFamily = "Nunito";

  // Checker for product fetching
  bool showSplashScreen = true;

  // Bottom appbar
  Widget? _child;

  // Filter
  String selectedCategoryName = "All";
  String selectedProductSortFilter = "Select filter";
  String searchText = "";
  String minPrice = "";
  String maxPrice = "";

  // Lists
  List<Map<String, dynamic>> products = [];
  List<Category> categories = [];
  List<ProductSortFilterEnum> productSortingFilters = [];

  @override
  void initState() {
    super.initState();

    _child = ShopScreen();
    productSortingFilters = ProductSortFilterEnum.values;

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

      // Get category data from 'categories' collection
      String categoryId = productData['category_id'];
      DocumentSnapshot categoryDoc = await FirebaseFirestore.instance
          .collection('categories')
          .doc(categoryId)
          .get();
      Map<String, dynamic> categoryData =
          categoryDoc.data() as Map<String, dynamic>;

      productData['category'] = categoryData;
      productList.add(productData);
    }

    setState(() {
      products = productList;
      categories = getUniqueCategories(products);
      showSplashScreen = false;
    });
  }

  // Filter the products
  void _filterProducts() {
    // Category
    if (selectedCategoryName == "All") {
      setState(() {
        products = products;
      });
    } else {
      setState(() {
        products = products
            .where(
                (product) => product['category_name'] == selectedCategoryName)
            .toList();
      });
    }

    // Product filter
    if (selectedProductSortFilter ==
        ProductSortFilterEnum.price_high_to_low.name) {
      setState(() {
        products.sort((a, b) => b['price'].compareTo(a['price']));
      });
    } else if (selectedProductSortFilter ==
        ProductSortFilterEnum.price_low_to_high.name) {
      setState(() {
        products.sort((a, b) => (a['price']).compareTo(b['price']));
      });
    }

    // Search term
    if (searchText != "") {
      products = products.where((product) {
        String searchTerm = searchText.toLowerCase();
        String productName = product['name'].toLowerCase();
        String categoryName = product['category']['name']!.toLowerCase();
        String description = product['description'].toLowerCase();

        return productName.contains(searchTerm) ||
            categoryName.contains(searchTerm) ||
            description.contains(searchTerm);
      }).toList();
    }

    // Price filter
    if (minPrice != "" || maxPrice != "") {
      products = products.where((product) {
        double productPrice = double.parse(product['price']);
        double minPriceValue = double.tryParse(minPrice) ?? 0;
        double maxPriceValue = double.tryParse(maxPrice) ?? double.infinity;

        return productPrice >= minPriceValue && productPrice <= maxPriceValue;
      }).toList();
    }
  }

  List<Category> getUniqueCategories(List<Map<String, dynamic>> products) {
    Set<Category> uniqueCategories = Set<Category>();

    for (Map product in products) {
      uniqueCategories.add(Category(
          name: product['category']['name'],
          description: product['category']['description']));
    }

    return uniqueCategories.toList();
  }

  void _showFilterBottomSheet(BuildContext context) {
    showModalBottomSheet(
      backgroundColor: Colors.transparent,
      context: context,
      builder: (BuildContext context) {
        return Container(
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
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  // Category filter
                  Padding(
                    padding: EdgeInsets.only(bottom: 20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Text(
                          'Category',
                          style: GoogleFonts.getFont(
                            fontFamily,
                            color: Colors.black,
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        DropdownButton<String>(
                          underline: Divider(
                            color: Colors.green,
                            height: 4,
                          ),
                          value: selectedCategoryName,
                          onChanged: (newValue) {
                            setState(() {
                              selectedCategoryName = newValue!;
                            });
                          },
                          items: [
                            DropdownMenuItem<String>(
                              key:
                                  Key('All'), // Unique key for the "All" option
                              value: 'All', // Unique key for the "All" option
                              child: Text(
                                'All',
                                style: GoogleFonts.getFont(fontFamily),
                              ),
                            ),
                            ...categories.map<DropdownMenuItem<String>>(
                              (Category category) {
                                return DropdownMenuItem<String>(
                                  key: Key(category
                                      .name), // Unique key for each category
                                  value: category.name,
                                  child: Text(
                                    category.name,
                                    style: GoogleFonts.getFont(fontFamily),
                                  ),
                                );
                              },
                            ).toList(),
                          ],
                        )
                      ],
                    ),
                  ),

                  // Product sorting filter
                  Padding(
                    padding: EdgeInsets.only(bottom: 20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Text(
                          'Filter by',
                          style: GoogleFonts.getFont(
                            fontFamily,
                            color: Colors.black,
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        DropdownButton<String>(
                          underline: Divider(
                            color: Colors.green,
                            height: 4,
                          ),
                          value: selectedProductSortFilter,
                          onChanged: (newValue) {
                            setState(() {
                              selectedProductSortFilter = newValue!;
                            });
                          },
                          items: [
                            DropdownMenuItem<String>(
                              key: Key(
                                  'Select filter'), // Unique key for the "All" option
                              value: 'Select filter',
                              enabled: false,
                              child: Text(
                                'Select filter',
                                style: GoogleFonts.getFont(fontFamily),
                              ),
                            ),
                            ...productSortingFilters
                                .map<DropdownMenuItem<String>>(
                              (ProductSortFilterEnum filter) {
                                return DropdownMenuItem<String>(
                                  key: Key(filter
                                      .name), // Unique key for each category
                                  value: filter.name,
                                  child: Text(
                                    snakeCaseToNormalText(filter.name),
                                    style: GoogleFonts.getFont(fontFamily),
                                  ),
                                );
                              },
                            ).toList(),
                          ],
                        )
                      ],
                    ),
                  ),

                  Padding(
                      padding: EdgeInsets.only(bottom: 20),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Price',
                            style: GoogleFonts.getFont(
                              fontFamily,
                              color: Colors.black,
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          SizedBox(height: 10),
                          Row(children: [
                            // Min price
                            Expanded(
                              child: Container(
                                padding: EdgeInsets.symmetric(
                                    vertical: 5, horizontal: 10),
                                decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(20),
                                    border: Border.all(
                                        color: Colors.green, width: 3)),
                                child: TextField(
                                  onChanged: (value) {
                                    setState(() {
                                      minPrice = value;
                                    });
                                  },
                                  keyboardType: TextInputType.number,
                                  style: GoogleFonts.getFont(fontFamily,
                                      color: Colors.black),
                                  decoration: InputDecoration(
                                    hintText: 'Min price',
                                    border: InputBorder.none,
                                    filled: true,
                                    fillColor: Colors.white,
                                  ),
                                ),
                              ),
                            ),

                            SizedBox(
                              width: 20,
                            ),

                            // Max price
                            Expanded(
                              child: Container(
                                padding: EdgeInsets.symmetric(
                                    vertical: 5, horizontal: 10),
                                decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(20),
                                    border: Border.all(
                                        color: Colors.green, width: 3)),
                                child: TextField(
                                  onSubmitted: (value) {
                                    setState(() {
                                      maxPrice = value;
                                    });
                                  },
                                  style: GoogleFonts.getFont(fontFamily,
                                      color: Colors.black),
                                  keyboardType: TextInputType.number,
                                  decoration: InputDecoration(
                                    hintText: 'Max price',
                                    border: InputBorder.none,
                                    filled: true,
                                    fillColor: Colors.white,
                                  ),
                                ),
                              ),
                            ),
                          ]),
                        ],
                      )),

                  Expanded(
                    child: GestureDetector(
                      onTap: () {
                        _filterProducts();
                        Navigator.pop(context); // Close the bottom sheet
                      },
                      child: Container(
                        margin: EdgeInsets.only(top: 20),
                        padding: EdgeInsets.all(20),
                        decoration: BoxDecoration(
                            color: Colors.green,
                            borderRadius: BorderRadius.circular(200)),
                        child: Text(
                          "Filter",
                          style: GoogleFonts.getFont(fontFamily,
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                              color: Colors.white),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ),
                  ),
                ],
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
                "Shop",
                style: GoogleFonts.getFont(fontFamily,
                    color: Colors.black,
                    fontSize: 24,
                    fontWeight: FontWeight.bold),
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
            body: Container(
              padding: EdgeInsets.all(40.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Expanded(
                        // Search
                        child: Container(
                          padding: EdgeInsets.symmetric(
                              vertical: 10, horizontal: 15),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(20),
                            boxShadow: [
                              BoxShadow(color: Colors.black12, blurRadius: 10)
                            ],
                          ),
                          child: TextField(
                            onSubmitted: (value) {
                              setState(() {
                                searchText = value;
                              });
                            },
                            style: GoogleFonts.getFont(fontFamily,
                                color: Colors.black),
                            decoration: InputDecoration(
                              prefixIcon: Icon(
                                Icons.search,
                                color: Colors.grey,
                              ),
                              hintText: 'Search plants & accessories',
                              border: InputBorder.none,
                              filled: true,
                              fillColor: Colors.white,
                            ),
                          ),
                        ),
                      ),
                      SizedBox(width: 20),
                      Container(
                        padding: EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          color: Colors.green,
                          borderRadius: BorderRadius.circular(2000),
                        ),
                        child: IconButton(
                          onPressed: () => _showFilterBottomSheet(context),
                          color: Colors.white,
                          icon: Icon(Icons.filter_alt),
                          splashRadius: 20,
                        ),
                      )
                    ],
                  ),
                  SizedBox(
                    height: 40,
                  ),
                  Expanded(
                    child: StaggeredGridView.countBuilder(
                      crossAxisCount: 2,
                      itemCount: products.length,
                      staggeredTileBuilder: (index) => StaggeredTile.fit(1),
                      itemBuilder: (context, index) {
                        return Padding(
                          padding: const EdgeInsets.all(5.0),
                          child: ProductCard(
                              product: products[index], fontFamily: fontFamily),
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
          );
  }
}
