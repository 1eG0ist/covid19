import 'package:covid19/models/Person.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

/*
* Class for painting peoples
* */
class SimulationPainter extends CustomPainter {
  final List<Person> people;

  SimulationPainter(this.people);

  @override
  void paint(Canvas canvas, Size size) {
    for (var person in people) {
      final paint = Paint()
        ..color = person.isDead
            ? Colors.black
            : person.isInfected
              ? Colors.red
              : person.isRecovered
                ? Colors.green
                : Colors.blue
        ..style = PaintingStyle.fill;
      canvas.drawCircle(Offset(person.x, person.y), 5, paint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}