import 'package:flutter/material.dart';
import 'tts_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'AI Text to Speech',
      theme: ThemeData(primarySwatch: Colors.deepPurple),
      home: const TtsScreen(),
    );
  }
}
