import 'dart:async';
import 'dart:math';

const zombie = Monster(
  name: 'Zombie',
  scareFactor: 1,
  speed: 1,
  deadlyNess: 0.3,
  attackName: 'eating the brain',
  sound: 'Gurgle',
);

const werewolf = Monster(
  name: 'Werewolf',
  scareFactor: 2,
  speed: 3,
  deadlyNess: 0.5,
  attackName: 'clawing out their heart',
  sound: 'Awooo',
);

const ghost = Monster(
  name: 'Ghost',
  scareFactor: 4,
  speed: 2,
  deadlyNess: 0.1,
  attackName: 'scaring them to death',
  sound: 'Boo!',
);

const chainsawMurderer = Monster(
    name: 'Chainsaw murderer',
    scareFactor: 5,
    speed: 1,
    deadlyNess: 1,
    attackName: 'tearing them in half',
    sound: '*Loud chainsaw noises*');

const jorian = Monster(
    name: 'Jorian the Frozen',
    scareFactor: 1,
    speed: 2,
    deadlyNess: 0.8,
    attackName: 'freezing them',
    sound: 'ITS COLD... SOOOO COLD');

const bart = Monster(
  scareFactor: 2,
  speed: 3,
  deadlyNess: 0.2,
  name: 'Bart the Nagger',
  attackName: 'threatening to deny their PR',
  sound: '-Anyone with an unsafe password must die-',
);

const steven = Monster(
  scareFactor: 1,
  speed: 4,
  deadlyNess: 1.0,
  name: 'Splashing Steven',
  attackName: 'running them over with a wakeboard',
  sound: 'Splish Splash',
);

typedef StoryBeatListener = FutureOr<void> Function(StoryBeatEvent);
typedef MapUpdateEventListener = FutureOr<void> Function(MapUpdateEvent);

class MapUpdateEvent {
  final List<MonsterCharacter> monsters;
  final List<Character> characters;
  final Scene scene;

  MapUpdateEvent({
    required this.monsters,
    required this.characters,
    required this.scene,
  });
}

class HorrorStoryGenerator {
  late Scene? scene;
  Timer? timer;
  final List<StoryBeatListener> _storyListeners = [];
  final List<MapUpdateEventListener> _mapListeners = [];

  late List<MonsterCharacter> _monsters;
  late List<Character> _actors;

  final List<StoryBeatEvent> _beats = [];

  HorrorStoryGenerator();

  void addMapEventListener(MapUpdateEventListener listener) {
    _mapListeners.add(listener);
  }

  void removeMapEventListener(MapUpdateEventListener listener) {
    _mapListeners.remove(listener);
  }

  void addStoryEventListener(StoryBeatListener listener) {
    _storyListeners.add(listener);
  }

  void removeStoryEventListener(StoryBeatListener listener) {
    _storyListeners.remove(listener);
  }

  void setScene(Scene scene) {
    this.scene = scene;
  }

  void stop() {
    timer?.cancel();
    scene = null;
    _monsters.clear();
    _actors.clear();
  }

  void generate({
    required Duration speed,
  }) {
    assert(scene != null, 'A scene needs to be set before generate is ran');
    _monsters = scene!.monsters.map((e) => MonsterCharacter(e)).toList();
    _actors = scene!.characters
        .map((e) => Character(name: e.name, archetype: e.archetype))
        .toList();
    _placeActors(scene!);
    _sendMapUpdate(
      MapUpdateEvent(
        monsters: List.from(_monsters),
        characters: List.from(_actors),
        scene: scene!,
      ),
    );
    timer = Timer.periodic(speed, _tick);
  }

  String getMap() {
    var result = List<List<String>>.generate(scene!.length,
        (index) => List<String>.generate(scene!.width, (index) => ' '));

    void appendPoint(Point<int> point, String letter) {
      result[point.y][point.x] = letter;
    }

    for (var m in _monsters) {
      appendPoint(m._position, 'm');
    }

    for (var c in _actors) {
      appendPoint(c._position, 'c');
    }

    return result.map((e) => e.join(',')).join('\n');
  }

