import 'package:flutter/material.dart';
import 'dart:async';
import 'package:vector_math/vector_math_64.dart' show radians;
import 'dart:math' as math;
import 'dart:ui';

import 'hand.dart';
import 'dial.dart';

final radPerTick = radians(360/60);
final radPerHour = radians(360/12);

class MyClock extends StatefulWidget{
  @override
  _MyClockState createState() => _MyClockState();
}

class _MyClockState extends State<MyClock>{
  final dialSize = window.physicalSize.width / 4;
  var _curTime = DateTime.now();

  bool is24HourClock = false;
  Timer _timer;

  @override
  void initState(){
    super.initState();
    _updateTime();
  }

  void _updateTime(){
    setState(() {
      _curTime = DateTime.now();
      _timer = Timer(
        Duration(seconds: 1) - Duration(milliseconds: _curTime.millisecond),
        _updateTime,
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("时钟"),
        ),
        drawer: Drawer(
          child:ListView(
            children: <Widget>[
              DrawerHeader(
                decoration: BoxDecoration(
                  color: Colors.blue,
                ),
                child: Text("Header"),
              ),
              CheckboxListTile(
                title:Text('24小时计时法'),
                value: is24HourClock == true,
                onChanged:(bool value){
                  setState(() {
                    is24HourClock = value;
                  });
                }
              ),
            ]
          ),
        ),
        body: Center(
            child:Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Expanded(
                  child:Center(
                    child:Stack(
                      children:[
                        Container(
                            width:dialSize,
                            height:dialSize,
                            alignment:Alignment.center,
                            child:Dial()
                        ),
                        Container(
                          width: dialSize,
                          height: dialSize,
                          alignment: Alignment.center,
                          child:Hand(color:Colors.red, size:0.88,thickness: 1,angleRad: _curTime.second * radPerTick,)
                        ),
                        Container(
                          width: dialSize,
                          height: dialSize,
                          alignment: Alignment.center,
                          child:Hand(color:Colors.deepPurple, size:0.8,thickness: 2,angleRad: (_curTime.minute + _curTime.second / 60) * radPerTick,)
                        ),
                        Container(
                          width: dialSize,
                          height: dialSize,
                          alignment: Alignment.center,
                          child:Hand(color:Colors.brown, size:0.6,thickness: 4,angleRad: (_curTime.hour + _curTime.minute / 60) * radPerHour,)
                        ),
                        Container(
                            width:dialSize,
                            height:dialSize,
                            alignment:Alignment.center,
                            child:Hand(color:Colors.red, size:0.08,thickness: 1,angleRad: math.pi +  _curTime.second * radPerTick,)
                        )
                      ],
                    )
                  )
                ),
                Expanded(
                    child:Center(
                        child:Text(
                          (is24HourClock == true ? '' : (_curTime.hour > 12 ? '下午' : '上午')) +
                          '${(is24HourClock == true) ? _curTime.hour : (_curTime.hour % 12)}时${_curTime.minute}分${_curTime.second}秒',
                          style: TextStyle(
                            color:Colors.black,
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        )
                    )
                ),
              ],
            )
        ),
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
