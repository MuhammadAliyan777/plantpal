import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:note_app/admin/admin_accessories.dart';
import 'package:note_app/admin/admin_home.dart';
import 'package:note_app/route.dart';
import 'package:note_app/ui/splash_screen.dart';
import 'package:note_app/views/home.dart';
import 'package:note_app/admin/admin_home.dart';
import 'package:note_app/ui/auth/login_screen.dart';
import 'package:note_app/views/profile_screen.dart';
import 'package:note_app/ui/auth/register_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Plants App',
      theme: ThemeData(

        primarySwatch: Colors.blue,
      ),
      home: SplashScreen(),
      routes: {
        MyRoutes.home : (context) => HomeScreen(),
        MyRoutes.login : (context) => LoginScreen(),
        MyRoutes.register : (context) => RegisterScreen(),
        MyRoutes.profile : (context) => ProfileScreen(),
        MyRoutes.admin_home : (context) => AdminHome(),
      },
    );
  }
}