  void _sendEvent(StoryBeatEvent event) {
    _beats.add(event);
    for (var listener in _storyListeners) {
      listener(event);
    }
  }

  void _sendMapUpdate(MapUpdateEvent event) {
    for (var listener in _mapListeners) {
      listener(event);
    }
  }

  int _determinePoint(int pos, int max, bool isRandomSide) {
    bool opposite = Random().nextBool();
    if (isRandomSide) {
      return pos;
    } else if (opposite) {
      return max;
    } else {
      return 0;
    }
  }

  void _placeActors(Scene scene) {
    int x = scene.width - 1;
    int y = scene.length - 1;
    var random = Random();

    for (var monster in _monsters) {
      int posX = random.nextInt(x);
      int posY = random.nextInt(y);
      bool axis = random.nextBool();
      monster._position = Point(
        _determinePoint(posX, x, axis),
        _determinePoint(posY, y, !axis),
      );
    }

    for (var actor in _actors) {
      int minX = scene.visibility;
      int xRange = x - scene.visibility * 2;
      int minY = scene.visibility;
      int yRange = y - scene.visibility * 2;

      int posX = random.nextInt(xRange) + minX;
      int posY = random.nextInt(yRange) + minY;

      actor._position = Point(posX, posY);
    }
  }

  List<MonsterCharacter> _getVisibleMonsters(BaseCharacter character) {
    return _monsters
        .where(
          (element) =>
              element.isVisibleInScene(scene!, character) &&
              element != character,
        )
        .toList()
      ..sort((a, b) => a
          .getSquaredDistance(character)
          .compareTo(b.getSquaredDistance(character)));
  }

  List<Character> _getVisibleCharacters(BaseCharacter character) {
    return _actors
        .where(
          (element) =>
              element.isVisibleInScene(scene!, character) &&
              element != character,
        )
        .toList();
  }

  void _tick(Timer timer) {
    _moveActors();
    _moveMonsters();
    _handleInteractions(timer.tick);
    _sendMapUpdate(
      MapUpdateEvent(
        monsters: List.from(_monsters),
        characters: List.from(_actors),
        scene: scene!,
      ),
    );
    if (!_actors.any((element) => !element.isDead)) {
      _sendEvent(
        StoryBeatEvent(
          scene: scene!,
          timeStamp: Duration(minutes: timer.tick),
          mainActor: Character(
            name: 'Narrator',
            archetype: Archetype.funny,
          ),
          visibleMonsters: [],
          type: StoryBeatEventType.end,
          message:
              'That was all folks, seems like nobody survived in the end..',
        ),
      );
      stop();
    }
  }

  void _moveMonsters() {
    for (var monster in _monsters) {
      var players = _getVisibleCharacters(monster).where(
        (element) => !element.isDead,
      );
      Point<int>? target;
      if (players.isNotEmpty) {
        target = players.first._position;
      }
      monster._position = _nextPoint(
        monster._position,
        monster.monster.speed,
        scene!,
        target: target,
      );
    }
  }

  void _moveActors() {
    for (var actor in _actors) {
      if (actor.isDead) {
        continue;
      }
      var monsters = _getVisibleMonsters(actor);
      if (monsters.isNotEmpty) {
        // move character based on traits
        var target = actor._reactToMonsterAndMove(monsters.first);
        actor._position = _nextPoint(
          actor._position,
          actor.archetype.speed,
          scene!,
          target: target,
        );
        continue;
      }

      var characters = _getVisibleCharacters(actor);

      if (characters.isNotEmpty) {
        var target = actor._reactToCharacterAndMove(characters.first);
        actor._position = _nextPoint(
          actor._position,
          actor.archetype.speed,
          scene!,
          target: target,
        );
        continue;
      }

      actor._position = _nextPoint(
        actor._position,
        actor.archetype.speed,
        scene!,
      );
    }
  }

