import 'package:flutter/material.dart';

class PasswordInput extends StatefulWidget {
  final String hint;
  const PasswordInput({required this.hint, super.key});
  @override
  State<StatefulWidget> createState() => _PasswordInputState();
}

class _PasswordInputState extends State<PasswordInput> {
  bool _passwordVisible = true;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 32, top: 32, right: 32),
      child: TextField(
        obscureText: _passwordVisible,
        decoration: InputDecoration(
            hintText: widget.hint,
            hintStyle: Theme.of(context).textTheme.labelSmall,
            suffixIcon: IconButton(
              icon: Icon(
                _passwordVisible ? Icons.visibility : Icons.visibility_off,
              ),
              onPressed: () {
                setState(() {
                  _passwordVisible = !_passwordVisible;
                });
              },
            )),
      ),
    );
  }
}
