import 'package:app/signIn.dart';
import 'package:flutter/material.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:intl/intl.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'main.dart';
import 'edit.dart';
import 'login.dart';
import 'setting.dart';

class TopPage extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
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
        // header部分
        // Todo: 背景を透過させる
        appBar: AppBar(
          title: Text(
            wakeUpDate,
            style: TextStyle(color: Colors.black),
          ),
          iconTheme: const IconThemeData(color: Color(0xFF000000)),
          backgroundColor: Colors.transparent,
          elevation: 0.0,
          actions: [
            ElevatedButton.icon(
              style: ElevatedButton.styleFrom(
                primary: Color(0xFFFF9900),
              ),
              icon: Icon(Icons.create),
              label: Text('編集'),
              onPressed: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => EditPage()));
              },
            ),
          ],
        ),
        drawer: Drawer(
            child: ListView(
          children: [
            DrawerHeader(child: Text('alarm')),
            ListTile(
              leading: TextButton(
                child: Text('設定画面'),
                onPressed: () {
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => SettingPage()));
                },
              ),
            ),
            ListTile(
              leading: TextButton(
                child: Text('ログアウト'),
                onPressed: () {
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => LoginPage()));
                },
              ),
            )
          ],
        )),
        // メイン部分
        body: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                  color: Colors.amber[100],
                  child: Column(children: [
                    Text(getTime(wakeUpDateTime),
                        style: TextStyle(fontSize: 64)),
                    Text('起床'),
                  ])),
              Text('支度 ' + getTime(preparationDateTime)),
              Text(getTime(departureTime) + ' 出発'),
              Text('移動 ' + getTime(travelDateTime)),
              // google chalenderから取ってきた予定を表示。ListTile使ったほうがいいかも
              Container(
                  color: Colors.green,
                  child: Column(
                    children: [
                      Text(getTime(scheduleTime),
                          style: TextStyle(fontSize: 24)),
                      Text(schedule['title'].toString()),
                      Text(schedule['place'].toString()),
                    ],
                  )),
            ],
          ),
        ));
  }
}
