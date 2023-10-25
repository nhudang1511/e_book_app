import 'package:flutter/material.dart';

class CustomTextField extends StatelessWidget {
  final String hint;

  const CustomTextField({required this.hint, super.key});
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 32, top: 32, right: 32),
      child: TextField(
        decoration: InputDecoration(
          hintText: hint,
          hintStyle: Theme.of(context).textTheme.labelSmall,
        ),
      ),
    );
  }

}