import 'dart:isolate';
import 'dart:math';
import 'dart:ui';

import 'package:flutter_sujian_select/flutter_select.dart';
import 'package:flutter/material.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';

class ClockDate{
  var chour;
  var cmin;
  var csec;
  bool state;
  List<int> rept;
  ClockDate(this.chour,this.cmin,this.csec,this.state,this.rept);
}

List<ClockDate> cdlist = [];


/*void main(){
  runApp(MyApp());
}*/


class AlarmPage extends StatefulWidget {
  @override
  _AlarmPageState createState() => _AlarmPageState();
}

class _AlarmPageState extends State<AlarmPage> {
  int _counter = 0;
  //List<ClockDate> cdlist = [];
  @override
  void initState() {
    //AndroidAlarmManager.initialize();
    super.initState();
    //AndroidAlarmManager.periodic(const Duration(seconds: 1), 0, checkClock);
  }
  TextEditingController timeController = TextEditingController();
  DateTime selectTime = DateTime.now();

  Widget ShowListData(BuildContext context,ClockDate data){
    String words;
    if (data.rept==null) words='无重复';
    else {
      words = '';
      if (data.rept.indexOf(1) != -1) words = '${words} 周一';
      if (data.rept.indexOf(2) != -1) words = '${words} 周二';
      if (data.rept.indexOf(3) != -1) words = '${words} 周三';
      if (data.rept.indexOf(4) != -1) words = '${words} 周四';
      if (data.rept.indexOf(5) != -1) words = '${words} 周五';
      if (data.rept.indexOf(6) != -1) words = '${words} 周六';
      if (data.rept.indexOf(7) != -1) words = '${words} 周日';
    }
    return Container(
      color: Colors.white,
      padding: EdgeInsets.all(15),
      child: Row(
        children: <Widget>[
          ClipRRect(
            borderRadius: BorderRadius.circular(4),
            child: Icon(
              Icons.alarm,
            ),
          ),
          Padding(padding: EdgeInsets.only(left: 15)),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Text(
                      '${data.chour}:${data.cmin}:${data.csec}',
                      style: TextStyle(
                        fontSize: 26,
                        fontWeight: FontWeight.w500,
                        color: Color(0xFF333333),
                      ),
                    ),
                    Switch(
                      value: data.state,
                      activeColor: Colors.blue,     // 激活时原点颜色
                      onChanged: (bool val) {
                        this.setState(() {
                          data.state = !data.state;
                          print(data.state);
                        });
                      },
                    ),
                  ],
                ),
                Padding(padding: EdgeInsets.only(top: 2)),
                Text(
                  '重复天数：$words',
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontSize: 15,
                    color: Color(0xFF999999),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context)  {
    return Scaffold(
      appBar: AppBar(
        title: Text('闹钟列表'),
      ),
      body: Center(
        child:ListView.separated(
          itemCount: cdlist.length,
          itemBuilder: (context,index){
            return ShowListData(context, cdlist[index]);
          },
          separatorBuilder: (context,index){
            return Divider(
              height: .5,
              indent: 75,
              color: Color(0xFFDDDDDD),
            );
          },
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed:() async{
          Navigator.push(
              context,
              MaterialPageRoute(builder: (context) =>SecondScreen(),)).then(
                  (data) {
                setState(() {
                  ClockDate backdata = new ClockDate(data.chour, data.cmin, data.csec, data.state,data.rept);
                  cdlist.add(backdata);
                  print(cdlist.length);
                  //Isolate.spawn(threadTask, backdata);
                });
              });
        },
        tooltip: 'Increment',
        child: Icon(Icons.add),
      ),
    );

  }

  static void threadTask(ClockDate cd) async{
    int mark=1;
    while (true){
      var NowT=DateTime.now();
      if (NowT.hour==cd.chour && NowT.minute==cd.cmin){
        mark=0;
        print({'hhh':cd.cmin});
        //showTT();
      }
      if (mark==0) break;
    }
  }
  void showTT(){
    showDialog(
        context: context,
        builder: (context) =>
            AlertDialog(
              title: Text('test'),
            ));
    setState(() {
      timeController.clear();
    });
  }
  static Future<void> checkClock() async{
    var NowT=DateTime.now();
    print({'Alarm':NowT});
    print(cdlist.length);
    for (int i=0;i<cdlist.length;i++) {
      if (cdlist[i].state==false) continue;
      if (NowT.hour==cdlist[i].chour && NowT.minute==cdlist[i].cmin){
        print({'hhhh:'});
        cdlist[i].state=false;
      }
    }
  }

}
class SecondScreen extends StatefulWidget{
  @override
  SecondScreenState createState(){
    return new SecondScreenState();
  }
}

class SecondScreenState extends State<SecondScreen>{

  var selectTime = DateTime.now();
  ClockDate cd;
  Widget build(BuildContext context){
    //print('${this} hashCode=${this.hashCode}');
    cd = new ClockDate(selectTime.hour, selectTime.minute, selectTime.second, true,null);
    return Scaffold(
      appBar: AppBar(
        title: Text('新建闹钟'),
      ),
      body: Center(
        child: Column(
            children:<Widget>[
              Text(
                '',
                style: Theme.of(context).textTheme.headline1,
              ),
              Text(
                '${cd.chour}:${cd.cmin}:${cd.csec}',
                style: Theme.of(context).textTheme.headline2,
              ),
              FlatButton(
                  onPressed: () {
                    DatePicker.showTimePicker(context,
                        // 是否展示顶部操作按钮
                        showTitleActions: true,
                        // change事件
                        onChanged: (date) {
                          //print('change $date');
                        },
                        // 确定事件
                        onConfirm: (date) {
                          //print('confirm $date');
                          setState(() {
                            selectTime = date;
                            cd.chour=selectTime.hour;
                            cd.cmin=selectTime.minute;
                            cd.csec=selectTime.second;
                          });
                        },
                        // 当前时间
                        // currentTime: DateTime(2019, 6, 20, 17, 30, 20), // 指定时间
                        currentTime: DateTime.now(), // 当前时间
                        // 语言
                        locale: LocaleType.zh);
                  },
                  child: Text(
                    '选择闹钟时间',
                    style: TextStyle(
                      color: Colors.blue,
                      fontSize: 20,
                    ),
                  )),
              Text(
                '',
                style: Theme.of(context).textTheme.headline3,
              ),
              SelectGroup<int>(
                type: SelectType.multiple,
                space:const EdgeInsets.all(3.0),
                padding:const EdgeInsets.all(11.0),
                //style: SelectStyle.rectangle,
                //direction: SelectDirection.vertical,
                //listIndex: [1,2],
                items: <SelectItem<int>>[
                  SelectItem(label: '周一',value: 1),
                  SelectItem(label: '周二',value: 2),
                  SelectItem(label: '周三',value: 3),
                  SelectItem(label: '周四',value: 4),
                  SelectItem(label: '周五',value: 5),
                  SelectItem(label: '周六',value: 6),
                  SelectItem(label: '周日',value: 7),
                ],
                onMultipleSelect: (List<int> value){
                  print(value);
                  cd.rept=value;
                },
              ),

              Text(
                'Repeat Selection',
                style:TextStyle(
                  color: Colors.blue,
                  fontSize: 20,
                ),
              ),
              Text(
                '',
                style: Theme.of(context).textTheme.headline4,
              ),
              RaisedButton(
                  child: Text("确定"),
                  onPressed: () {
                    ClockDate dat = cd;
                    Navigator.of(context).pop(dat);
                  }
              ),
            ]
        ),
      ),
    );
  }
}
