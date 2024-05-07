import 'package:flutter/material.dart';
import 'package:gemini_ai_chat/home/home_page.dart';
import 'package:gemini_ai_chat/initializations/start_init.dart';

void main() {
  Start.init();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Gemini Ai Chat',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.black),
        useMaterial3: true,
      ),
      home: HomePage(),
    );
  }
}
