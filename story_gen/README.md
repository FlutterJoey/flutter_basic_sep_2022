<!-- 
This README describes the package. If you publish this package to pub.dev,
this README's contents appear on the landing page for your package.

For information about how to write a good package README, see the guide for
[writing package pages](https://dart.dev/guides/libraries/writing-package-pages). 

For general information about developing packages, see the Dart guide for
[creating packages](https://dart.dev/guides/libraries/create-library-packages)
and the Flutter guide for
[developing packages and plugins](https://flutter.dev/developing-packages). 
-->

A small package for creating awful scripts for "horror" movies / plays.

The goal of this package is to provide a stream of data which the course attendees
can listen to in the app being used for the course.

DISCLAIMER! This code is horrible but it works, touch / look at your own risk.

## Features

- Generate small scripts for an awful horror film
- Provide your own cast and monsters
- Get an overview of where everyone is on the map

## Getting started

Simply install the package by adding the following to the pubspec.yaml:

```yaml
dependencies:
  story_gen:
    git: https://github.com/FlutterJoey/flutter_basic_sep_2022.git
      path: story_gen/
```

## Usage

```dart
  var generator = HorrorStoryGenerator();
  generator.setScene(
    Scene(
      width: 10,
      length: 10,
      visibility: 3,
      characters: [
        Character(name: 'Joons', archetype: Archetype.angry),
        Character(name: 'Brighton', archetype: Archetype.loving),
        Character(name: 'Joey', archetype: Archetype.scared),
        Character(name: 'John', archetype: Archetype.funny),
      ],
    ),
  );
  generator.addStoryEventListener((event) => print(event.message));
  generator.generate(speed: Duration(seconds: 5));
```
