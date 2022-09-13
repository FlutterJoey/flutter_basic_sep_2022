const rock = 0;
const paper = 1;
const scissors = 2;

enum RPSType {
  rock(0, 'rock'),
  paper(1, 'paper'),
  scissors(2, 'scissors');

  const RPSType(
    this.id,
    this.type,
  );

  final String type;
  final int id;

  static RPSType getByString(String type) {
    return RPSType.values.firstWhere((element) => element.type == type,
        orElse: () => RPSType.rock);
  }
}

class Point {
  final int x;
  final int y;

  const Point(this.x, this.y);

  static String test() {
    return 'test';
  }
}

class ThreeDimensionalPoint extends Point {
  final int z;

  ThreeDimensionalPoint(super.x, super.y, this.z);
}

void main(List<String> args) {
  Point? p = const Point(1, 2);

  int i = 1;

  i.ceilToDouble();

  print(p.y);
}

// void main(List<String> arguments) {
//   int choice = paper;
//   Random random = Random();

//   var npc = random.nextInt(3);

//   if (choice == npc) {
//     print('draw');
//   } else if (choice == rock) {
//     if (npc == scissors) {
//       print('won');
//     } else {
//       print('lost');
//     }
//   } else if (choice == paper) {
//     if (npc == rock) {
//       print('won');
//     } else {
//       print('lost');
//     }
//   } else if (choice == scissors) {
//     if (npc == paper) {
//       print('won');
//     } else {
//       print('lost');
//     }
//   }
// }
