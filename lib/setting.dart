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
  List<Map> PlaceList = [];
  var NewPlaceName = '';
  var NewPlaceTime = 0;
  var pushnotification = true;
  var prepar_hour = 0;
  var prepar_minutes = 0;
  var move_hour = 0;
  var move_minutes = 0;
  DateTime notifyDateTime = DateTime(0, 0, 0, 0, 0);

  @override
  Widget build(BuildContext context) {
    String getTime(dateTime) {
      return DateFormat.Hm().format(dateTime).toString();
    }

    return Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: FractionalOffset.topCenter,
            end: FractionalOffset.bottomCenter,
            colors: [
              const Color(0xffffffff),
              const Color(0xfffff2df),
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
            leading: OverflowBox(
              maxWidth: 75,
              child: TextButton(
                onPressed: () {
                  // ボタンが押されたときに発動される処理
                  Navigator.pop(context);
                },
                child: Text('< 戻る',
                    style: TextStyle(color: Color(0xffff9900), fontSize: 16)),
              ),
            ),
            title: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.settings, color: Colors.grey),
                Text('設定', style: TextStyle(color: Colors.black, fontSize: 24))
              ],
            ),
            actions: [
              TextButton(
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
            ],
          ),
          body: Container(
              padding: EdgeInsets.symmetric(horizontal: 50, vertical: 50),
              child: Column(
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
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                crossAxisAlignment: CrossAxisAlignment.end,
                                children: [
                                  Container(
                                    alignment: Alignment.center,
                                    width: 40,
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
                                    width: 40,
                                    child: Text(prepar_minutes.toString(),
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
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                crossAxisAlignment: CrossAxisAlignment.end,
                                children: [
                                  Container(
                                    alignment: Alignment.center,
                                    width: 40,
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
                                    width: 40,
                                    child: Text(move_minutes.toString(),
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
                  Expanded(
                    child: Column(
                      children: [
                        Text('よく行く場所'),
                        Expanded(
                          child: ListView.builder(
                            itemCount: PlaceList.length,
                            itemBuilder: (context, index) {
                              return Container(
                                padding: EdgeInsets.symmetric(
                                    horizontal: 10, vertical: 5),
                                margin: EdgeInsets.symmetric(vertical: 1),
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                child: Row(
                                  children: [
                                    Text("大学"),
                                    Text('a'),
                                  ],
                                ),
                              );
                            },
                          ),
                        ),
                        ElevatedButton.icon(
                          icon: const Icon(
                            Icons.add,
                            color: Colors.white,
                          ),
                          label: const Text('追加'),
                          onPressed: () {
                            if (/* NewPlaceName != "" && NewPlaceTime != "" */ true) {
                              try {
                                setState(() {
                                  // メンバーの追加
                                  PlaceList.add({
                                    'name': NewPlaceName, // 名前
                                  });
                                  // 新しいメンバーの値を初期化
                                  NewPlaceName = "";
                                });
                                // テキストフィールドの入力を削除
                                //_memberNameController.clear();
                                //_memberPaymentController.clear();
                              } catch (e) {
                                setState(() {
                                  //例外が発生したら実行する処理
                                  //FormExceptionText = "金額は数字で入力してください";
                                });
                              }
                            }
                          },
                        ),
                      ],
                    ),
                  )
                ],
              )),
        ));
  }
}
