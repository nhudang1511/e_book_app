import 'package:flutter/material.dart';

class CustomSecondaryTitle extends StatelessWidget {
  final String title;

  const CustomSecondaryTitle({required this.title, super.key});

  @override
  Widget build(BuildContext context) {
    return Text(
      title,
      style: Theme.of(context).textTheme.displaySmall!.copyWith(
            fontWeight: FontWeight.normal,
            fontSize: 16,
          ),
      textAlign: TextAlign.center,
    );
  }
}
