import 'dart:io';
import 'dart:math';

import 'package:shelf/shelf.dart';
import 'package:shelf/shelf_io.dart';
import 'package:shelf_router/shelf_router.dart';

// Configure routes.
final _router = Router()..get('/character/<name>', _myCharacter);

Response _myCharacter(Request request) {
  String name = request.params['name'] ?? '';

  // character gets random location
  // character gets a random type
  var character = Character(
    name: name,
    location: Location.random(),
    type: CharacterType.random(),
  );

  return Response.ok(character.toString());
}

class Location {
  int x;
  int y;

  Location(
    this.x,
    this.y,
  );

  factory Location.random() {
    var random = Random();
    return Location(random.nextInt(10), random.nextInt(10));
  }

  @override
  String toString() {
    return 'Location($x,$y)';
  }
}

class Character {
  String name;
  Location location;
  CharacterType type;

  Character({
    required this.name,
    required this.location,
    required this.type,
  });

  @override
  String toString() {
    return 'Character(name: $name, location: $location, type: ${type.toString()})';
  }
}

enum CharacterType {
  angry('angry'),
  loving('loving'),
  funny('funny'),
  scared('scared');

  const CharacterType(this.name);

  final String name;

  @override
  String toString() {
    return 'CharacterType($name)';
  }

  static CharacterType random() {
    var values = CharacterType.values;
    return values[Random().nextInt(values.length)];
  }
}

void main(List<String> args) async {
  // Use any available host or container IP (usually `0.0.0.0`).
  final ip = InternetAddress.anyIPv4;

  // Configure a pipeline that logs requests.
  final handler = Pipeline().addMiddleware(logRequests()).addHandler(_router);

  // For running in containers, we respect the PORT environment variable.
  final port = int.parse(Platform.environment['PORT'] ?? '8123');
  final server = await serve(handler, ip, port);
  print('Server listening on port ${server.port}');
}
