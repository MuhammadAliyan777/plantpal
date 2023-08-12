import 'package:flutter/material.dart';

class MyTextField extends StatelessWidget {
  final TextEditingController controller;
  final String hintText;
  final bool obscureText;
  final  validator;
  const MyTextField(
      {super.key,
          this.validator,
        required this.controller,
        required this.hintText,
        required this.obscureText});

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      validator:  validator,
      controller: controller,
      obscureText: obscureText,
      decoration: InputDecoration(
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14.0),
          borderSide: const BorderSide(color: Colors.white),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14.0),
          borderSide: const BorderSide(color: Colors.white),
        ),
        fillColor: Colors.grey.shade100,
        filled: true,
        hintText: hintText,
        hintStyle: TextStyle(color: Colors.grey[500]),
      ),
    );
  }
}