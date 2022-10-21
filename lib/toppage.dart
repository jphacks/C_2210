import 'package:app/signIn.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
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
            style: const TextStyle(color: Colors.black),
          ),
          iconTheme: const IconThemeData(color: Color(0xFF000000)),
          backgroundColor: Colors.transparent,
          elevation: 0.0,
          actions: [
            ElevatedButton.icon(
              style: ElevatedButton.styleFrom(
                primary: const Color(0xFFFF9900),
              ),
              icon: const Icon(Icons.create),
              label: const Text('編集'),
              onPressed: () {
                Navigator.push(context,
                    MaterialPageRoute(
                      builder: (context) => EditPage(),
                      fullscreenDialog: true,
                    ));
              },
            ),
          ],
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
        // メイン部分
        body: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                  color: Colors.amber[100],
                  child: Column(children: [
                    Text(getTime(wakeUpDateTime),
                        style: const TextStyle(fontSize: 64)),
                    const Text('起床'),
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
                          style: const TextStyle(fontSize: 24)),
                      Text(schedule['title'].toString()),
                      Text(schedule['place'].toString()),
                    ],
                  )),
            ],
          ),
        ));
  }
}