  void _handleInteractions(int tick) {
    var random = Random();
    for (var actor in _actors) {
      var visibleMonsters = _getVisibleMonsters(actor);

      void event({
        required Character mainActor,
        required StoryBeatEventType type,
        required String message,
        final Character? secondaryActor,
        final MonsterCharacter? monster,
      }) {
        _sendEvent(
          StoryBeatEvent(
            scene: scene!,
            message: message,
            timeStamp: Duration(minutes: tick),
            mainActor: mainActor,
            secondaryActor: secondaryActor,
            monster: monster,
            type: type,
            visibleMonsters: visibleMonsters.map((e) => e.monster).toList(),
          ),
        );
      }

      // possible interactions
      // scream and faint
      if (actor.isFainted && !actor.isDead) {
        event(
          mainActor: actor,
          type: StoryBeatEventType.faint,
          message: '${actor.name}: Screams loudly! <<FAINTS>>',
        );
      }
      // get killed
      var interactableMonsters = visibleMonsters
          .where((element) => element._isCloseTo(actor))
          .toList();

      for (var monster in interactableMonsters) {
        if (!actor.isDead) {
          var deathChance = monster.monster.deadlyNess;
          deathChance -= actor.archetype.adrenalineBoost;
          if (actor.isFainted) {
            deathChance += 0.25;
          }
          deathChance = max(deathChance, 0.1);
          event(
            mainActor: actor,
            monster: monster,
            type: StoryBeatEventType.attack,
            message: '${monster.name} attempts ${monster.monster.attackName}'
                ' at ${actor.name}',
          );
          if (random.nextDouble() <= deathChance) {
            actor._isDead = true;
            event(
              mainActor: actor,
              monster: monster,
              type: StoryBeatEventType.kill,
              message: '${actor.name} is killed by ${monster.name} by '
                  '${monster.monster.attackName}',
            );
            continue;
          } else {
            event(
              mainActor: actor,
              monster: monster,
              type: StoryBeatEventType.flee,
              message: '${actor.name} barely escapes the sudden attack of '
                  '${monster.name}',
            );
          }
        }
      }
      if (actor.isDead) {
        continue;
      }
      // fake jumpscare
      var interactableActors = _actors.where(
        (element) => element._isCloseTo(actor) && element != actor,
      );

      if (interactableActors.isNotEmpty) {
        if (actor.archetype == Archetype.scared && random.nextBool()) {
          event(
            mainActor: actor,
            secondaryActor: interactableActors.first,
            type: StoryBeatEventType.jumpScare,
            message: '${actor.name} heard a sound, looked around and saw '
                '${interactableActors.first.name} standing there, '
                'giving ${actor.name} a small heartattack',
          );
        }

        // "we should split up"
        if (actor.archetype == Archetype.angry ||
            interactableActors
                .any((element) => element.archetype == Archetype.angry)) {
          var other = interactableActors.firstWhere(
            (element) => element.archetype == Archetype.angry,
            orElse: () => interactableActors.first,
          );
          event(
              type: StoryBeatEventType.splitUp,
              mainActor: actor,
              secondaryActor: other,
              message: '${actor.name} decides that its best to split up, '
                  'mentioning it to ${other.name}');
          actor._position = _randomNextPoint(actor._position, scene!);
          other._position = _randomNextPoint(other._position, scene!);
        } else if (actor.archetype == Archetype.loving) {
          event(
            mainActor: actor,
            secondaryActor: interactableActors.first,
            type: StoryBeatEventType.romance,
            message: '${actor.name} looks into the eyes of '
                '${interactableActors.first.name}, a noticable spark happens '
                'between the two characters',
          );
        }
      } else {
        var visibleMonsters = _getVisibleMonsters(actor);
        if (visibleMonsters.isEmpty) {
          var randActor = _actors[random.nextInt(_actors.length)];
          // A generic roaming message
          event(
            mainActor: actor,
            type: StoryBeatEventType.say,
            message: [
              '${actor.name}: I don\'t have a good feeling about this...',
              '${actor.name}: The vibe is creepy, but I kinda dig it',
              '${actor.name}: F*CK I left the oven on at home!',
              '${actor.name} tripped and fell because they saw a spider',
              '${actor.name}: I wonder where ${randActor.name} is hanging out...',
              '${actor.name}: I hate ${randActor.name}, I hope he trips',
              '${actor.name}: Wonder where the exit to this forest is',
            ][random.nextInt(3)],
          );
        } else {
          // Monster making a sound
          var monster = visibleMonsters.first;
          var sound = monster.monster.sound;

          event(
            mainActor: actor,
            monster: monster,
            type: StoryBeatEventType.thought,
            message: '${actor.name} heard a sound: "$sound" '
                'coming from ${monster.name}',
          );
        }
      }
      // Death by random object
      if (actor.archetype == Archetype.funny && random.nextInt(4) == 1) {
        actor._isDead = true;
        event(
          mainActor: actor,
          type: StoryBeatEventType.kill,
          message: '${actor.name} died by falling off a cliff after walking '
              'into a spiderweb, hitting their head on a branch and '
              'tripping over a rotting decapitated head',
        );
      }
    }
  }

