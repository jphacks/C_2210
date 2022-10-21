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
  var pushnotification = true;
  var prepar_hour = 0;
  var prepar_minutes = 0;
  var move_hour = 0;
  var move_minutes = 0;
  DateTime notifyDateTime = DateTime(0, 0, 0, 0, 0);

  void _addPlace(name, time) {
    setState(() => {
          PlaceList.add({
            'place': name,
            'time': time,
          })
        });
  }

  void _setPlace(name, time, index) {
    setState(() => {
          PlaceList[index] = {'place': name, 'time': time}
        });
  }

  void _showBottom(name, time, index) async {
    var NewPlaceName = name;
    DateTime NewPlaceTime = time;
    String errorMessege = '';
    String confirmMessege = index == -1 ? '追加' : '確定';

    var value = await showDialog<_SettingPageState>(
        context: context,
        builder: (BuildContext context) {
          return StatefulBuilder(builder: (context, setState) {
            return AlertDialog(
              content: Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                ),
                height: 162,
                padding: const EdgeInsets.symmetric(horizontal: 10),
                child: Column(
                  children: <Widget>[
                    Container(
                      alignment: Alignment.bottomLeft,
                      child: Text(
                        '場所',
                        textAlign: TextAlign.left,
                      ),
                    ),
                    TextFormField(
                      initialValue: NewPlaceName,
                      onChanged: (String value) {
                        setState(() {
                          NewPlaceName = value;
                        });
                      },
                    ),
                    SizedBox(height: 10),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text('時間'),
                        InkWell(
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                Text(NewPlaceTime.hour.toString()),
                                Text('h'),
                                Text(NewPlaceTime.minute
                                    .toString()
                                    .padLeft(2, "0")),
                                Text('m')
                              ],
                            ),
                            onTap: () async {
                              Picker(
                                adapter: DateTimePickerAdapter(
                                    type: PickerDateTimeType.kHM,
                                    value: NewPlaceTime),
                                title: Text('移動時間を編集'),
                                onConfirm: (Picker picker, List value) {
                                  setState(() => {
                                        NewPlaceTime = DateTime(
                                            0, 0, 0, value[0], value[1])
                                      });
                                },
                              ).showModal(context);
                            }),
                      ],
                    ),
                    SizedBox(height: 10),
                    SizedBox(
                      height: 20,
                      child: Text(errorMessege, style: TextStyle(fontSize: 12)),
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
                            if (NewPlaceName == '') {
                              setState(() => {errorMessege = '場所が入力されていません'});
                            } else if (index == -1) {
                              _addPlace(NewPlaceName, NewPlaceTime);
                              // ボタンが押されたときに発動される処理
                              Navigator.pop(context);
                            } else {
                              _setPlace(NewPlaceName, NewPlaceTime, index);
                              Navigator.pop(context);
                            }
                          },
                          child: Text(confirmMessege,
                              style: TextStyle(
                                  color: Color(0xffff9900),
                                  fontSize: 12,
                                  fontWeight: FontWeight.bold)),
                        ),
                      ],
                    )
                  ],
                ),
              ),
            );
          });
        });
  }

  String getTime(dateTime) {
    return DateFormat.Hm().format(dateTime).toString();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: FractionalOffset.topCenter,
            end: FractionalOffset.bottomCenter,
            colors: [
              Color.fromARGB(255, 255, 255, 255),
              Color.fromARGB(255, 255, 226, 169),
            ],
            stops: [
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
            leading: OverflowBox(
              maxWidth: 75,
              child: TextButton(
                onPressed: () {
                  // ボタンが押されたときに発動される処理
                  Navigator.pop(context);
                },
                child: const Text('< 戻る',
                    style: TextStyle(color: Color(0xffff9900), fontSize: 16)),
              ),
            ),
            title: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.settings, color: Colors.grey),
                Text('設定',
                    style: TextStyle(color: Colors.grey[700], fontSize: 24))
              ],
            ),
            actions: [
              Container(
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
          body: ListView.builder(
            itemCount: PlaceList.length + 2,
            itemBuilder: (context, index) {
              if (index == 0) {
                return Column(
                  children: [
                    Container(
                      padding: EdgeInsets.only(top: 30, bottom: 12),
                      child: Column(
                        children: [
                          Text(
                            'デフォルトの支度時間',
                            style: TextStyle(color: Colors.grey[700]),
                          ),
                          Container(
                            padding: EdgeInsets.symmetric(
                                horizontal: 30, vertical: 10),
                            margin: EdgeInsets.symmetric(
                                horizontal: 50, vertical: 3),
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
                                          color: Colors.grey[700],
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
                                          color: Colors.grey[700],
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
                                    title: Text(
                                      '移動時間を編集',
                                      style: TextStyle(color: Colors.grey[700]),
                                    ),
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
                      margin: EdgeInsets.symmetric(horizontal: 50),
                      child: Column(
                        children: [
                          Text(
                            'デフォルトの移動時間',
                            style: TextStyle(color: Colors.grey[700]),
                          ),
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
                                          color: Colors.grey[700],
                                          fontSize: 20,
                                        )),
                                    Container(
                                      alignment: Alignment.center,
                                      width: 60,
                                      child: Text(
                                          move_minutes
                                              .toString()
                                              .padLeft(2, "0"),
                                          style: TextStyle(
                                            color: Color(0xffff9900),
                                            fontSize: 32,
                                          )),
                                    ),
                                    Text('m',
                                        style: TextStyle(
                                          color: Colors.grey[700],
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
                                    title: Text(
                                      '支度時間を編集',
                                      style: TextStyle(color: Colors.grey[700]),
                                    ),
                                    onConfirm: (Picker picker, List value) {
                                      setState(() => {
                                            move_hour = value[0],
                                            move_minutes = value[1]
                                          });
                                    },
                                  ).showModal(context);
                                }),
                          ),
                          Container(
                            child: Text('場所が指定されていない場合、デフォルトの移動時間でアラームがセットされます',
                                style: TextStyle(
                                    color: Colors.grey[700], fontSize: 8)),
                          )
                        ],
                      ),
                    ),
                    Container(
                      padding: EdgeInsets.only(top: 12, bottom: 24),
                      margin: EdgeInsets.symmetric(horizontal: 50),
                      child: Column(
                        children: [
                          Text(
                            '通知',
                            textAlign: TextAlign.left,
                            style: TextStyle(color: Colors.grey[700]),
                          ),
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
                                    Text(
                                      "プッシュ通知",
                                      style: TextStyle(color: Colors.grey[700]),
                                    ),
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
                                    Text(
                                      "タイミング",
                                      style: TextStyle(color: Colors.grey[700]),
                                    ),
                                    Container(
                                      padding: EdgeInsets.only(right: 12),
                                      child: InkWell(
                                          child: Text(getTime(notifyDateTime)),
                                          onTap: () async {
                                            Picker(
                                              adapter: DateTimePickerAdapter(
                                                  type: PickerDateTimeType.kHM,
                                                  value: notifyDateTime),
                                              title: Text(
                                                '通知時間を編集',
                                                style: TextStyle(
                                                    color: Colors.grey[700]),
                                              ),
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
                          Container(
                            child: Text(
                                '指定した時間に、翌日のアラーム時刻、出発時刻、目的地、到着時刻、目的地の場所を通知します',
                                style: TextStyle(
                                    color: Colors.grey[700], fontSize: 8)),
                          )
                        ],
                      ),
                    ),
                    Text(
                      'よく行く場所',
                      style: TextStyle(color: Colors.grey[700]),
                    ),
                  ],
                );
              } else if (index <= PlaceList.length) {
                return Container(
                  padding: EdgeInsets.symmetric(horizontal: 15, vertical: 5),
                  margin: EdgeInsets.symmetric(horizontal: 50, vertical: 3),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: InkWell(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Container(
                          width: 160,
                          child: Text(
                            PlaceList[index - 1]['place'],
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(color: Colors.grey[700]),
                          ),
                        ),
                        Container(
                            child: Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            Icon(Icons.hourglass_bottom),
                            Container(
                                alignment: Alignment.centerRight,
                                width: 16,
                                child: Text(
                                    PlaceList[index - 1]['time']
                                        .hour
                                        .toString(),
                                    style: TextStyle(color: Colors.grey[700]))),
                            Text(
                              'h',
                              style: TextStyle(color: Colors.grey[700]),
                            ),
                            Text(
                              PlaceList[index - 1]['time']
                                  .minute
                                  .toString()
                                  .padLeft(2, '0'),
                              style: TextStyle(color: Colors.grey[700]),
                            ),
                            Text(
                              'm',
                              style: TextStyle(color: Colors.grey[700]),
                            ),
                          ],
                        ))
                      ],
                    ),
                    onTap: () {
                      _showBottom(PlaceList[index - 1]['place'],
                          PlaceList[index - 1]['time'], index - 1);
                    },
                  ),
                );
              } else {
                return Container(
                    margin: EdgeInsets.only(right: 50, left: 50, bottom: 30),
                    child: InkWell(
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
                          child: Text(
                            '+追加',
                            style: TextStyle(color: Colors.grey[700]),
                          )),
                      onTap: () {
                        _showBottom('', DateTime(0, 0, 0, 0, 0), -1);
                      },
                    ));
              }
            },
          ),
        ));
  }
}
