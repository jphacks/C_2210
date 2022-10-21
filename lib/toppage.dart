import 'package:app/signIn.dart';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:intl/intl.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'main.dart';
import 'edit.dart';
import 'login.dart';
import 'setting.dart';
import 'signin.dart' as googleSignInO;

class TopPage extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isAlarmOn = ref.watch(isAlarmOnProvider);

    // 予定もproviderで管理できるようにする
    Map<String, String> schedule = {
      'title': 'パーソナリティ心理学',
      'place': '名古屋大学教育学部',
    };
    final DateTime scheduleTime = DateTime(2022, 10, 16, 8, 45);

    // providerから値を受け取る
    final preparationTime = ref.watch(preparationTimeProvider);
    final preparationDateTime = DateTime(0, 0, 0, 0, preparationTime);
    final travelTime = ref.watch(travelTimeProvider);
    final travelDateTime = DateTime(0, 0, 0, 0, travelTime);
    // 出発時間などを計算
    final DateTime departureTime = scheduleTime.subtract(
        Duration(hours: travelDateTime.hour, minutes: travelDateTime.minute));
    final DateTime wakeUpDateTime = departureTime.subtract(Duration(
        hours: preparationDateTime.hour, minutes: preparationDateTime.minute));
    // DateTimeを型変換する
    final String wakeUpDate =
        DateFormat.MMMEd('ja').format(wakeUpDateTime).toString();
    String getTime(dateTime) {
      return DateFormat.Hm().format(dateTime).toString();
    }

    return Scaffold(
        appBar: PreferredSize(
          preferredSize: Size.fromHeight(50),
          child: AppBar(
            //systemOverlayStyle、Chromeでどう表示されてるのかわからない。隠されてる？
            systemOverlayStyle:
                SystemUiOverlayStyle(statusBarColor: Colors.lightBlue),
            backgroundColor: Color.fromARGB(255, 255, 255, 255),
            shadowColor: Colors.transparent,
            iconTheme: IconThemeData(color: Colors.grey[700], size: 30),
            title: Text(
              wakeUpDate,
              style: TextStyle(color: Colors.grey[700]),
            ),
            actions: [
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.transparent,
                  shadowColor: Colors.transparent,
                ),
                onPressed: () {
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => EditPage()));
                },
                child: Container(
                    margin: EdgeInsets.symmetric(vertical: 10, horizontal: 0),
                    padding: EdgeInsets.symmetric(vertical: 0, horizontal: 10),
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: FractionalOffset.topLeft,
                        end: FractionalOffset.bottomRight,
                        colors: [
                          Color(0xFFFF8F2D),
                          Color(0xFFFF7700),
                        ],
                        stops: const [
                          0.0,
                          1.0,
                        ],
                      ),
                      borderRadius: BorderRadius.all(
                        Radius.circular(10),
                      ),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Icon(Icons.create, size: 20),
                        Container(
                          alignment: Alignment.centerLeft,
                          child: Text('編集',
                              style: TextStyle(
                                fontSize: 14,
                                color: Colors.white,
                              )),
                        )
                      ],
                    )),
              )
            ],
          ),
        ),
        drawer: Drawer(
            width: 240,
            child: ListView(
              children: [
                SizedBox(
                  height: 130,
                  child: DrawerHeader(
                    child: Container(
                      alignment: Alignment.bottomLeft,
                      padding: const EdgeInsets.all(10),
                      child: Row(
                        children: [
                          Container(
                              padding: const EdgeInsets.only(right: 15),
                              child: const Image(
                                image: AssetImage("logo.png"),
                                height: 30.0,
                              )),
                          Text('alarm',
                              textAlign: TextAlign.left,
                              style: TextStyle(
                                fontSize: 28,
                                fontWeight: FontWeight.bold,
                                color: Colors.grey[700],
                              ))
                        ],
                      ),
                    ),
                  ),
                ),
                ListTile(
                  leading: TextButton.icon(
                    icon: Icon(Icons.calendar_view_week_outlined,
                        color: Colors.grey[700]),
                    label: Text('１週間のアラーム',
                        style:
                            TextStyle(fontSize: 18, color: Colors.grey[700])),
                    onPressed: () {
                      showDialog<void>(
                          context: context,
                          builder: (_) {
                            return AlertDialog(
                              title: const Text('Thank you for using this app!',
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      color: Color.fromARGB(255, 255, 119, 0))),
                              content: Text('残念ながらこの機能はまだ未実装です。もう少し待っててね！',
                                  style: TextStyle(
                                      fontSize: 14, color: Colors.grey[700])),
                            );
                            ;
                          });
                    },
                  ),
                ),
                ListTile(
                  leading: TextButton.icon(
                    icon:
                        Icon(Icons.settings_outlined, color: Colors.grey[700]),
                    label: Text('設定',
                        style:
                            TextStyle(fontSize: 16, color: Colors.grey[700])),
                    onPressed: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => SettingPage()));
                    },
                  ),
                ),
                ListTile(
                  leading: TextButton.icon(
                    icon: Icon(Icons.logout_outlined, color: Colors.grey[700]),
                    label: Text('ログアウト',
                        style:
                            TextStyle(fontSize: 16, color: Colors.grey[700])),
                    onPressed: () {
                      googleSignInO.SignIn().signOutFromGoogleO();
                      Navigator.push(context,
                          MaterialPageRoute(builder: (context) => LoginPage()));
                    },
                  ),
                )
              ],
            )),
        body: SingleChildScrollView(
          child: Container(
            alignment: Alignment.center,
            child: Column(
              children: [
                Container(
                  width: MediaQuery.of(context).size.width,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: FractionalOffset.topCenter,
                      end: FractionalOffset.bottomCenter,
                      colors: [
                        Color(0xFFFFFFFF),
                        Color(0xFFFFE5AA),
                      ],
                    ),
                  ),
                  child: Column(
                    children: [
                      Container(
                        margin: EdgeInsets.only(top: 50, bottom: 20),
                        child: Text(getTime(wakeUpDateTime),
                            style: TextStyle(
                                fontSize: 100,
                                fontWeight: FontWeight.w400,
                                color: Colors.grey[700])),
                      ),
                      Text('起床',
                          style:
                              TextStyle(fontSize: 24, color: Colors.grey[700])),
                      Container(
                          child: (isAlarmOn == true)
                              ? Container(
                                  margin: EdgeInsets.all(30),
                                  child: OutlinedButton.icon(
                                    style: ButtonStyle(),
                                    onPressed: () {},
                                    icon: Icon(Icons.alarm_off_outlined,
                                        color: Colors.grey[500]),
                                    label: Text(
                                      'オフにする',
                                      style: TextStyle(color: Colors.grey[500]),
                                    ),
                                  ))
                              : Container(
                                  margin: EdgeInsets.all(30),
                                  child: OutlinedButton.icon(
                                    style: ButtonStyle(),
                                    onPressed: () {},
                                    icon: Icon(Icons.alarm_on_outlined,
                                        color: Color(0xFFFF8F2D)),
                                    label: Text(
                                      'オンにする',
                                      style:
                                          TextStyle(color: Color(0xFFFF8F2D)),
                                    ),
                                  ))),
                    ],
                  ),
                ),
                Container(
                  width: 290,
                  margin: EdgeInsets.only(top: 20),
                  alignment: Alignment.center,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Text(
                        '支度:',
                        style: TextStyle(color: Colors.grey[700], fontSize: 20),
                      ),
                      Text(getTime(preparationDateTime),
                          style:
                              TextStyle(color: Colors.grey[700], fontSize: 20))
                    ],
                  ),
                ),
                Container(
                    width: 290,
                    margin: EdgeInsets.only(top: 20),
                    padding: EdgeInsets.only(
                        top: 15, bottom: 15, left: 20, right: 40),
                    decoration: BoxDecoration(
                        color: Color(0xFFFFE5AA),
                        borderRadius: BorderRadius.circular(10)),
                    child: (Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text(
                          getTime(departureTime),
                          style:
                              TextStyle(color: Colors.grey[700], fontSize: 28),
                        ),
                        Text('出発',
                            style: TextStyle(
                                color: Colors.grey[700], fontSize: 20))
                      ],
                    ))),
                Container(
                  width: 290,
                  margin: EdgeInsets.only(top: 20),
                  alignment: Alignment.center,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Text(
                        '移動:',
                        style: TextStyle(color: Colors.grey[700], fontSize: 20),
                      ),
                      Text(getTime(travelDateTime),
                          style:
                              TextStyle(color: Colors.grey[700], fontSize: 20))
                    ],
                  ),
                ),
                Container(
                    width: 290,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      color: Color(0xFF007304),
                    ),
                    margin: EdgeInsets.symmetric(vertical: 20, horizontal: 0),
                    padding: EdgeInsets.all(20),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          getTime(scheduleTime),
                          style: TextStyle(color: Colors.white, fontSize: 28),
                        ),
                        Text(
                          schedule['title'].toString(),
                          style: TextStyle(color: Colors.white, fontSize: 20),
                        ),
                        Row(
                          children: [
                            Icon(
                              Icons.place_outlined,
                              color: Colors.white,
                              size: 20,
                            ),
                            Text(
                              schedule['place'].toString(),
                              style:
                                  TextStyle(color: Colors.white, fontSize: 20),
                            ),
                          ],
                        )
                      ],
                    )),
                Container(
                    width: 290,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      color: Color(0xFF007304),
                    ),
                    margin: EdgeInsets.symmetric(vertical: 20, horizontal: 0),
                    padding: EdgeInsets.all(20),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          getTime(scheduleTime),
                          style: TextStyle(color: Colors.white, fontSize: 28),
                        ),
                        Text(
                          schedule['title'].toString(),
                          style: TextStyle(color: Colors.white, fontSize: 20),
                        ),
                        Row(
                          children: [
                            Icon(
                              Icons.place_outlined,
                              color: Colors.white,
                              size: 20,
                            ),
                            Text(
                              schedule['place'].toString(),
                              style:
                                  TextStyle(color: Colors.white, fontSize: 20),
                            ),
                          ],
                        )
                      ],
                    )),
                Container(
                    width: 290,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      color: Color(0xFF007304),
                    ),
                    margin: EdgeInsets.symmetric(vertical: 20, horizontal: 0),
                    padding: EdgeInsets.all(20),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          getTime(scheduleTime),
                          style: TextStyle(color: Colors.white, fontSize: 28),
                        ),
                        Text(
                          schedule['title'].toString(),
                          style: TextStyle(color: Colors.white, fontSize: 20),
                        ),
                        Row(
                          children: [
                            Icon(
                              Icons.place_outlined,
                              color: Colors.white,
                              size: 20,
                            ),
                            Text(
                              schedule['place'].toString(),
                              style:
                                  TextStyle(color: Colors.white, fontSize: 20),
                            ),
                          ],
                        )
                      ],
                    )),
                Container(
                  height: 40,
                )
              ],
            ),
          ),
        ));
  }
}
