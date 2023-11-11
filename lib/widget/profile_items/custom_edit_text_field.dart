import 'package:flutter/material.dart';

class CustomEditTextField extends StatefulWidget {
  final String title;
  final String hint;
  final TextEditingController controller;
  final Function(String) onChanged;

  const CustomEditTextField(
      {required this.title,
      super.key,
      required this.hint,
      required this.controller,
      required this.onChanged});

  @override
  State<StatefulWidget> createState() => CustomEditTextFieldState();
}

class CustomEditTextFieldState extends State<CustomEditTextField> {
  @override
  void initState() {
    super.initState();
    widget.controller.text = widget.hint;
  }
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(right: 32.0, left: 32.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            widget.title,
            style: Theme.of(context).textTheme.headlineSmall,
          ),
          TextFormField(
            controller: widget.controller,
            onChanged: widget.onChanged,
            validator: (value) {
              if(value!.isEmpty) {
                if (widget.hint=='Full Name') {
                  return 'Enter Full Name';
                } else if (widget.hint=='Phone Number') {
                  return 'Phone Number';
                }
              }
            },
          ),
        ],
      ),
    );
  }
}
