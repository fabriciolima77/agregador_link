import 'package:flutter/material.dart';

class CampoTexto extends StatelessWidget {
  const CampoTexto({
    Key? key,
    required this.controller,
    required this.hintText,
    required this.keyBoardType,
  }): super(key: key);

  final TextEditingController controller;
  final String hintText;
  final TextInputType keyBoardType;

  @override
  Widget build(BuildContext context) {
    return TextField(
      keyboardType: keyBoardType,
      controller: controller,
      maxLines: 1,
      decoration: InputDecoration(
        hintText: hintText,
        contentPadding: const EdgeInsets.all(10.0),
        hintStyle: const TextStyle(color: Colors.white),
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
      ),
      style: const TextStyle(color: Colors.white),
    );
  }
}