import 'package:flutter/material.dart';

class CustomIndicator extends StatelessWidget {
  final double height;
  CustomIndicator({ required this.height });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: height,
      color: Colors.grey[100],
      child: Center(
        child: CircularProgressIndicator(),
      ),
    );
  }
}
