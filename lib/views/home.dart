import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:note_app/views/profile_screen.dart';


import '../route.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  TextEditingController name = TextEditingController();
  TextEditingController phone = TextEditingController();
  TextEditingController email= TextEditingController();
  TextEditingController password= TextEditingController();


  User? currentUser = FirebaseAuth.instance.currentUser;
  final auth = FirebaseAuth.instance;



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(

        title: Text("FireBase App"),

        actions: [
          IconButton(onPressed: () {
              auth.signOut().whenComplete(() => {
                Navigator.pushNamed(context, MyRoutes.login),
              });
          }, icon: Icon(Icons.logout_outlined)),
          SizedBox(
            width: 10,
          )
        ],

      ),

        body:  ElevatedButton(onPressed: () { Navigator.pushNamed(context, MyRoutes.feedback); }, child: Text("Feedback"),

        ),
      drawer: Drawer(
            child: ListView(
              padding: EdgeInsets.zero,
              children: [
                const UserAccountsDrawerHeader(
                  currentAccountPicture: CircleAvatar(
                    backgroundImage: NetworkImage(
                        'https://images.unsplash.com/photo-1485290334039-a3c69043e517?crop=entropy&cs=tinysrgb&fit=max&fm=jpg&ixid=MnwxfDB8MXxyYW5kb218MHx8fHx8fHx8MTYyOTU3NDE0MQ&ixlib=rb-1.2.1&q=80&utm_campaign=api-credit&utm_medium=referral&utm_source=unsplash_source&w=300'),
                  ),
                  accountEmail: Text('jane.doe@example.com'),
                  accountName: Text(
                    'Jane Doe',
                    style: TextStyle(fontSize: 24.0),
                  ),
                  decoration: BoxDecoration(
                    color: Colors.black87,
                  ),
                ),
                ListTile(
                  leading: const Icon(Icons.supervised_user_circle),
                  title: const Text(
                    'Profile',
                    style: TextStyle(fontSize: 24.0),
                  ),
                  onTap: () {
                   Navigator.pushNamed(context, MyRoutes.profile);
                  },
                ),
                ListTile(
                  leading: const Icon(Icons.image),
                  title: const Text(
                    'Image',
                    style: TextStyle(fontSize: 24.0),
                  ),
                  onTap: () {
                    Navigator.pushNamed(context, MyRoutes.admin_home);
                  },
                ),
              ],
            ),

      ),
    );
  }
}
