import 'dart:async';

import 'package:covid19/models/SimulationModel.dart';
import 'package:covid19/utils/SimulationPainter.dart';
import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';

/*
* Main simulation screen
* */
class SimulationScreen extends StatefulWidget {
  @override
  _SimulationScreenState createState() => _SimulationScreenState();
}

class _SimulationScreenState extends State<SimulationScreen> with SingleTickerProviderStateMixin {
  SimulationModel? simulation;
  late AnimationController _controller; /* controller for animating */
  late ValueNotifier<String> timerNotifier; /* for updating timer without update all states*/

  int initialInfected = 1;
  double infectionChance = 0.1;
  double mortality = 0.01;
  double strengthAgainstImmunity = 0.2;
  double speed = 1;
  int totalPeople = 100;
  int menuWidth = 200;

  List<FlSpot> infectedData = [];
  List<FlSpot> recoveredData = [];
  List<FlSpot> deadData = [];
  int timeElapsed = 0;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this, duration: const Duration(milliseconds: 16))..repeat();
    timerNotifier = ValueNotifier('0:00');
  }

  void startSimulation() {
    setState(() {
      simulation = SimulationModel(
        totalPeople: totalPeople,
        infectionChance: infectionChance,
        mortality: mortality,
        strengthAgainstImmunity: strengthAgainstImmunity,
        totalInfected: initialInfected,
        width: MediaQuery.of(context).size.width - menuWidth,
        height: MediaQuery.of(context).size.height,
        speed: speed
      );
      simulation!.start();

      // Очистка данных графика перед новой симуляцией
      infectedData.clear();
      recoveredData.clear();
      deadData.clear();
      timeElapsed = 0;
    });

    Timer.periodic(const Duration(seconds: 1), (timer) {
      if (!simulation!.isRunning) {
        timer.cancel();
      }

      // Добавляем данные для графика
      setState(() {
        infectedData.add(FlSpot(timeElapsed.toDouble(), simulation!.totalInfected.toDouble()));
        recoveredData.add(FlSpot(timeElapsed.toDouble(), simulation!.people.where((p) => p.isRecovered).length.toDouble()));
        deadData.add(FlSpot(timeElapsed.toDouble(), simulation!.people.where((p) => p.isDead).length.toDouble()));
        timeElapsed++;
      });

      timerNotifier.value = '${simulation!.stopwatch.elapsed.inSeconds} seconds';
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[300],
      body: Row(
        children: [
          simulation != null
              ? Expanded(
              child: AnimatedBuilder(
                animation: _controller,
                builder: (context, child) {
                  simulation!.update(MediaQuery.of(context).size.width - menuWidth, MediaQuery.of(context).size.height);
                  return CustomPaint(
                    size: Size(MediaQuery.of(context).size.width - menuWidth, MediaQuery.of(context).size.height),
                    painter: SimulationPainter(simulation!.people),
                  );
                },
              ),
            ) : const Expanded(child: SizedBox()),
          Container(
            width: 300,
            color: Colors.white,
            padding: const EdgeInsets.all(10),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                SizedBox(height: 300, child: buildChart()), // График
                TextField(
                  decoration: const InputDecoration(labelText: 'Total People'),
                  onChanged: (value) {
                    int? newValue = int.tryParse(value);
                    if (newValue == null) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Wrong total people input')),
                      );
                      return;
                    }
                    if (newValue > 7000) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Maximum number of people is 7000')),
                      );
                      return;
                    }
                    totalPeople = newValue;
                  },
                ),
                TextField(
                  decoration: const InputDecoration(labelText: 'Initial Infected'),
                  onChanged: (value) {
                    int val = int.parse(value);
                    if (val > totalPeople) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Maximum number of people is 7000')),
                      );
                      return;
                    }
                    initialInfected = val;
                  },
                ),
                TextField(
                  decoration: const InputDecoration(labelText: 'Infection Chance'),
                  onChanged: (value) {
                    double? newValue = double.tryParse(value);
                    if (newValue == null) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Wrong Infection Chance input')),
                      );
                      return;
                    }
                    infectionChance = newValue;
                  },
                ),
                TextField(
                  decoration: const InputDecoration(labelText: 'Mortality'),
                  onChanged: (value) {
                    double? newValue = double.tryParse(value);
                    if (newValue == null) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Wrong speed input')),
                      );
                      return;
                    }
                    if (newValue > 1 || newValue < 0) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Mortality from 0 to 1')),
                      );
                      return;
                    }
                    mortality = newValue;
                  },
                ),
                TextField(
                  decoration: const InputDecoration(labelText: 'Strength against immunity'),
                  onChanged: (value) {
                    double? newValue = double.tryParse(value);
                    if (newValue == null) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Wrong speed input')),
                      );
                      return;
                    }
                    if (newValue > 1 || newValue < 0) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Strength against immunity from 0 to 1')),
                      );
                      return;
                    }
                    strengthAgainstImmunity = newValue;
                  },
                ),
                TextField(
                  decoration: const InputDecoration(labelText: 'Speed'),
                  onChanged: (value) {
                    double? newValue = double.tryParse(value);
                    if (newValue == null) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Wrong speed input')),
                      );
                      return;
                    }
                    if (newValue > 7000) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Maximum number speed is 100')),
                      );
                      return;
                    }
                    speed = newValue;
                  },
                ),
                ElevatedButton(
                  onPressed: startSimulation,
                  child: const Text('Start'),
                ),
                ValueListenableBuilder(
                  valueListenable: timerNotifier,
                  builder: (context, value, child) {
                    return Text('Time: $value');
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget buildChart() {
    return LineChart(
      LineChartData(
        titlesData: FlTitlesData(
          // leftTitles: const AxisTitles(sideTitles: SideTitles(showTitles: true)),
          bottomTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
        ),
        borderData: FlBorderData(show: true),
        lineBarsData: [
          LineChartBarData(
            spots: infectedData,
            isCurved: true,
            barWidth: 2,
            color: Colors.red,
            dotData: const FlDotData(show: false),
          ),
          LineChartBarData(
            spots: recoveredData,
            isCurved: true,
            barWidth: 2,
            color: Colors.green,
            dotData: const FlDotData(show: false),
          ),
          LineChartBarData(
            spots: deadData,
            isCurved: true,
            barWidth: 2,
            color: Colors.black,
            dotData: const FlDotData(show: false),
          ),
        ],
      ),
    );
  }
}