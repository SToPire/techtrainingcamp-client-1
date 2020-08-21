import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'dart:async';
import 'package:vector_math/vector_math_64.dart' show radians;
import 'dart:math' as math;
import 'dart:ui';

import 'TimerDial.dart';

var _curTime = DateTime.now();
var _startTime;
Timer _timer;
int _counterHour = 0;
int _counterMin = 0;
int _counterSec = 0;
int _startCount = 0;

class MyTimer extends StatefulWidget{
  @override
  _MyTimerState createState() => _MyTimerState();
}

class MyStartTime extends StatefulWidget{
  @override
  _MyStartState createState() => _MyStartState();
}

class _MyStartState extends State<MyStartTime> {
  final dialSize = window.physicalSize.width / 4;
  var _startTime;
  var _curTime = DateTime.now();
  var _countDownColor = Colors.white70;
  int rangeSum = 0;

  void _updateTime(){
    setState(() {
      if (_counterSec == 0 && _counterMin == 0 && _counterHour == 0){
        _startCount = 0;
        return null;
      }
      if (_counterSec == 1 && _counterMin == 0 && _counterHour == 0)
        _countDownColor = Colors.redAccent;


      _counterSec--;
      if (_counterSec < 0) {
        _counterSec += 60;
        _counterMin--;
      }
      if (_counterMin < 0) {
        _counterMin += 60;
        _counterHour--;
      }
      _curTime = DateTime.now();
      _timer = Timer(Duration(seconds: 1)
          + Duration(milliseconds: _startTime.millisecond)
          - Duration(milliseconds: _curTime.millisecond)
        , _updateTime,);
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _startTime = DateTime.now();
    rangeSum = _counterHour * 3600 + _counterMin * 60 + _counterSec;
    _updateTime();
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return new Center(
      child: Stack(
        children:[
          Container(
              width:dialSize,
              height:dialSize,
              alignment:Alignment.center,
              child: Booster(rangeSum),
          ),
          Container(
              width:dialSize,
              height:dialSize,
              alignment:Alignment.center,
              child:Text(
                '${_counterHour~/10}${_counterHour%10}:'
                    '${_counterMin~/10}${_counterMin%10}:'
                    '${_counterSec~/10}${_counterSec%10}',
                style: TextStyle(
                  color: _countDownColor,
                  fontSize: 36,
                  fontWeight: FontWeight.normal,
                ),
              )
          ),
        ],
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

class MySetTime extends StatefulWidget{
  @override
  _MySetState createState() => _MySetState();
}

class _MySetState extends State<MySetTime> {
  void _incrementHour() {
    if (_startCount == 1) return null;
    setState(() {
      _counterHour++;
    });
  }
  void _incrementMinute() {
    if (_startCount == 1) return null;
    setState(() {
      _counterMin++;
    });
  }
  void _incrementSecond() {
    setState(() {
      if (_startCount == 0)
        _counterSec++;
    });
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return new Container(
        alignment: Alignment.bottomCenter,
        child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              new Column(
                children: <Widget>[
                  new Text(
                    '\n\n$_counterHour小时\n',
                    style: TextStyle(
                      color:Colors.black87,
                      fontSize: 25,
                      fontWeight: FontWeight.normal,
                    ),
                  ),
                  new RaisedButton(
                    onPressed: _incrementHour,
                    child: new Text('Hour:'),
                  ),
                ],
              ),
              new Column(
                children: <Widget>[
                  new Text(
                      '\n\n$_counterMin分钟\n',
                    style: TextStyle(
                      color:Colors.black87,
                      fontSize: 25,
                      fontWeight: FontWeight.normal,
                    ),
                  ),
                  new RaisedButton(
                    onPressed: _incrementMinute,
                    child: new Text('Minute:'),
                  ),
                ],
              ),
              new Column(
                children: <Widget>[
                  new Text(
                      '\n\n$_counterSec秒\n',
                    style: TextStyle(
                      color:Colors.black87,
                      fontSize: 25,
                      fontWeight: FontWeight.normal,
                    ),
                  ),
                  new RaisedButton(
                    onPressed: _incrementSecond,
                    child: new Text('Second:'),
                  ),
                ],
              ),
            ]
        ),
    );
  }
}

class _MyTimerState extends State<MyTimer> {
  List<Widget> list = List();

  @override
  void initState() {
    list
      ..add(MySetTime())
      ..add(MyStartTime());
    super.initState();
  }

  void _startCounting(){
    setState((){
      _startCount = 1;
    });
  }

  void _cancelCounting(){
    setState((){
      _startCount = 0;
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
            children: [
              Expanded(
                child:list[_startCount]
              ),
              Expanded(
                  child: Container(
                      alignment: Alignment.center,
                      child:Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: <Widget> [
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
                  ),
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
