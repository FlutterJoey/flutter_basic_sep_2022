import 'package:flutter/material.dart';
import 'package:story_gen/story_gen.dart';

class DetailScreen extends StatelessWidget {
  const DetailScreen({
    super.key,
    required this.event,
  });

  final StoryBeatEvent event;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Center(
        child: Text(
          event.message,
        ),
      ),
    );
  }
}