  Point<int> _nextPoint(
    Point<int> start,
    int steps,
    Scene scene, {
    Point<int>? target,
  }) {
    var current = Point(start.x, start.y);
    if (target == null) {
      return _randomNextPoint(current, scene);
    }

    var difference = target - start;
    for (int i = 0; i < steps; i++) {
      if (target == start) {
        return current;
      }
      int xMod = 0;
      int yMod = 0;
      if (difference.x.abs() > difference.y.abs()) {
        xMod = difference.x.isNegative ? -1 : 1;
      } else {
        yMod = difference.y.isNegative ? -1 : 1;
      }
      Point<int> mod = Point(xMod, yMod);
      if (_isInScene(current + mod, scene)) {
        current += mod;
      }
      difference -= mod;
    }
    return current;
  }

  Point<int> _randomNextPoint(Point<int> current, Scene scene,
      [int attempt = 0]) {
    var random = Random();
    var x = random.nextInt(3) - 1;
    var y = random.nextInt(3) - 1;
    var next = current + Point(x, y);
    if (current == next && attempt < 3) {
      return _randomNextPoint(current, scene, attempt + 1);
    }
    if (!_isInScene(next, scene) && attempt < 3) {
      return _randomNextPoint(current, scene, attempt + 1);
    }
    if (attempt > 2) {
      return current;
    }
    return next;
  }

  bool _isInScene(Point point, Scene scene) {
    return (point.x >= 0 &&
        point.y >= 0 &&
        point.y < scene.length &&
        point.x < scene.width);
  }
}

class StoryBeatEvent {
  final Scene scene;
  final Character mainActor;
  final Character? secondaryActor;
  final MonsterCharacter? monster;
  final List<Monster> visibleMonsters;
  final Duration timeStamp;
  final StoryBeatEventType type;
  final String message;

  StoryBeatEvent({
    required this.scene,
    required this.timeStamp,
    required this.mainActor,
    required this.visibleMonsters,
    required this.type,
    required this.message,
    this.secondaryActor,
    this.monster,
  });
}

enum StoryBeatEventType {
  faint,
  attack,
  kill,
  romance,
  say,
  thought,
  flee,
  splitUp,
  jumpScare,
  end,
}

class Scene {
  final int width;
  final int length;
  final int visibility;
  final List<Character> characters;
  final List<Monster> monsters;

