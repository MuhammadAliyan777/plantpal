import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

import '../route.dart';
import '../widgets/button.dart';
import '../widgets/text_field.dart';


class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final nameTextController = TextEditingController();
  final phone = TextEditingController();
  final address = TextEditingController();
  User? currentUser = FirebaseAuth.instance.currentUser;


  File? _image;
  final picker = ImagePicker();

  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<void> updateData() async {
    firebase_storage.Reference ref = await firebase_storage.FirebaseStorage.instance.ref('/images/'+DateTime.now().millisecondsSinceEpoch.toString());
    firebase_storage.UploadTask uploadtask =  ref.putFile(_image!.absolute);
    try {

      var newUrl = await ref.getDownloadURL();
      var name = nameTextController.text.trim();
      var user_address = address.text.trim();
      var user_phone = phone.text.trim();
      QuerySnapshot querySnapshot = await _firestore
          .collection('users')
          .where('user_id', isEqualTo: currentUser!.uid)
          .get();
    print(querySnapshot);
      if (querySnapshot.docs.isNotEmpty) {
        DocumentSnapshot userDocument = querySnapshot.docs[0];
        await userDocument.reference.update({
          'name': name,
          'address': user_address,
          'phone_no': user_phone,
          'image': newUrl.toString(),
          // Add other fields you want to update
        });
      }
      print('Data updated successfully');
    } catch (error) {
      print('Error updating data: $error');
    }
  }

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
    return Scaffold(
      appBar: AppBar(
        foregroundColor: Colors.black,
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: const Icon(Icons.arrow_back_outlined),
        title: const Text(
          "Profile",
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.w700),
        ),

        centerTitle: true,
        actions: const [
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 20, vertical: 20),
            child: Text("Edit"),
          ),
        ],
      ),
      body: SafeArea(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 25.0),
            child: SingleChildScrollView(
              child: Column(
                children: [
                  InkWell(
                    onTap: () {
                      getImageGallery();
                    },
                    child: CircleAvatar(
                      radius: 60,
                      backgroundColor: Colors.grey, // You can set a background color if needed
                      child: _image != null
                          ? Container(
                        width: 120,
                        height: 120,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          image: DecorationImage(
                            image: FileImage(_image!.absolute),
                            fit: BoxFit.cover,
                          ),
                        ),
                      )
                          : Icon(Icons.image),
                    ),
                  ),

                    const SizedBox(height: 6),
                  const Text(
                    "Sameer Ahmed",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w600,
                    ),
                  ),

                  const SizedBox(height: 12),
                    Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Text(
                        "Your Name",
                        style: TextStyle(
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  MyTextField(
                    controller: nameTextController,
                    hintText: "Sameer Ahmed",
                    obscureText: false,
                  ),
                  const SizedBox(height: 12),


                    Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Text(
                        "Address",
                        style: TextStyle(
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  MyTextField(
                    controller: address,
                    hintText: "Karachi, Pakistan",
                    obscureText: true,
                  ),
                  const SizedBox(height: 20),
            ElevatedButton(
    onPressed: () {
      updateData();
    },
            child: Text("Signup"),
          ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}