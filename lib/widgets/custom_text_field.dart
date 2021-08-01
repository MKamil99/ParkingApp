import 'package:flutter/material.dart';

class CustomTextField extends StatelessWidget {
  // Parent's data:
  final String label;
  final int maxChars;
  final Function updateValue;

  CustomTextField({
    required this.label,
    required this.maxChars,
    required this.updateValue,
  });

  @override
  Widget build(BuildContext context) {
    return TextField(
      decoration: InputDecoration(labelText: label),
      onChanged: (str) => updateValue(str),
      maxLength: maxChars,
    );
  }
}