  Scene({
    required this.width,
    required this.length,
    required this.visibility,
    required this.characters,
    this.monsters = const [
      zombie,
      werewolf,
      jorian,
      chainsawMurderer,
      ghost,
      bart,
      steven,
    ],
  });
}

class Monster {
  final String name;
  final String attackName;
  final String sound;
  final double deadlyNess;
  final int scareFactor;
  final int speed;

  const Monster({
    required this.name,
    required this.attackName,
    required this.scareFactor,
    required this.speed,
    required this.deadlyNess,
    required this.sound,
  });
}

class MonsterCharacter extends BaseCharacter {
  final Monster monster;

  MonsterCharacter(this.monster);

  @override
  String get name => monster.name;
}

abstract class BaseCharacter {
  Point<int> _position = Point(0, 0);
  bool _isDead = false;
  bool _fainted = false;

  Point<int> get position => _position;

  int getSquaredDistance(BaseCharacter other) {
    return _position.squaredDistanceTo(other._position).toInt();
  }

  bool _isCloseTo(BaseCharacter actor) {
    return getSquaredDistance(actor) <= 1;
  }

  bool isVisibleInScene(Scene scene, BaseCharacter other) {
    return getSquaredDistance(other) < pow(scene.visibility, 2) && !_isDead;
  }

  String get name;
}

class Character extends BaseCharacter {
  @override
  String name;
  Archetype archetype;

  bool get isDead => _isDead;
  bool get isFainted => _fainted;

  Character({
    required this.name,
    required this.archetype,
  });

  factory Character.fromJson(Map<String, dynamic> json) {
    return Character(
      name: json['name'],
      archetype: _archetypeFromString(json['archetype']),
    );
  }

  static Archetype _archetypeFromString(String value) {
    return Archetype.values.firstWhere((element) => element.name == value);
  }

  Point<int>? _reactToCharacterAndMove(Character character) {
    var difference = _position - character._position;
    if (character.archetype == Archetype.angry) {
      return _position - difference;
    }

    if (archetype == Archetype.loving || archetype == Archetype.angry) {
      return character._position;
    }

    return null;
  }

  Point<int> _reactToMonsterAndMove(MonsterCharacter monster) {
    if (_fainted) {
      _fainted = false;
      return _position;
    }
    int scareFactor = monster.monster.scareFactor;
    var difference = _position - monster._position;
    int scareBonus = 3 - min(difference.x.abs(), difference.y.abs());
    if (scareBonus < 0) {
      scareBonus = 0;
    }
    scareFactor += scareBonus;

    if (scareFactor >= archetype.faintThreshold) {
      _fainted = true;
      return _position;
    }

    if (scareFactor >= archetype.scaredThreshold) {
      return _position - (difference * scareBonus);
    } else {
      return monster._position;
    }
  }
}

enum Archetype {
  angry(
    adrenalineBoost: 0.2,
    faintThreshold: 5,
    scaredThreshold: 3,
    speed: 2,
  ), // will attack other characters
  loving(
    adrenalineBoost: 0,
    faintThreshold: 5,
    scaredThreshold: 4,
    speed: 1,
  ), // will stick to other characters
  funny(
    adrenalineBoost: 0.1,
    faintThreshold: 3,
    scaredThreshold: 1,
    speed: 2,
  ), // gullible and will go to monsters
  scared(
    adrenalineBoost: 0.3,
    faintThreshold: 2,
    scaredThreshold: 0,
    speed: 3,
  ), // will run at the sight of any monster, but also prefers other char

  neutral(
    adrenalineBoost: 0.0,
    faintThreshold: 7,
    scaredThreshold: 5,
    speed: 1,
  );

  const Archetype({
    required this.adrenalineBoost,
    required this.faintThreshold,
    required this.scaredThreshold,
    required this.speed,
  });

  final int faintThreshold;
  final double adrenalineBoost;
  final int speed;
  final int scaredThreshold;
}
