import 'package:flutter/material.dart';


   class  secondsplash extends StatelessWidget {
   const secondsplash({Key? key}) : super(key: key);

   @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width,
      height: MediaQuery.of(context).size.height,
      color: Colors.green,
      child: Image.asset('assets/images/logo.png'),
    );
  }
}
