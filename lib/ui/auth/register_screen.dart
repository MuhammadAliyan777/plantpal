import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../../route.dart';
import '../../widgets/button.dart';
import '../../widgets/text_field.dart';

class RegisterScreen extends StatefulWidget {

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {

  TextEditingController name = TextEditingController();
  TextEditingController email= TextEditingController();
  TextEditingController password= TextEditingController();



  User? currentUser = FirebaseAuth.instance.currentUser;
  @override
  Widget build(BuildContext context) {
    return Scaffold(

      resizeToAvoidBottomInset: false,
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
                      "Register Account",
                      textAlign: TextAlign.center,
                      style: TextStyle(fontWeight: FontWeight.bold, fontSize: 32),
                    ),
                    //Message
                    const SizedBox(height: 30),
                    Text(
                      "Fill Your Details Or Continue with Social Media",
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
                          "Your Name",
                          style: TextStyle(
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    MyTextField(
                      controller: name,
                      hintText: "xxxxxxxxxx",
                      obscureText: false,
                    ),
                    const SizedBox(height: 30),

                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Text(
                          "Email Address",
                          style: TextStyle(
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    MyTextField(
                      controller: email,
                      hintText: "xyz@email.com",
                      obscureText: false,
                    ),
                    const SizedBox(height: 30),

                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Text(
                          "Password",
                          style: TextStyle(
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    MyTextField(
                      controller: password,
                      hintText: "xxxxxxxx",
                      obscureText: true,
                    ),
                    const SizedBox(height: 30),

                    ElevatedButton(
                      onPressed: () {
                        var username = name.text.trim();
                        var useremail = email.text.trim();
                        var userpassword = password.text.trim();

                        FirebaseAuth.instance.createUserWithEmailAndPassword(email: useremail, password: userpassword).whenComplete(() => {
                          FirebaseFirestore.instance.collection("users").doc().set({
                            'name':username,
                            'address':null,
                            'phone_no':null,
                            'user_email':useremail,
                            'password':userpassword,
                            'created_at':DateTime.now(),
                            'user_id':currentUser!.uid,
                          }),
                            Navigator.pushNamed(context, MyRoutes.login)
                        });
                      },
                       child: Text("Signup"),
                    ),
                    const SizedBox(height: 25),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          "Already Have Account? ",
                          style: TextStyle(
                            color: Colors.grey[700],
                          ),
                        ),
                        GestureDetector(
                          onTap: () {

                            Navigator.pushNamed(context, MyRoutes.login);
                          },
                          child: const Text(
                            "Log In",
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