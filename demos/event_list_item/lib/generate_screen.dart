import 'dart:convert';

import 'package:event_list_item/detail_screen.dart';
import 'package:event_list_item/main.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:story_gen/story_gen.dart';

class GenerateScreen extends StatefulWidget {
  const GenerateScreen({super.key});

  @override
  State<GenerateScreen> createState() => _GenerateScreenState();
}

class _GenerateScreenState extends State<GenerateScreen> {
  late final HorrorStoryGenerator generator;
  final List<StoryBeatEvent> events = [];

  @override
  void initState() {
    super.initState();

    generator = HorrorStoryGenerator();

    generator.setScene(
      Scene(
        width: sceneSize,
        length: sceneSize,
        visibility: 3,
        characters: [
          Character(name: 'Joons', archetype: Archetype.angry),
          Character(name: 'Brighton', archetype: Archetype.loving),
          Character(name: 'Joey', archetype: Archetype.scared),
          Character(name: 'Tim1', archetype: Archetype.funny),
          Character(name: 'Tim2', archetype: Archetype.angry),
          Character(name: 'Joël', archetype: Archetype.funny),
        ],
      ),
    );

    generator.addStoryEventListener(_onStoryEvent);
  }

  @override
  void dispose() {
    super.dispose();
    generator.removeStoryEventListener(_onStoryEvent);
    generator.stop();
  }

  void _onStoryEvent(StoryBeatEvent event) {
    if (mounted) {
      setState(() {
        events.add(event);
      });
    }
  }

  Future<List<Character>> _getCharacters() async {
    var response = await get(
      Uri.parse('https://a806-185-10-158-5.ngrok.io/characters'),
      headers: {
        'X-API-KEY': preferences.getString('api-key')!,
      },
    );

    if (response.statusCode == 200) {
      var json = jsonDecode(response.body);
      List<dynamic> rawCharacters = json['characters'];
      return [
        for (var jsonCharacter in rawCharacters) ...[
          Character.fromJson(jsonCharacter),
        ]
      ];
    }
    return [];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Preparing simulation'),
      ),
      body: Column(
        children: [
          Expanded(
            flex: 2,
            child: Row(
              children: [
                Expanded(
                  flex: 2,
                  child: Card(
                    child: FutureBuilder<List<Character>>(
                      future: _getCharacters(),
                      builder: (context, snapshot) {
                        if (snapshot.hasData) {
                          return ListView(
                            children: [
                              for (var character in snapshot.data!) ...[
                                ListTile(
                                  title: Text(character.name),
                                ),
                              ]
                            ],
                          );
                        } else {
                          return const CircularProgressIndicator();
                        }
                      },
                    ),
                  ),
                ),
                Expanded(
                  flex: 3,
                  child: Container(
                    color: Colors.green,
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            flex: 3,
            child: Stack(
              alignment: Alignment.bottomCenter,
              children: [
                ListView(
                  children: [
                    for (var event in events.reversed)
                      EventCard(
                        event: event,
                      ),
                    const SizedBox(
                      height: 100,
                    )
                  ],
                ),
                Container(
                  height: 100,
                  alignment: Alignment.center,
                  decoration: const BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [
                        Colors.transparent,
                        Colors.white,
                      ],
                    ),
                  ),
                  child: ElevatedButton(
                    onPressed: () {
                      generator.generate(
                        speed: const Duration(
                          seconds: 1,
                        ),
                      );
                    },
                    child: const Text('Generate'),
                  ),
                )
              ],
            ),
          )
        ],
      ),
    );
  }
}

class EventCard extends StatelessWidget {
  const EventCard({
    super.key,
    required this.event,
  });

  final StoryBeatEvent event;

  Widget _createDetailScreen(BuildContext context) {
    return DetailScreen(
      event: event,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Row(
        children: [
          const Icon(Icons.electric_bolt),
          Expanded(
            child: Column(
              children: [
                Text(event.mainActor.name),
                const SizedBox(
                  height: 8,
                ),
                Text(event.message),
              ],
            ),
          ),
          IconButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: _createDetailScreen,
                ),
              );
            },
            icon: const Icon(Icons.chevron_right),
          ),
        ],
      ),
    );
  }
}
