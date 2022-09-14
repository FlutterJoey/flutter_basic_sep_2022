// ignore_for_file: avoid_print

import 'package:event_list_item/login_screen.dart';
import 'package:flutter/material.dart';

const int sceneSize = 12;

void main() {
  runApp(const HorrorApp());
}

class HorrorApp extends StatelessWidget {
  const HorrorApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData.dark(),
      home: const LoginScreen(),
    );
  }
}
