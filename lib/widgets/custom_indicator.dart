import 'package:flutter/material.dart';

// Custom widget used to prevent having empty space or black screen
// in place where GoogleMap widget should be:
class CustomIndicator extends StatelessWidget {
  // Parent's data:
  final double height;

  CustomIndicator({ this.height = double.maxFinite });

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
