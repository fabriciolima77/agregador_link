import 'package:flutter/material.dart';

class CustomProfile extends StatelessWidget {
  const CustomProfile({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        children: [
          const SizedBox(height: 50),
          Container(
            height: 100,
            decoration: BoxDecoration(
              color: Colors.transparent,
              border: Border.all(color: const Color(0xFFFDC600), width: 2),
              shape: BoxShape.circle,
            ),
            child: const CircleAvatar(
              radius: 50,
              backgroundImage: NetworkImage('https://firebasestorage.googleapis.com/v0/b/dlsublimarte-linkrapido.appspot.com/o/images%2Fdl.png?alt=media'),
            ),
          ),
          const SizedBox(height: 10),
          const Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text('DL Sublimarte',
                style: TextStyle(fontSize: 18,fontWeight: FontWeight.bold, color: Color(0xFFFDC600),
                ),
              ),
              SizedBox(width: 5),
              Icon(Icons.verified_sharp, color: Colors.blue,)
            ],
          ),
        ],
      ),
    );
  }
}
