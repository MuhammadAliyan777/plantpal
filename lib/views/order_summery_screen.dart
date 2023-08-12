import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:google_fonts/google_fonts.dart';

class OrderSummeryScreen extends StatefulWidget {
  const OrderSummeryScreen({super.key});

  @override
  State<OrderSummeryScreen> createState() => _OrderSummeryScreenState();
}

class _OrderSummeryScreenState extends State<OrderSummeryScreen> {
  final String fontFamily = "Nunito";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        padding: EdgeInsets.all(40.0),
        height: MediaQuery.of(context).size.height,
        color: Colors.green,
        child: Padding(
          padding: const EdgeInsets.all(40),
          child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  children: [
                    Text(
                      "Order sent!",
                      style: GoogleFonts.getFont(fontFamily,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                          fontSize: 32),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    Text(
                      "Thanks for placing the order. We will be looking for your next purchase.",
                      textAlign: TextAlign.center,
                      style: GoogleFonts.getFont(fontFamily,
                          color: Colors.black, fontSize: 16),
                    ),
                  ],
                ),
                Icon(
                  Icons.check_circle,
                  size: 140,
                  color: Colors.white,
                ),
                Row(
                  children: [
                    Expanded(
                      child: GestureDetector(
                        onTap: () {},
                        child: Container(
                          margin: EdgeInsets.only(top: 20),
                          padding: EdgeInsets.all(20),
                          decoration: BoxDecoration(
                              color: Colors.transparent,
                              border: Border.all(color: Colors.white, width: 4),
                              borderRadius: BorderRadius.circular(200)),
                          child: Text(
                            "Download reciept",
                            style: GoogleFonts.getFont(fontFamily,
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                                color: Colors.white),
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ]),
        ),
      ),
    );
  }
}
