import 'package:flutter/material.dart';

class CustomDialogNotice extends StatelessWidget {
  final String content;
  final IconData title;

  const CustomDialogNotice({super.key, required this.title, required this.content});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor:
          Theme.of(context).colorScheme.secondaryContainer!.withOpacity(0.8),
      title: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            title,
            color: Theme.of(context).colorScheme.background,
            size: 32,
          ), // Biểu tượng trong dialog
        ],
      ),
      content: Text(
        content,
        style: Theme.of(context).textTheme.bodySmall, textAlign: TextAlign.center,
      ),
      
    );
  }
}
