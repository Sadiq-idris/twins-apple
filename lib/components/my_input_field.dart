import 'package:flutter/material.dart';

class MyInputField extends StatelessWidget {
  const MyInputField({
    super.key,
    required this.controller,
    required this.obscureText,
    required this.hintText,
    required this.label,
    this.validator,
    this.focusNode,
    this.maxLines,
    this.keyboardType,
    this.onChanged,
  });

  final TextEditingController controller;
  final bool obscureText;
  final String hintText;
  final Text label;
  final String? Function(String?)? validator;
  final FocusNode? focusNode;
  final int? maxLines;
  final TextInputType? keyboardType;
  final void Function(String)? onChanged;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      obscureText: obscureText,
      focusNode: focusNode,
      validator: validator,
      cursorColor: Theme.of(context).colorScheme.primary,
      maxLines: maxLines??1,
      keyboardType: keyboardType,
      onChanged: onChanged,
      decoration: InputDecoration(
        label: label,
        filled: true,
        hintText: hintText,
        alignLabelWithHint: true,
        fillColor: Theme.of(context).colorScheme.tertiary,
        // border: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: BorderSide.none),
        enabledBorder: const OutlineInputBorder(borderSide: BorderSide.none),
        focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(
              color: Theme.of(context).colorScheme.primary,
              width: 1.5,
            ),
            borderRadius: BorderRadius.circular(10)),
        errorBorder: const OutlineInputBorder(
          borderSide: BorderSide(color: Colors.red),
        ),
        focusedErrorBorder: const OutlineInputBorder(
          borderSide: BorderSide(color: Colors.red, width: 1.5),
        ),
      ),
    );
  }
}
