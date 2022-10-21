import 'package:flutter/material.dart';
import 'package:flutter_picker/flutter_picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:intl/intl.dart';
import 'main.dart';

class SettingPage extends StatefulWidget {
  @override
  _SettingPageState createState() => _SettingPageState();
}

class _SettingPageState extends State<SettingPage> {
  List<Map> PlaceList = [
    {'place': 'aaaaaaaaaaaaaaaaaaaaaaaaaaaa', 'time': DateTime(0, 0, 0, 1, 25)},
    {'place': 'バイト先', 'time': DateTime(0, 0, 0, 0, 15)},
    {'place': '大学', 'time': DateTime(0, 0, 0, 0, 15)}
  ];
  var NewPlaceName = '';
  DateTime NewPlaceTime = DateTime(0, 0, 0, 0, 0);
  var pushnotification = true;
  var prepar_hour = 0;
  var prepar_minutes = 0;
  var move_hour = 0;
  var move_minutes = 0;
  DateTime notifyDateTime = DateTime(0, 0, 0, 0, 0);

  void _showBottom() async {
    var value = await showModalBottomSheet<_SettingPageState>(
        context: context,
        builder: (BuildContext context) {
          return new Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(20),
            ),
            height: 175,
            padding: new EdgeInsets.symmetric(vertical: 30.0, horizontal: 50),
            child: new Column(
              children: <Widget>[
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    SizedBox(
                        width: 150,
                        child: Column(children: [
                          Container(
                              alignment: Alignment.bottomLeft,
                              child: Text('場所')),
                          TextFormField(
                            onChanged: (String value) {
                              setState(() {
                                NewPlaceName = value;
                              });
                            },
                          ),
                        ])),
                    Column(children: [
                      Container(
                          alignment: Alignment.topLeft, child: Text('時間')),
                      InkWell(
                          child: Text(getTime(NewPlaceTime)),
                          onTap: () async {
                            Picker(
                              adapter: DateTimePickerAdapter(
                                  type: PickerDateTimeType.kHM,
                                  value: DateTime(
                                      0, 0, 0, prepar_hour, prepar_minutes)),
                              title: Text('移動時間を編集'),
                              onConfirm: (Picker picker, List value) {
                                setState(() => {
                                      prepar_hour = value[0],
                                      prepar_minutes = value[1]
                                    });
                              },
                            ).showModal(context);
                          })
                    ]),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    TextButton(
                      onPressed: () {
                        // ボタンが押されたときに発動される処理
                        Navigator.pop(context);
                      },
                      child: Text('キャンセル',
                          style: TextStyle(
                              color: Color(0xffff9900), fontSize: 12)),
                    ),
                    TextButton(
                      onPressed: () {
                        // ボタンが押されたときに発動される処理
                        Navigator.pop(context);
                      },
                      child: Text('追加',
                          style: TextStyle(
                              color: Color(0xffff9900), fontSize: 12)),
                    ),
                  ],
                ),
              ],
            ),
          );
        });
  }

  String getTime(dateTime) {
    return DateFormat.Hm().format(dateTime).toString();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: FractionalOffset.topCenter,
            end: FractionalOffset.bottomCenter,
            colors: [
              Color.fromARGB(255, 255, 255, 255).withOpacity(0.6),
              Color.fromARGB(255, 255, 226, 169).withOpacity(0.6),
            ],
            stops: const [
              0.0,
              1.0,
            ],
          ),
        ),
        child: Scaffold(
            backgroundColor: Colors.transparent,
            appBar: AppBar(
              elevation: 0,
              backgroundColor: Colors.transparent,
              automaticallyImplyLeading: false,
              centerTitle: true,
              leading: Container(
                padding: EdgeInsets.only(top: 30),
                child: OverflowBox(
                  maxWidth: 75,
                  child: TextButton(
                    onPressed: () {
                      // ボタンが押されたときに発動される処理
                      Navigator.pop(context);
                    },
                    child: Text('< 戻る',
                        style:
                            TextStyle(color: Color(0xffff9900), fontSize: 16)),
                  ),
                ),
              ),
              title: Container(
                padding: EdgeInsets.only(top: 30),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.settings, color: Colors.grey),
                    Text('設定',
                        style: TextStyle(color: Colors.black, fontSize: 24))
                  ],
                ),
              ),
              actions: [
                Container(
                  padding: EdgeInsets.only(top: 30),
                  child: TextButton(
                    onPressed: () {
                      // ボタンが押されたときに発動される処理
                      Navigator.pop(context);
                    },
                    child: Text('確定',
                        style: TextStyle(
                            color: Color(0xffff9900),
                            fontSize: 16,
                            fontWeight: FontWeight.bold)),
                  ),
                )
              ],
            ),
            body: Container(
              padding: EdgeInsets.only(left: 50, right: 50, top: 30),
              child: ListView(
                children: [
                  Container(
                    padding: EdgeInsets.only(bottom: 12),
                    child: Column(
                      children: [
                        Text('デフォルトの支度時間'),
                        Container(
                          padding: EdgeInsets.symmetric(
                              horizontal: 30, vertical: 10),
                          margin: EdgeInsets.symmetric(vertical: 3),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: InkWell(
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.end,
                                children: [
                                  Container(
                                    alignment: Alignment.centerRight,
                                    width: 50,
                                    padding: EdgeInsets.only(right: 10),
                                    child: Text(prepar_hour.toString(),
                                        style: TextStyle(
                                          color: Color(0xffff9900),
                                          fontSize: 32,
                                        )),
                                  ),
                                  Text('h',
                                      style: TextStyle(
                                        fontSize: 20,
                                      )),
                                  Container(
                                    alignment: Alignment.center,
                                    width: 60,
                                    child: Text(
                                        prepar_minutes
                                            .toString()
                                            .padLeft(2, "0"),
                                        style: TextStyle(
                                          color: Color(0xffff9900),
                                          fontSize: 32,
                                        )),
                                  ),
                                  Text('m',
                                      style: TextStyle(
                                        fontSize: 20,
                                      )),
                                ],
                              ),
                              onTap: () async {
                                Picker(
                                  adapter: DateTimePickerAdapter(
                                      type: PickerDateTimeType.kHM,
                                      value: DateTime(0, 0, 0, prepar_hour,
                                          prepar_minutes)),
                                  title: Text('移動時間を編集'),
                                  onConfirm: (Picker picker, List value) {
                                    setState(() => {
                                          prepar_hour = value[0],
                                          prepar_minutes = value[1]
                                        });
                                  },
                                ).showModal(context);
                              }),
                        )
                      ],
                    ),
                  ),
                  Container(
                    padding: EdgeInsets.symmetric(vertical: 12),
                    child: Column(
                      children: [
                        Text('デフォルトの移動時間'),
                        Container(
                          padding: EdgeInsets.symmetric(
                              horizontal: 30, vertical: 10),
                          margin: EdgeInsets.symmetric(vertical: 3),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: InkWell(
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.end,
                                children: [
                                  Container(
                                    alignment: Alignment.centerRight,
                                    width: 50,
                                    padding: EdgeInsets.only(right: 10),
                                    child: Text(move_hour.toString(),
                                        style: TextStyle(
                                          color: Color(0xffff9900),
                                          fontSize: 32,
                                        )),
                                  ),
                                  Text('h',
                                      style: TextStyle(
                                        fontSize: 20,
                                      )),
                                  Container(
                                    alignment: Alignment.center,
                                    width: 60,
                                    child: Text(
                                        move_minutes.toString().padLeft(2, "0"),
                                        style: TextStyle(
                                          color: Color(0xffff9900),
                                          fontSize: 32,
                                        )),
                                  ),
                                  Text('m',
                                      style: TextStyle(
                                        fontSize: 20,
                                      )),
                                ],
                              ),
                              onTap: () async {
                                Picker(
                                  adapter: DateTimePickerAdapter(
                                      type: PickerDateTimeType.kHM,
                                      value: DateTime(
                                          0, 0, 0, move_hour, move_minutes)),
                                  title: Text('支度時間を編集'),
                                  onConfirm: (Picker picker, List value) {
                                    setState(() => {
                                          move_hour = value[0],
                                          move_minutes = value[1]
                                        });
                                  },
                                ).showModal(context);
                              }),
                        ),
                        Text('場所が指定されていない場合、デフォルトの移動時間でアラームがセットされます',
                            style: TextStyle(fontSize: 8)),
                      ],
                    ),
                  ),
                  Container(
                    padding: EdgeInsets.only(top: 12, bottom: 24),
                    child: Column(
                      children: [
                        Text('通知', textAlign: TextAlign.left),
                        Container(
                          padding: EdgeInsets.all(10),
                          margin: EdgeInsets.symmetric(vertical: 3),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Column(
                            children: [
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text("プッシュ通知"),
                                  Transform.scale(
                                    scale: 0.8,
                                    child: CupertinoSwitch(
                                      activeColor: Color(0xffff9900),
                                      value: pushnotification,
                                      onChanged: (value) {
                                        setState(() {
                                          pushnotification = value;
                                        });
                                      },
                                    ),
                                  )
                                ],
                              ),
                              Divider(
                                color: Colors.grey,
                                thickness: 1,
                              ),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text("タイミング"),
                                  Container(
                                    padding: EdgeInsets.only(right: 12),
                                    child: InkWell(
                                        child: Text(getTime(notifyDateTime)),
                                        onTap: () async {
                                          Picker(
                                            adapter: DateTimePickerAdapter(
                                                type: PickerDateTimeType.kHM,
                                                value: notifyDateTime),
                                            title: Text('通知時間を編集'),
                                            onConfirm:
                                                (Picker picker, List value) {
                                              setState(() => {
                                                    notifyDateTime = DateTime(
                                                        0,
                                                        0,
                                                        0,
                                                        value[0],
                                                        value[1])
                                                  });
                                            },
                                          ).showModal(context);
                                        }),
                                  )
                                ],
                              )
                            ],
                          ),
                        ),
                        Text('指定した時間に、翌日のアラーム時刻、出発時刻、目的地、到着時刻、目的地の場所を通知します',
                            style: TextStyle(fontSize: 8)),
                      ],
                    ),
                  ),
                  Text('よく行く場所'),
                  for (var index = 0; index < PlaceList.length; index++)
                    Container(
                      padding:
                          EdgeInsets.symmetric(horizontal: 15, vertical: 5),
                      margin: EdgeInsets.symmetric(vertical: 3),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Container(
                            width: 175,
                            child: Text(
                              PlaceList[index]['place'],
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          Container(
                              child: Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              Icon(Icons.hourglass_bottom),
                              Text(PlaceList[index]['time'].hour.toString()),
                              Text('h'),
                              Text(PlaceList[index]['time']
                                  .minute
                                  .toString()
                                  .padLeft(2, '0')),
                              Text('m'),
                            ],
                          ))
                        ],
                      ),
                    ),
                  InkWell(
                    child: Container(
                        padding:
                            EdgeInsets.symmetric(horizontal: 15, vertical: 5),
                        margin: EdgeInsets.symmetric(vertical: 3),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          border: Border.all(width: 1),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        alignment: Alignment.center,
                        child: Text('+追加')),
                    onTap: () {
                      _showBottom();
                    },
                  )
                  /* Expanded(
                    child: Column(
                      children: [
                        Text('よく行く場所'),
                        Expanded(
                          child: ListView.builder(
                            itemCount: PlaceList.length,
                            itemBuilder: (context, index) {
                              return Container(
                                padding: EdgeInsets.symmetric(
                                    horizontal: 15, vertical: 5),
                                margin: EdgeInsets.symmetric(vertical: 3),
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Container(
                                      width: 175,
                                      child: Text(
                                        PlaceList[index]['place'],
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ),
                                    Container(
                                        child: Row(
                                      mainAxisAlignment: MainAxisAlignment.end,
                                      children: [
                                        Icon(Icons.hourglass_bottom),
                                        Text(PlaceList[index]['time']
                                            .hour
                                            .toString()),
                                        Text('h'),
                                        Text(PlaceList[index]['time']
                                            .minute
                                            .toString()
                                            .padLeft(2, '0')),
                                        Text('m'),
                                      ],
                                    ))
                                  ],
                                ),
                              );
                            },
                          ),
                        ),
                        InkWell(
                          child: Container(
                              padding: EdgeInsets.symmetric(
                                  horizontal: 15, vertical: 5),
                              margin: EdgeInsets.symmetric(vertical: 3),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                border: Border.all(width: 1),
                                borderRadius: BorderRadius.circular(10),
                              ),
                              alignment: Alignment.center,
                              child: Text('+追加')),
                          onTap: () {
                            _showBottom();
                          },
                        )
                      ],
                    ),
                  ) */
                ],
              ),
            )));
  }
}
