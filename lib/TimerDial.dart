import 'package:flutter/cupertino.dart';
import 'dart:math' as math;
import 'dart:async';

import 'package:flutter/material.dart';
import 'package:vector_math/vector_math_64.dart' show radians;

class Booster extends StatefulWidget{
  final rangSum;
  Booster(this.rangSum) : assert(rangSum != null);

  @override
  _BoosterState createState() => _BoosterState(rangSum);
}

class _BoosterState extends State<Booster>{
  final rangSum;
  int _countSum = 0;
  var _curTime = DateTime.now();
  Timer _timer;

  _BoosterState(this.rangSum) : assert(rangSum != null);

  @override
  void initState(){
    super.initState();
    _updateTime();
  }

  void _updateTime(){
    setState(() {
      _curTime = DateTime.now();
      _countSum += 1;
      _timer = Timer(
        Duration(seconds: 1) - Duration(milliseconds: _curTime.millisecond),
        _updateTime,
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Center(
        child: SizedBox.expand(
            child:CustomPaint(
                painter: _BoosterPainter(_countSum/rangSum)
            )
        )
    );
  }

  @override
  void dispose() {
    super.dispose();
    if (_timer != null) {
      _timer.cancel();
    }
  }
}

class _BoosterPainter extends CustomPainter {
  final arcRad;
  _BoosterPainter(this.arcRad);

  @override
  void paint(Canvas canvas, Size size) {
    final center = (Offset.zero & size).center;
    final radius = size.shortestSide / 2;
    final painter1 = Paint()
      ..color = Colors.black12;
    final painter2 = Paint()
      ..color = Colors.black;
    final painter3 = Paint()
      ..color = Colors.amber;

    final NeedArcRad = radians((arcRad * 360) % 360);
    final Arc90 = radians(360/4);
    canvas.drawCircle(center, radius , painter1);
    Rect rect = Rect.fromLTRB(-radius + center.dx, -radius + center.dy, radius + center.dx, radius + center.dy);
    canvas.drawArc(rect, -Arc90, NeedArcRad, true, painter3);
    canvas.drawCircle(center, radius * 0.95, painter2);

  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return false;
  }
}