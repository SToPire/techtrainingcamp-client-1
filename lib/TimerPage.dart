import 'dart:async';

import 'package:flutter/material.dart';

class MyTimer extends StatefulWidget{
  @override
  _MyTimerState createState() => _MyTimerState();
}

class _MyTimerState extends State<MyTimer> {
  var _curTime = DateTime.now();
  var _startTime;
  Timer _timer;
  int _counterHour = 0;
  int _counterMin = 0;
  int _counterSec = 0;
  bool _startCount = false;

  @override
  void initState(){
    super.initState();
  }

  void _updateTime(){
    setState(() {
      print('UpdateTimer');
      if (_counterSec == 0 && _counterMin == 0 && _counterHour == 0){
        _startCount = false;
        return null;
      }
      _counterSec--;
      if (_counterSec < 0) {
        _counterSec += 60;
        _counterMin--;
      }
      if (_counterMin < 0) {
        _counterSec += 60;
        _counterMin--;
      }
      _curTime = DateTime.now();
      _timer = Timer(Duration(seconds: 1)
          + Duration(milliseconds: _startTime.millisecond)
          - Duration(milliseconds: _curTime.millisecond)
        , _updateTime,);
    });
  }

  void _incrementHour() {
    if (_startCount == true) return null;
    setState(() {
      _counterHour++;
    });
  }
  void _incrementMinute() {
    if (_startCount == true) return null;
    setState(() {
      _counterMin++;
    });
  }
  void _incrementSecond() {
    setState(() {
      if (_startCount == false)
      _counterSec++;
    });
  }

  void _startCounting(){
    setState((){
        _startCount = true;
        _startTime = DateTime.now();
        _updateTime();
    });

  }

  void _cancelCounting(){
    setState((){
      _startCount = false;
      _counterHour = 0;
      _counterMin = 0;
      _counterSec = 0;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("计时器"),
        ),
        body: Column(
          children: <Widget>[
            new Row(
              children: <Widget>[
                new RaisedButton(
                  onPressed: _incrementHour,
                  child: new Text('Hour:'),
                ),
                new Text('   $_counterHour时'),
              ],
            ),
            new Row(
              children: <Widget>[
                new RaisedButton(
                  onPressed: _incrementMinute,
                  child: new Text('Minute:'),
                ),
                new Text('   $_counterMin分'),
              ],
            ),
            new Row(
              children: <Widget>[
                new RaisedButton(
                  onPressed: _incrementSecond,
                  child: new Text('Second:'),
                ),
                new Text('   $_counterSec秒'),
              ],
            ),
            new Row(
              children: <Widget>[
                new RaisedButton(
                  onPressed: _startCounting,
                  child: new Text('Start'),
                ),
              ],
            ),
            new Row(
              children: <Widget>[
                new RaisedButton(
                  onPressed: _cancelCounting,
                  child: new Text('Cancel'),
                ),
              ],
            ),
          ]
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
