// ignore_for_file: unnecessary_null_in_if_null_operators
import 'package:flutter/material.dart';

// ignore: must_be_immutable
class CustomTextField extends StatefulWidget {
  final String label;
  final IconData? icon;
  final TextEditingController controller;
  final Function(String)? onChanged;
  final String? Function(String?)? validator;
  final String? content;
  final bool disabled;
  final int? maxLength;
  final int? minLength;
  final TextStyle? labelStyle;
  final IconData? suffixIcon;
  final Function()? onSuffixIcon;
  final bool? isObscureText;

  const CustomTextField({
    super.key,
    required this.label,
    this.icon,
    required this.controller,
    this.onChanged,
    this.content,
    this.disabled = false,
    this.maxLength,
    this.minLength,
    this.validator,
    this.suffixIcon,
    this.onSuffixIcon,
    this.isObscureText,
    this.labelStyle,
  });

  @override
  State<StatefulWidget> createState() => _CustomTextFieldState();
}

class _CustomTextFieldState extends State<CustomTextField> {
  bool _showClearIcon = false;

  @override
  void initState() {
    super.initState();
    if (widget.content != null) {
      widget.controller.text = widget.content!;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 16),
      child: TextFormField(
        maxLength: widget.maxLength ?? null,
        // Check if maxLength is null
        minLines: widget.minLength ?? null,
        controller: widget.controller,
        obscureText: widget.isObscureText == true,
        enabled: !widget.disabled,
        decoration: InputDecoration(
          errorStyle: const TextStyle(
            fontWeight: FontWeight.w100,
            fontSize: 12,
          ),
          errorMaxLines: 3,
          border: const OutlineInputBorder(),
          prefixIcon: widget.icon != null ? Icon(widget.icon) : null,
          suffixIcon: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (_showClearIcon)
                IconButton(
                    onPressed: () {
                      widget.controller.clear();
                      setState(() {
                        _showClearIcon = false;
                      });
                    },
                    icon: const Icon(Icons.clear)),
              if (widget.suffixIcon != null)
                IconButton(
                  onPressed: widget.onSuffixIcon,
                  icon: Icon(widget.suffixIcon),
                ),
            ],
          ),
          labelText: widget.label,
          labelStyle: widget.labelStyle ?? null,
          hintStyle: Theme.of(context).textTheme.bodyLarge,
        ),
        onChanged: (text) {
          setState(() {
            _showClearIcon = widget.controller.text.isNotEmpty;
          });
          widget.onChanged!(text);
        },
        validator: !_showClearIcon ? null : widget.validator,
        autovalidateMode: AutovalidateMode.always,
      ),
    );
  }
}
