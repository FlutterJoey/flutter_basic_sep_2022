// ignore_for_file: avoid_print

import 'dart:io';

import 'package:event_list_item/generate_screen.dart';
import 'package:event_list_item/login_screen_form.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

const int sceneSize = 12;

late SharedPreferences preferences;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  preferences = await SharedPreferences.getInstance();
  runApp(const HorrorApp());
}

class HorrorApp extends StatelessWidget {
  const HorrorApp({super.key});

  @override
  Widget build(BuildContext context) {
    var token = preferences.getString('api-key');

    return MaterialApp(
      theme: ThemeData.dark().copyWith(
        inputDecorationTheme: const InputDecorationTheme(
          border: OutlineInputBorder(),
          floatingLabelAlignment: FloatingLabelAlignment.center,
        ),
      ),
      home: token == null ? const LoginScreen() : const GenerateScreen(),
    );
  }
}
