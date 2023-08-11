import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

import '../route.dart';
import '../widgets/text_field.dart';

class AdminHome extends StatefulWidget {
  const AdminHome({Key? key}) : super(key: key);

  @override
  State<AdminHome> createState() => _AdminHomeState();
}

class _AdminHomeState extends State<AdminHome> {
  TextEditingController plant_name = TextEditingController();
  TextEditingController species = TextEditingController();
  TextEditingController description = TextEditingController();
  TextEditingController price = TextEditingController();
  TextEditingController stock = TextEditingController();
  User? currentUser = FirebaseAuth.instance.currentUser;


  File? _image;
  final picker = ImagePicker();

  firebase_storage.FirebaseStorage storage = firebase_storage.FirebaseStorage.instance;

 DatabaseReference databaseRef = FirebaseDatabase.instance.ref('POST');

  Future getImageGallery() async {
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);
    setState(() {
      if(pickedFile != null)
      {
        _image =  File(pickedFile.path);
      }
      else{
        print("No Image Picked");
      }
    });

  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(appBar: AppBar(
      title: Text("Image Upload"),
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
              "Add Plants",
              textAlign: TextAlign.center,
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 32),
            ),
            //Message
            const SizedBox(height: 30),
            Text(
              "Add the plants and accessories on app",
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
                  "Plant Name",
                  style: TextStyle(
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            MyTextField(
              controller: plant_name,
              hintText: "eg. lotus",
              obscureText: false,
            ),
            const SizedBox(height: 30),

            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Text(
                  "Species",
                  style: TextStyle(
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            MyTextField(
              controller: species,
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
              controller: description,
              hintText: "eg. amazing plant",
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
              controller: price,
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
              controller: stock,
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
              var name = plant_name.text.trim();
              var plant_species = species.text.trim();
              var plant_description = description.text.trim();
              var plant_price = price.text.trim();
              var plant_stock = stock.text.trim();

              Future.value(uploadtask).then((value) async {
                var newUrl = await ref.getDownloadURL();
                FirebaseFirestore.instance.collection("plants").doc().set({
                  'plant_name': name,
                  'species': plant_species,
                  'description': plant_description,
                  'price': plant_price,
                  'stock': plant_stock,
                  'image': newUrl.toString(),
                  'created_at': DateTime.now(),
                  'created_by': currentUser!.uid,
                });
              });
              Navigator.pushNamed(context, MyRoutes.admin_home);

            },
            child: Text("Add Plant"),
          ),
          const SizedBox(height: 25),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                "Already Added Plant? ",
                style: TextStyle(
                  color: Colors.grey[700],
                ),
              ),
              GestureDetector(
                onTap: () {

                  Navigator.pushNamed(context, MyRoutes.admin_accessories);
                },
                child: const Text(
                  "Add accessories",
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

