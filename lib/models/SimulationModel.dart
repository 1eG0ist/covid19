import 'dart:math';
import 'Person.dart';

/*
* Main data class of simulation
* */
class SimulationModel {
  List<Person> people;
  double infectionChance;
  int totalInfected;
  int totalPeople;
  bool isRunning;
  Stopwatch stopwatch;
  double speed;

  SimulationModel({
    required this.totalPeople,
    required this.infectionChance,
    required this.totalInfected,
    required double width,
    required double height,
    required this.speed})
      : people = List.generate(totalPeople, (index) => Person(x: Random().nextDouble() * width, y: Random().nextDouble() * height, speed: speed)),
        isRunning = false,
        stopwatch = Stopwatch() {
    for(int index=0; index<totalInfected; index+=1) {
      people[index].isInfected = true;
    };
  }

  void start() {
    isRunning = true;
    stopwatch.start();
  }

  void update(double width, double height) {
    if (!isRunning) return;

    for (var person in people) {
      person.move(Random(), width, height);
    }

    for (int i = 0; i < people.length; i++) {
      for (int j = i + 1; j < people.length; j++) {
        people[i].checkCollision(people[j], infectionChance);
      }
    }

    totalInfected = people.where((person) => person.isInfected).length;

    if (totalInfected == totalPeople) {
      isRunning = false;
      stopwatch.stop();
    }
  }
}