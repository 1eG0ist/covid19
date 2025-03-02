import 'dart:math';
import 'Person.dart';

class SimulationModel {
  List<Person> people;
  double infectionChance;
  double mortality;
  double strengthAgainstImmunity;
  int totalInfected;
  int totalPeople;
  bool isRunning;
  Stopwatch stopwatch;
  double speed;
  double gridSize = 10;
  Map<String, List<Person>> spatialGrid = {}; // Хранилище клеток

  SimulationModel({
    required this.totalPeople,
    required this.infectionChance,
    required this.mortality,
    required this.strengthAgainstImmunity,
    required this.totalInfected,
    required double width,
    required double height,
    required this.speed
  })  : people = List.generate(totalPeople, (index) {
    double xx = Random().nextDouble() * width;
    double yy = Random().nextDouble() * height;
    return Person(
        x: xx,
        y: yy,
        speed: speed,
        mortality: mortality,
        strengthAgainstImmunity: strengthAgainstImmunity,
        previousCellIndex: '$xx|$yy'
    );
  }),
        isRunning = false,
        stopwatch = Stopwatch() {
    for (int index = 0; index < totalInfected; index++) {
      people[index].isInfected = true;
    }
  }

  void start() {
    isRunning = true;
    stopwatch.start();
  }

  void update(double width, double height) {
    if (!isRunning) return;

    // Очистка spatial grid
    for (var list in spatialGrid.values) {
      list.clear();
    }

    // Движение людей и обновление клеток
    for (var person in people) {
      person.move(Random(), width, height);
      _updateSpatialGrid(person);
      person.updateHealth();
    }

    // Проверка коллизий внутри клеток
    for (var cell in spatialGrid.values) {
      for (int i = 0; i < cell.length; i++) {
        for (int j = i + 1; j < cell.length; j++) {
          cell[i].checkCollision(cell[j], infectionChance);
        }
      }
    }

    totalInfected = people.where((person) => person.isInfected).length;

    if (totalInfected == totalPeople) {
      isRunning = false;
      stopwatch.stop();
    }
  }

  void _updateSpatialGrid(Person person) {
    int cellX = (person.x / gridSize).floor();
    int cellY = (person.y / gridSize).floor();
    String cellKey = "$cellX|$cellY"; // Уникальный ключ в формате "x|y"

    // Если человек сменил клетку, удаляем его из предыдущей
    if (person.previousCellIndex != cellKey) {
      if (spatialGrid.containsKey(person.previousCellIndex)) {
        spatialGrid[person.previousCellIndex]!.remove(person);
      }
      person.previousCellIndex = cellKey;
    }

    // Добавляем в текущую клетку
    (spatialGrid[cellKey] ??= []).add(person);
  }
}
