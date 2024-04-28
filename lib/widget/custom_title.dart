import 'package:flutter/material.dart';

class CustomTitle extends StatelessWidget {
  final String title1;
  final String title2;

  const CustomTitle({required this.title1, required this.title2, super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          title1,
          style: Theme.of(context).textTheme.displayMedium!.copyWith(
                fontWeight: FontWeight.w600,
                fontSize: 28,
              ),
        ),
        const Text(" "),
        Text(
          title2,
          style: Theme.of(context).textTheme.displayMedium!.copyWith(
                color: Theme.of(context).colorScheme.primary,
                fontWeight: FontWeight.w600,
                fontSize: 28,
              ),
        ),
      ],
    );
  }
}
