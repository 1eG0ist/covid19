import 'dart:math';

class Person {
  double x, y;
  double speed;
  bool isInfected = false;
  bool isRecovered = false;
  bool hasInteractedWithVirus = false;
  bool isDead = false;
  double immunity = 0.1; // От 0 (нет иммунитета) до 1 (полный иммунитет)
  int recoveryTime = 500; // Количество итераций до выздоровления
  int sickTime = 0; // Счётчик времени болезни
  String previousCellIndex; // Индекс предыдущей клетки в spatial grid
  final Random _random = Random();

  double mortality;
  double strengthAgainstImmunity;

  Person({
    required this.x,
    required this.y,
    required this.speed,
    required this.mortality,
    required this.strengthAgainstImmunity,
    required this.previousCellIndex
  });

  void move(Random random, double width, double height) {
    if (isDead) return; // Мёртвые не двигаются

    x += (random.nextDouble() - 0.5) * speed;
    y += (random.nextDouble() - 0.5) * speed;

    x = x.clamp(0, width);
    y = y.clamp(0, height);
  }

  void checkCollision(Person other, double infectionChance) {
    if (isDead || other.isDead || (!other.isInfected && !isInfected)) return;

    double distance = sqrt(pow(x - other.x, 2) + pow(y - other.y, 2));
    if (distance < 5) { // Порог столкновения
      hasInteractedWithVirus = true;
      other.hasInteractedWithVirus = true;

      if (isInfected && !other.isInfected && _random.nextDouble() < infectionChance * (1 - other.immunity)) {
        other.infect();
      } else if (other.isInfected && !isInfected && _random.nextDouble() < infectionChance * (1 - immunity)) {
        infect();
      }
    }
  }

  void infect() {
    if (_random.nextDouble() < mortality * (1 - immunity * strengthAgainstImmunity)) {
      isDead = true;
    } else {
      isInfected = true;
      sickTime = 0;
    }
  }

  void updateHealth() {
    if (isInfected) {
      sickTime++;
      if (sickTime >= recoveryTime) {
        recover();
      }
    }
  }

  void recover() {
    isInfected = false;
    isRecovered = true;
    immunity += (1 - immunity) / 3;
    immunity = immunity.clamp(0.0, 1.0);
  }
}
