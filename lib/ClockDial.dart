import 'package:flutter/cupertino.dart';
import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:vector_math/vector_math_64.dart' show radians;

class Dial extends StatelessWidget{
  @override
  Widget build(BuildContext context) {
    return Center(
        child: SizedBox.expand(
            child:CustomPaint(
                painter: _DialPainter()
            )
        )
    );
  }
}


class _DialPainter extends CustomPainter{
  final perTickRad = radians(360/60);

  @override
  void paint(Canvas canvas, Size size) {
    final center = (Offset.zero & size).center;
    final radius = size.shortestSide / 2;
    final shortDialLength = 5;
    final longDialLength = 10;
    final painter1 = Paint()
      ..color = Colors.grey
      ..strokeWidth = 1.5
      ..strokeCap = StrokeCap.round;
    final painter2 = Paint()
      ..color = Colors.black
      ..strokeWidth = 4.5
      ..strokeCap = StrokeCap.round;
    final painter3 = Paint()
      ..color = Colors.black12;

    canvas.drawCircle(center, radius * 1.03, painter3);
    for(int i=0;i<60;i++){
      double angle = i * perTickRad;
      if(i % 5 != 0){
        final p1 = center + Offset(math.cos(angle), math.sin(angle)) * (radius - shortDialLength);
        final p2 = center + Offset(math.cos(angle), math.sin(angle)) * radius;
        canvas.drawLine(p1,p2,painter1);
      }else{
        final p1 = center + Offset(math.cos(angle), math.sin(angle)) * (radius - longDialLength);
        final p2 = center + Offset(math.cos(angle), math.sin(angle)) * radius;
        canvas.drawLine(p1,p2,painter2);
      }
    }
  }


  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return false;
  }

}