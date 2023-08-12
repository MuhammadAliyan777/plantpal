import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../route.dart';
import '../widgets/text_field.dart';

class UserFeedback extends StatefulWidget {
  const UserFeedback({Key? key}) : super(key: key);

  @override
  State<UserFeedback> createState() => _UserFeedbackState();
}

class _UserFeedbackState extends State<UserFeedback> {
  TextEditingController name = TextEditingController();
  TextEditingController email = TextEditingController();
  TextEditingController feedback = TextEditingController();
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
                      "Feedback Form",
                      textAlign: TextAlign.center,
                      style: TextStyle(fontWeight: FontWeight.bold, fontSize: 32),
                    ),
                    //Message
                    const SizedBox(height: 30),
                    Text(
                      "Drop Your Feedback to improve our services",
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
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter some text';
                        }
                        return null;
                      },
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
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter some text';
                        }
                        return null;
                      },
                      controller: email,
                      hintText: "xyz@email.com",
                      obscureText: false,
                    ),
                    const SizedBox(height: 30),

                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Text(
                          "Feedback",
                          style: TextStyle(
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    MyTextField(
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter some text';
                        }
                        return null;
                      },
                      controller: feedback,
                      hintText: "xxxxxxxx",
                      obscureText: false,
                    ),
                    const SizedBox(height: 30),

                    ElevatedButton(
                      onPressed: () async {
                        var username = name.text.trim();
                        var useremail = email.text.trim();
                        var user_feedback = feedback.text.trim();

                         await FirebaseFirestore.instance.collection("feedback").doc().set({
                            'name':username,
                            'email':useremail,
                            'user_feedback':user_feedback,
                            'user_id':currentUser!.uid,
                          });
                          Navigator.pushNamed(context, MyRoutes.home);
                        },  child: Text("Submit"),),

                ],
    )
    )
    )
    )
    )
    )
    );
  }
}
