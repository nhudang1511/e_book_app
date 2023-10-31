import 'package:flutter/material.dart';

class CustomButton extends StatelessWidget {
  final String title;
  final VoidCallback onPressed;

  const CustomButton({required this.title,required this.onPressed, super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(
        left: 32,
        right: 32,
      ),
      child: Row(
        children: [
          Expanded(
            child: SizedBox(
              height: 48,
              child: ElevatedButton(
                onPressed: onPressed,
                style: ButtonStyle(
                  shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                    RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(
                          100), // Adjust the radius as needed
                    ),
                  ),
                ),
                child: Text(
                  title,
                  style: Theme.of(context).textTheme.displayLarge!.copyWith(
                      color: Colors.white,
                      fontWeight: FontWeight.w500,
                      fontSize: 24),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
