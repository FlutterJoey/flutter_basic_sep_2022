import 'package:event_list_item/detail_screen.dart';
import 'package:flutter/material.dart';

class GenerateScreen extends StatelessWidget {
  const GenerateScreen({super.key});

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
                    child: ListView(
                      children: const [],
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
                    for (int i = 0; i < 30; i++) const EventCard(),
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
                    onPressed: () {},
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
  const EventCard({super.key});

  Widget _createDetailScreen(BuildContext context) {
    return const DetailScreen();
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Row(
        children: [
          const Icon(Icons.electric_bolt),
          Expanded(
            child: Column(
              children: const [
                Text('Title'),
                SizedBox(
                  height: 8,
                ),
                Text('Message'),
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
