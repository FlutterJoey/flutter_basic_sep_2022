import 'package:flutter/material.dart';

class AppTitle extends StatefulWidget {
  final String text;

  const AppTitle({
    required this.text,
    super.key,
  });

  @override
  State<AppTitle> createState() => AppTitleState();
}

class AppTitleState extends State<AppTitle> {
  bool isTapped = false;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: tapText,
      child: Text(
        widget.text,
        style: TextStyle(
          color: Colors.blueGrey.shade800,
          fontSize: 25,
          fontWeight: isTapped ? FontWeight.bold : FontWeight.normal,
        ),
      ),
    );
  }

  void tapText() {
      setState(() {
        isTapped = !isTapped;
      });
    }
}
