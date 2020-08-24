import 'package:flutter/cupertino.dart';
import 'dart:math' as math;

import 'package:flutter/material.dart';

class Hand extends StatelessWidget{
  const Hand({
    @required this.color,
    @required this.size,
    @required this.thickness,
    @required this.angleRad,
  });

  final Color color;
  final double size;
  final double thickness;
  final double angleRad;

  @override
  Widget build(BuildContext context) {
    return Center(
        child: SizedBox.expand(
            child:CustomPaint(
                painter: _HandPainter(handSize: size, thickness: thickness, angleRad: angleRad, color: color)
            )
        )
    );
  }
}

class _HandPainter extends CustomPainter{
  _HandPainter({
    @required this.handSize,
    @required this.thickness,
    @required this.angleRad,
    @required this.color,
  });

  final Color color;
  final double handSize;
  final double thickness;
  final double angleRad;

  @override
  void paint(Canvas canvas, Size size) {
    final center = (Offset.zero & size).center;
    final angle = angleRad - math.pi / 2.0;
    final length = size.shortestSide * 0.5 * handSize;
    final position = center + Offset(math.cos(angle), math.sin(angle)) * length;
    final linePaint = Paint()
      ..color = color
      ..strokeWidth = thickness
      ..strokeCap = StrokeCap.round;

    canvas.drawLine(center,position,linePaint);
  }

  @override
  bool shouldRepaint(_HandPainter oldDelegate) {
    return oldDelegate.handSize != handSize ||
        oldDelegate.thickness != thickness ||
        oldDelegate.angleRad != angleRad ||
        oldDelegate.color != color;
  }

}



