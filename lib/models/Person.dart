import 'dart:math';

class Person {
  double x, y;
  bool isInfected;
  double speed;

  Person({required this.x, required this.y, this.isInfected = false, this.speed = 1.0});

  void move(Random random, double width, double height) {
    x += (random.nextDouble() - 0.5) * speed;
    y += (random.nextDouble() - 0.5) * speed;

    /*
    * doesn't allow the dots to go off the screen
    * */
    x = x.clamp(0.0, width);
    y = y.clamp(0.0, height);
  }

  void checkCollision(Person other, double infectionChance) {
    if (isInfected && !other.isInfected) {
      double distance = sqrt(pow(x - other.x, 2) + pow(y - other.y, 2));
      if (distance < 10.0 && Random().nextDouble() < infectionChance) {
        other.isInfected = true;
      }
    }
  }
}