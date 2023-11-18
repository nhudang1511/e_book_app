import 'package:flutter/material.dart';

class LogoMedia extends StatelessWidget {
  final Image logo;

  const LogoMedia({required this.logo, super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        border: Border.all(
          color: Theme.of(context).colorScheme.primary,  // Màu của viền
          width: 1.0,          // Độ dày của viền
        ),
        borderRadius: BorderRadius.circular(12.0),
      ),
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: SizedBox(
          height: 52,
          width: 52,
          child: logo,
        ),
      ),
    );
  }
}
