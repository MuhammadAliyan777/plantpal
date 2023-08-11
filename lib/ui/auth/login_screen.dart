import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import '../../admin/admin_home.dart';
import '../../route.dart';
import '../../widgets/text_field.dart';


class LoginScreen extends StatefulWidget {


  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formkey = GlobalKey<FormState>();
  final emailTextController = TextEditingController();
  final passwordTextController = TextEditingController();

  final _auth = FirebaseAuth.instance;

  void Login(){

    _auth.signInWithEmailAndPassword(email: emailTextController.text, password: passwordTextController.text.toString()).then((value) => {
        if(emailTextController.text=="admin@gmail.com" && passwordTextController.text=="admin123")
          {
            Navigator.pushNamed(context, MyRoutes.admin_home),

          }
        else
          {
            Navigator.pushNamed(context, MyRoutes.home),
          }
    });
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    emailTextController.dispose();
    passwordTextController.dispose();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: SafeArea(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 25.0),
            child: Form(
              key: _formkey,

              child: Column(
                children: [
                  const SizedBox(height: 50),

                  // Main Text
                  const Text(
                    "Hello Again!",
                    textAlign: TextAlign.center,
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 32),
                  ),
                  //Message
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
                        "Email Address",
                        style: TextStyle(
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  MyTextField(

                    controller: emailTextController,
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
                    controller: passwordTextController,
                    hintText: "*********",
                    obscureText: true,
                  ),
                  const SizedBox(height: 10),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Text(
                        "Forget Password",
                        style: TextStyle(
                          color: Colors.grey[700],
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 40),
        ElevatedButton(
        onPressed: (){
          if(_formkey.currentState!.validate()){

          }
          Login();
        },
          child: Text("Login")
  ),

                  const SizedBox(height: 25),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        "Not a member? ",
                        style: TextStyle(
                          color: Colors.grey[700],
                        ),
                      ),
                      GestureDetector(
                        onTap: () {
                          Navigator.pushNamed(context, MyRoutes.register);
                        },
                        child: const Text(
                          "Create Account",
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
    );
  }
}