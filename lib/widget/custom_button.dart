import 'package:flutter/material.dart';

class CustomButton extends StatefulWidget {
  final String title;
  final VoidCallback onPressed;
  final bool disabled;

  const CustomButton(
      {required this.title,
      required this.onPressed,
      this.disabled = false,
      super.key});

  @override
  State<StatefulWidget> createState() => _CustomButtonState();


}

class _CustomButtonState extends State<CustomButton> {
  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: SizedBox(
            height: 48,
            child: ElevatedButton(
              onPressed:  widget.disabled ? null : widget.onPressed,
              style: ButtonStyle(
                shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                  RoundedRectangleBorder(
                    borderRadius:
                    BorderRadius.circular(4), // Adjust the radius as needed
                  ),
                ),
              ),
              child: Text(
                widget.title,
                style: Theme.of(context).textTheme.displayLarge!.copyWith(
                    color: Colors.white,
                    fontWeight: FontWeight.w400,
                    fontSize: 20),
              ),
            ),
          ),
        ),
      ],
    );
  }
}