import 'package:flutter/material.dart';

class CustomTextField extends StatelessWidget {
  final String hint;
  final TextEditingController controller;
  final Function(String) onChanged;

  const CustomTextField(
      {required this.hint,
      super.key,
      required this.controller,
      required this.onChanged});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 32, top: 32, right: 32),
      child: TextFormField(
        controller: controller,
        decoration: InputDecoration(
          hintText: hint,
          hintStyle: Theme.of(context).textTheme.labelSmall,
        ),
        validator: (value) {
          if (hint == "Email") {
            bool emailValid = RegExp(
                    r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
                .hasMatch(value!);
            if (value!.isEmpty) {
              return "Enter Email";
            } else if (!emailValid) {
              return "Enter Valid Email";
            }
          }
        },
        onChanged: onChanged,
      ),
    );
  }
}
