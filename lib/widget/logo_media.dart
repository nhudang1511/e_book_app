import 'package:flutter/material.dart';

class LogoMedia extends StatelessWidget {
  final String logo;

  const LogoMedia({required this.logo, super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 72,
      width: 72,
      decoration: const BoxDecoration(
        color: Colors.black38,
      ),
      child: const Icon(
        Icons.facebook_rounded,
        size: 52,
      ),
    );
  }
}
