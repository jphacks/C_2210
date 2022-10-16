import 'package:flutter/material.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:intl/intl.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'main.dart';
import 'edit.dart';
import 'setting.dart';

class TopPage extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    String getTime(dateTime) {
      return DateFormat.Hm().format(dateTime).toString();
    }

    // 予定はバックから受け取る
    Map<String, String> schedule = {
      'title': 'パーソナリティ心理学',
      'place': '名古屋大学教育学部',
    };

    // 最初の予定の時間をバックから受け取る
    final DateTime scheduleTime = DateTime(2022, 10, 16, 8, 45);

    final preparationTime = ref.watch(preparationTimeProvider);
    final preparationDateTime = DateTime(0, 0, 0, 0, preparationTime);
    final travelTime = ref.watch(travelTimeProvider);
    final travelDateTime = DateTime(0, 0, 0, 0, travelTime);
    // 出発時間などを計算、フォーマット
    final DateTime departureTime = scheduleTime.subtract(
        Duration(hours: travelDateTime.hour, minutes: travelDateTime.minute));
    final DateTime wakeUpDateTime = departureTime.subtract(Duration(
        hours: preparationDateTime.hour, minutes: preparationDateTime.minute));
    final String wakeUpDate =
        DateFormat.yMMMMEEEEd('ja').format(wakeUpDateTime).toString();

    return Scaffold(
        body: Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
              color: Colors.amber[100],
              child: Column(children: [
                Text(wakeUpDate),
                Text(getTime(wakeUpDateTime), style: TextStyle(fontSize: 48)),
                Text('起床'),
              ])),
          Text('支度 ' + getTime(preparationDateTime)),
          Text(getTime(departureTime) + ' 出発'),
          Text('移動 ' + getTime(travelDateTime)),
          Container(
              color: Colors.green,
              child: Column(
                children: [
                  Text(getTime(scheduleTime), style: TextStyle(fontSize: 24)),
                  Text(schedule['title'].toString()),
                  Text(schedule['place'].toString()),
                ],
              )),
          TextButton(
            child: Text('ログイン画面に戻る'),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
          TextButton(
            child: Text('編集ページへ'),
            onPressed: () async {
              final editedTravelTime = await Navigator.push(
                  context, MaterialPageRoute(builder: (context) => EditPage()));
            },
          ),
          TextButton(
            child: Text('設定画面へ'),
            onPressed: () {
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => SettingPage()));
            },
          )
        ],
      ),
    ));
  }
}
