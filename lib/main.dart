import 'package:flutter/material.dart';
import 'dart:async';
import 'hand.dart';
import 'package:vector_math/vector_math_64.dart' show radians;

final radPerTick = radians(360/60);
final radPerHour = radians(360/12);

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        // This is the theme of your application.
        //
        // Try running your application with "flutter run". You'll see the
        // application has a blue toolbar. Then, without quitting the app, try
        // changing the primarySwatch below to Colors.green and then invoke
        // "hot reload" (press "r" in the console where you ran "flutter run",
        // or simply save your changes to "hot reload" in a Flutter IDE).
        // Notice that the counter didn't reset back to zero; the application
        // is not restarted.
        primarySwatch: Colors.blue,
        // This makes the visual density adapt to the platform that you run
        // the app on. For desktop platforms, the controls will be smaller and
        // closer together (more dense) than on mobile platforms.
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: MyClock(),
    );
  }
}

class MyClock extends StatefulWidget{
  @override
  _MyClockState createState() => _MyClockState();
}

class _MyClockState extends State<MyClock>{
  var _curTime = DateTime.now();
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
        body: Center(
            child:Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Stack(
                  children:[
                    Container(
                        width: 50,
                        height: 50,
                        alignment: Alignment.center,
                        child:Hand(color:Colors.red, size:1,thickness: 1,angleRad: _curTime.second * radPerTick,)
                    ),
                    Container(
                        width: 50,
                        height: 50,
                        alignment: Alignment.center,
                        child:Hand(color:Colors.blue, size:0.8,thickness: 2,angleRad: _curTime.minute * radPerTick,)
                    ), Container(
                        width: 50,
                        height: 50,
                        alignment: Alignment.center,
                        child:Hand(color:Colors.yellow, size:0.6,thickness: 4,angleRad: _curTime.hour * radPerHour,)
                    ),
                  ],
                ),
                Text('${_curTime.hour}时${_curTime.minute}分${_curTime.second}秒'),
              ],
            )
        )
    );
  }
}
