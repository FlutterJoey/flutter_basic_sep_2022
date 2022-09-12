import 'package:story_gen/story_gen.dart';

void main() {
  var generator = HorrorStoryGenerator();
  generator.setScene(
    Scene(
      width: 12,
      length: 12,
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

  generator.addStoryEventListener((event) {
    if (event.type == StoryBeatEventType.kill) {
      print(event.mainActor.name);
    }
  });
  generator.generate(speed: Duration(seconds: 1));
}
