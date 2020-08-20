import 'package:flutter/material.dart';
import 'dart:async';
import 'package:vector_math/vector_math_64.dart' show radians;
import 'dart:math' as math;
import 'dart:ui';

import 'hand.dart';
import 'dial.dart';

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
  final dialSize = window.physicalSize.width / 4;
  var _curTime = DateTime.now();
  Timer _timer;

  int _selectedBottomNavigationBarIndex = 0;

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

  void _onBottomNavigationBarTapped(int index){
    setState(() {
      _selectedBottomNavigationBarIndex = index;
    });
  }



  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("时钟"),
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
                        '${_curTime.hour}时${_curTime.minute}分${_curTime.second}秒',
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
        bottomNavigationBar: BottomNavigationBar(
          items: const <BottomNavigationBarItem>[
            BottomNavigationBarItem(
              icon: Icon(Icons.alarm),
              title:Text("sss"),
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.home),
              title:Text("ttt"),
            ),
          ],
          currentIndex: _selectedBottomNavigationBarIndex,
          selectedItemColor: Colors.red,
          onTap: _onBottomNavigationBarTapped,
        ),
    );
  }
}
