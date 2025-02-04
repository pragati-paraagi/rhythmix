import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

class Loader extends StatelessWidget {
  const Loader({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: SpinKitThreeBounce(
        color: Color(0xff45859d),  // You can customize the color
        size: 50.0,  // You can adjust the size as needed
      ),
    );
  }
}