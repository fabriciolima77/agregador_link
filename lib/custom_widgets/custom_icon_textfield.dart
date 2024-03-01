import 'package:flutter/material.dart';

class CampoTextoIcone extends StatelessWidget {
  const CampoTextoIcone({
    required this.obscureText,
    required this.validator,
    required this.onChanged,
    required this.controller,
    required this.hintText,
    required this.preffixWidget,
    this.suffixWidget, super.key,});

  final TextEditingController controller;
  final bool obscureText;
  final String? validator;
  final Function(String?) onChanged;
  final String hintText;
  final Widget preffixWidget;
  final Widget? suffixWidget;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      keyboardType: TextInputType.text,
      validator: (value) => validator,
      onChanged: onChanged,
      controller: controller,
      obscureText: obscureText,
      decoration: InputDecoration(
        hintText: hintText,
        contentPadding: const EdgeInsets.all(10.0),
        hintStyle: const TextStyle(color: Colors.white30),
        filled: true,
        fillColor: const Color(0xFF121212),
        enabledBorder: OutlineInputBorder(
          borderSide: const BorderSide(color: Colors.grey),
          borderRadius: BorderRadius.circular(8),
        ),
        focusedBorder: OutlineInputBorder(
          borderSide: const BorderSide(color: Color(0xFFFDC600)),
          borderRadius: BorderRadius.circular(8),
        ),
        prefixIcon: preffixWidget,
        suffixIcon: suffixWidget,
      ),
      style: const TextStyle(color: Colors.white70),
    );
  }
}
