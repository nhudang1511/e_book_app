import 'package:flutter/material.dart';

class CustomDash extends StatelessWidget {
  const CustomDash({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(
          left: 32, right: 32),
      child: Container(
        height: 0.5,
        decoration: BoxDecoration(
          color: Theme.of(context)
              .colorScheme
              .secondary,
        ),
      ),
    );
  }
}
