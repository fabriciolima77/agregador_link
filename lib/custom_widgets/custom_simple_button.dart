import 'package:flutter/material.dart';

class CriaBotaoSimples extends StatelessWidget {

  const CriaBotaoSimples({
    Key? key,
    required this.hintText,
    required this.onPressed,
    required this.left,
    required this.top,
    required this.right,
    required this.bottom,}) : super(key: key);

  final String hintText;
  final VoidCallback onPressed;
  final double left;
  final double top;
  final double right;
  final double bottom;

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color(0xFFFDC600),
          padding: EdgeInsets.fromLTRB(left, top, right, bottom),
          textStyle: const TextStyle(color: Colors.black, ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(32),
          ),
        ), child: Text(hintText, style: const TextStyle(color: Colors.black, fontWeight: FontWeight.bold),),
    );
  }
}