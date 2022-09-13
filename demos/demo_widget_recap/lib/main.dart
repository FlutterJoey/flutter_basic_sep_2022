import 'dart:math';

import 'package:flutter/material.dart';

void main() {
  runApp(
    const MyApp(),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData.dark(),
      home: const MyScreen(),
    );
  }
}

class MyScreen extends StatelessWidget {
  const MyScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('MyScreen'),
      ),
      body: Column(
        children: const [
          Expanded(child: ColorChangingBox()),
          Expanded(child: ColorChangingBox()),
          Expanded(child: ColorChangingBox()),
          Expanded(child: ColorChangingBox()),
          Expanded(child: ColorChangingBox()),
        ],
      ),
    );
  }
}

class ColoredBox extends StatelessWidget {
  final Color color;
  const ColoredBox({
    super.key,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      color: color,
    );
  }
}

class ColorChangingBox extends StatefulWidget {
  const ColorChangingBox({super.key});

  @override
  State<ColorChangingBox> createState() => _ColorChangingBoxState();
}

class _ColorChangingBoxState extends State<ColorChangingBox> {
  Color color = Colors.green;

  void _changeOnTap() {
    var random = Random();
    setState(() {
      color = Colors.primaries[random.nextInt(Colors.primaries.length)];
    });
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: _changeOnTap,
      child: ColoredBox(
        color: color,
      ),
    );
  }
}
