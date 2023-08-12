import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:image_picker/image_picker.dart';

import '../route.dart';
import '../widgets/text_field.dart';

class AdminAccessory extends StatefulWidget {
  const AdminAccessory({Key? key}) : super(key: key);

  @override
  State<AdminAccessory> createState() => _AdminAccessoryState();
}

class _AdminAccessoryState extends State<AdminAccessory> {
  final TextEditingController plantNameController = TextEditingController();
  final TextEditingController speciesController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();
  final TextEditingController priceController = TextEditingController();
  final TextEditingController stockController = TextEditingController();
  User? currentUser = FirebaseAuth.instance.currentUser;
  File? _image;
  final picker = ImagePicker();
  firebase_storage.FirebaseStorage storage = firebase_storage.FirebaseStorage.instance;


  Future<void> getImageGallery() async {
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);
    setState(() {
      _image = pickedFile != null ? File(pickedFile.path) : null;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Accessory"),
        backgroundColor: Colors.blueAccent,
      ),
      body: SafeArea(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 25.0),
            child: Form(
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    const SizedBox(height: 50),

                    // Main Text
                    const Text(
                      "Add Accessory",
                      textAlign: TextAlign.center,
                      style: TextStyle(fontWeight: FontWeight.bold, fontSize: 32),
                    ),
                    //Message
                    const SizedBox(height: 30),
                    Text(
                      "Add the accessories and plants on app",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Colors.grey[700],
                        fontSize: 16,
                      ),
                    ),

                    const SizedBox(height: 30),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Text(
                          "Accessory Name",
                          style: TextStyle(
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    MyTextField(
                      controller: plantNameController,
                      hintText: "eg. cleaner",
                      obscureText: false,
                    ),
                    const SizedBox(height: 30),

                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Text(
                          "Category",
                          style: TextStyle(
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    MyTextField(
                      controller: speciesController,
                      hintText: "eg. african",
                      obscureText: false,
                    ),
                    const SizedBox(height: 30),

                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Text(
                          "Description",
                          style: TextStyle(
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    MyTextField(
                      controller: descriptionController,
                      hintText: "eg. amazing accessory",
                      obscureText: false,
                    ),
                    const SizedBox(height: 12),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Text(
                          "Price",
                          style: TextStyle(
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    MyTextField(
                      controller: priceController,
                      hintText: "eg. 100",
                      obscureText: false,
                    ),
                    const SizedBox(height: 30),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Text(
                          "Stock",
                          style: TextStyle(
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    MyTextField(
                      controller: stockController,
                      hintText: "eg. 33",
                      obscureText: false,
                    ),






                    const SizedBox(height: 30),
                    Center(
                      child: InkWell(
                        onTap: () {
                          getImageGallery();
                        },
                        child: Container(
                          height: 200,
                          width: 200,
                          decoration: BoxDecoration(
                              border: Border.all(color: Colors.black)
                          ),
                          child: _image != null ? Image.file(_image!.absolute) : Center(child: Icon(Icons.image),),
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 39,

                    ),
                    ElevatedButton(
                      onPressed: () async {
                        firebase_storage.Reference ref = firebase_storage.FirebaseStorage.instance.ref('/images/'+DateTime.now().millisecondsSinceEpoch.toString());
                        firebase_storage.UploadTask uploadtask = ref.putFile(_image!.absolute);
                        var name = plantNameController.text.trim();
                        var plant_species = speciesController.text.trim();
                        var plant_description = descriptionController.text.trim();
                        var plant_price = priceController.text.trim();
                        var plant_stock = stockController.text.trim();


                        Future.value(uploadtask).then((value) async {
                          var newUrl = await ref.getDownloadURL();
                          FirebaseFirestore.instance.collection("products").doc().set({
                            'name': name,
                            'category': plant_species,
                            'description': plant_description,
                            'price': plant_price,
                            'stock': plant_stock,
                            'image_url': newUrl.toString(),
                            'type': "accessories",
                            'created_at': DateTime.now(),
                            'created_by': currentUser!.uid,
                          });

                          Navigator.pushNamed(context, MyRoutes.admin_accessories);

                        },
                        );
                      }, child: Text("Add Accessory"),
                    ),

                    const SizedBox(height: 25),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          "Already Added Accessories? ",
                          style: TextStyle(
                            color: Colors.grey[700],
                          ),
                        ),
                        GestureDetector(
                          onTap: () {

                            Navigator.pushNamed(context, MyRoutes.admin_home);
                          },
                          child: const Text(
                            "Add Plants",
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Colors.green,
                            ),
                          ),
                        ),
                      ],
                    )

                  ],
                ),
              ),

            ),
          ),
        ),
      ),

    );



  }
}
