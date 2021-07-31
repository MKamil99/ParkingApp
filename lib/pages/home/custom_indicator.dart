import 'package:flutter/material.dart';

class CustomIndicator extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.grey[100],
      child: Center(
        child: CircularProgressIndicator(),
      ),
    );
  }
}
