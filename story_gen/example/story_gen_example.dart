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
        Character(name: 'John', archetype: Archetype.funny),
        Character(name: 'Tim', archetype: Archetype.angry),
        Character(name: 'Stein', archetype: Archetype.funny),
        Character(name: 'Ka Chung', archetype: Archetype.neutral),
      ],
    ),
  );

  generator.addStoryEventListener((event) => print(event.message));
  generator.generate(speed: Duration(seconds: 5));
}
