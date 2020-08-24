import 'package:flutter/material.dart';
import 'dart:async';
import 'package:vector_math/vector_math_64.dart' show radians;
import 'dart:math' as math;
import 'dart:ui';

import 'ClockHand.dart';
import 'ClockDial.dart';
import 'WeatherStore.dart';

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
    weatherStore.getWeather();
  }

  void _updateTime() {
    setState(() {
      _curTime = DateTime.now();
      _timer = Timer(
        Duration(seconds: 1) - Duration(milliseconds: _curTime.millisecond),
        _updateTime,
      );
    });
  }

  void _selectCity(context){
    showModalBottomSheet(
        context: context,
        builder: (BuildContext context){
          return Center(
            heightFactor: 1.5,
            child:TextField(
              onSubmitted: (String s){
                weatherStore.updateCity(s);
              },
              decoration: InputDecoration(
                border: OutlineInputBorder(),
                labelText: '输入城市名',
              ),
            ),
          );
        }
    );
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
                child: Text(
                  '选项',
                  style: TextStyle(
                    fontSize: 40,
                  )
                ),
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
              ListTile(
                title: Text('选择城市'),
                enabled: true,
                onTap: (){
                  _selectCity(context);
                },
              ),
            ]
          ),
        ),
        body: Center(
            child:Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Expanded(
                  flex:3,
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
                Expanded(
                  child:Center(
                      child:Text(
                          weatherStore.city,
                          style: TextStyle(
                            color:Colors.blueAccent,
                            fontSize: 36,
                            fontWeight: FontWeight.bold,
                          ),
                      )
                  )
                ),
                Expanded(
                    child:Center(
                        child:Text(
                            weatherStore.text + ' ' +
                                '今日${weatherStore.tempMin}~${weatherStore.tempMax}摄氏度 当前${weatherStore.temp}摄氏度',
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

