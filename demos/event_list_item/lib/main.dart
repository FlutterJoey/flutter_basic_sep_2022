import 'package:flutter/material.dart';

import 'generate_screen.dart';

void main() {
  runApp(const HorrorApp());
}

class HorrorApp extends StatelessWidget {
  const HorrorApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData.dark(),
      home: const GenerateScreen(),
    );
  }
}