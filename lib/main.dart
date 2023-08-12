import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:note_app/admin/admin_accessories.dart';
import 'package:note_app/admin/admin_home.dart';
import 'package:note_app/firebase_options.dart';
import 'package:note_app/route.dart';
import 'package:note_app/ui/splash_screen.dart';
import 'package:note_app/views/home.dart';
import 'package:note_app/views/feedback.dart';
import 'package:note_app/ui/auth/login_screen.dart';
import 'package:note_app/views/profile_screen.dart';
import 'package:note_app/ui/auth/register_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  SharedPreferences prefs = await SharedPreferences.getInstance();
  String userId = prefs.getString('user_id') ?? '';
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(MyApp(userId: userId));
}

class MyApp extends StatelessWidget {

  final String userId;
  MyApp({super.key, required this.userId});

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

      initialRoute: userId.isNotEmpty ? MyRoutes.home : MyRoutes.login,
      routes: {
        MyRoutes.home : (context) => HomeScreen(),
        MyRoutes.login : (context) => LoginScreen(),
        MyRoutes.register : (context) => RegisterScreen(),
        MyRoutes.profile : (context) => ProfileScreen(),
        MyRoutes.admin_home : (context) => AdminHome(),
        MyRoutes.feedback : (context) => UserFeedback(),
      },
    );
  }
}
