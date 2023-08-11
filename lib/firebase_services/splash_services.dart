import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'dart:async';

import '../route.dart';

class SplashServices{
  void isLogin(BuildContext context) {

    final auth = FirebaseAuth.instance;

    final user = auth.currentUser;

    if(user!=null)
      {
        Timer(const Duration(seconds: 1),
              () => Navigator.pushNamed(context, MyRoutes.login),


        );
      }
    else{
      Timer(const Duration(seconds: 1),
            () => Navigator.pushNamed(context, MyRoutes.home),


      );
    }

  }

}