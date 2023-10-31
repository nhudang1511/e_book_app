import 'package:flutter/material.dart';

class CustomEditTextField extends StatelessWidget {
  final String title;
  const CustomEditTextField({required this.title, super.key});


  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(right: 32.0, left: 32.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, style: Theme.of(context).textTheme.headlineSmall,),
          TextField(),
        ],
      ),
    );
  }

}