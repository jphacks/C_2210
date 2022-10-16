import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/data/latest.dart' as tz;
import 'package:timezone/timezone.dart' as tz;

import 'main.dart';

Future<void> setup() async {
  tz.initializeTimeZones();
  var tokyo = tz.getLocation('Asia/Tokyo');
  tz.setLocalLocation(tokyo);
}

class Notify {
  tz.TZDateTime _convertTime(int hour, int minutes) {
    final tz.TZDateTime now = tz.TZDateTime.now(tz.local);
    tz.TZDateTime scheduleDate = tz.TZDateTime(
      tz.local,
      now.year,
      now.month,
      now.day,
      hour,
      minutes,
    );
    if (scheduleDate.isBefore(now)) {
      scheduleDate = scheduleDate.add(const Duration(days: 1));
    }
    return scheduleDate;
  }

  /// ローカル通知をスケジュールする
  Future<void> _scheduleLocalNotification(int hour, int minutes) async {
    // インスタンス生成
    final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
        FlutterLocalNotificationsPlugin();
    final tz.TZDateTime now = tz.TZDateTime.now(tz.local);
    // 初期化
    flutterLocalNotificationsPlugin.initialize(
      InitializationSettings(
          android: AndroidInitializationSettings(
              'mipmap/ic_launcher'), // app_icon.pngを配置
          iOS: DarwinInitializationSettings()),
    );
    // スケジュール設定する
    int id = now.month * 100 + now.day;
    flutterLocalNotificationsPlugin.zonedSchedule(
        androidAllowWhileIdle: true,
        id, // id
        'Local Notification Title $id', // title
        'Local Notification Body $id', // body
        _convertTime(hour, minutes),
        NotificationDetails(
          android: AndroidNotificationDetails(
              'my_channel_id', 'my_channel_name',
              channelDescription: 'my_channel_description',
              importance: Importance.max,
              priority: Priority.high),
        ),
        uiLocalNotificationDateInterpretation:
            UILocalNotificationDateInterpretation.absoluteTime);
  }
}

class NotificationSamplePage extends StatelessWidget {
  Notify notify = Notify();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Center(
            child: Row(children: [
      FloatingActionButton(
        onPressed: () {
          notify._scheduleLocalNotification(11, 39);
        }, // ボタンを押したら通知をスケジュールする
        child: Text("Notify"),
      ),
    ])));
  }
}
