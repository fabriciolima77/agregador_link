import 'package:flutter/material.dart';

class CriaBotao extends StatelessWidget {

  const CriaBotao({
    Key? key,
    required this.hintText,
    required this.onPressed,
    required this.left,
    required this.top,
    required this.right,
    required this.bottom,
    required this.src,}) : super(key: key);

  final String hintText;
  final VoidCallback onPressed;
  final double left;
  final double top;
  final double right;
  final double bottom;
  final String src;

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
    backgroundColor: const Color(0xFFFDC600),
    elevation: 8,
    padding: EdgeInsets.fromLTRB(left, top, right, bottom),
    textStyle: const TextStyle(color: Colors.black),
    shape: RoundedRectangleBorder(
    borderRadius: BorderRadius.circular(32),
    ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          CircleAvatar(
            backgroundImage: NetworkImage(src),
            radius: 20,
            backgroundColor: Colors.transparent,
          ),
          Text(hintText,
              style: const TextStyle(
                fontSize: 20,
                color: Colors.black,)
          ),
          const SizedBox(width: 20)
        ],
      )
    );
  }
}