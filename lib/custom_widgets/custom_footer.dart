import 'package:flutter/material.dart';

class CustomFooter extends StatelessWidget {
  const CustomFooter({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {

    return Expanded(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          const SizedBox(height: 20),
          Image.asset('images/linkrapido_logo.png', height: 90, width: 90, fit: BoxFit.scaleDown,),
          const SizedBox(height: 20),
        ],
      ),
    );
  }
}