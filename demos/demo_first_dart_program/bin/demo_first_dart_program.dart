import 'dart:math';

const rock = 0;
const paper = 1;
const scissors = 2;

void main(List<String> arguments) {
  int choice = paper;
  Random random = Random();

  var npc = random.nextInt(3);

  if (choice == npc) {
    print('draw');
  } else if (choice == rock) {
    if (npc == scissors) {
      print('won');
    } else {
      print('lost');
    }
  }
}
