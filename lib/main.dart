import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:projetos/pages/home_page.dart';

Future main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(
      options: const FirebaseOptions(
    apiKey: 'AIzaSyDzpaHh1Fg5vpYtQbBNSwmfuk1cKnYadaY',
    appId: '1:785023826668:web:975fbabdb841284aedc3c9',
    messagingSenderId: '785023826668',
    projectId: 'dlsublimarte-linkrapido',
    storageBucket: "gs://dlsublimarte-linkrapido.appspot.com",
  ));
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'LinkRapido | DL Sublimarte',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        fontFamily: 'Lexend',
        colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xFFFDC600)),
        primarySwatch: Colors.amber,
        scaffoldBackgroundColor: Colors.black,
      ),
      home: const HomePage(title: 'LinkRapido | DL Sublimarte'),
    );
  }
}