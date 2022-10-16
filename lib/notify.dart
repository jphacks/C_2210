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
  // インスタンス生成
  final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  Future<void> _cancelNotification(int month, int day) async {
    //IDを指定して通知をキャンセル
    await flutterLocalNotificationsPlugin.cancel(month * 100 + day);
    await flutterLocalNotificationsPlugin.cancel(month * 100 + day + 10000);
  }

  /// ローカル通知をスケジュールする
  Future<void> _alarm(
      int year, int month, int day, int hour, int minutes) async {
    final tz.TZDateTime now = tz.TZDateTime.now(tz.local);
    // 初期化
    flutterLocalNotificationsPlugin.initialize(
      InitializationSettings(
          android: AndroidInitializationSettings(
              'mipmap/ic_launcher'), // app_icon.pngを配置
          iOS: DarwinInitializationSettings()),
    );
    // アラームを設定する
    int id = month * 100 + day;
    await flutterLocalNotificationsPlugin.zonedSchedule(
        androidAllowWhileIdle: true,
        id, // id
        'アラーム', // title
        '朝ですよ $id', // body
        tz.TZDateTime(
          tz.local,
          year,
          month,
          day,
          hour,
          minutes,
        ),
        NotificationDetails(
          android: AndroidNotificationDetails(
            'qawsedrftgyhujikolp',
            'my_channel_name',
            channelDescription: 'my_channel_description',
            importance: Importance.max,
            priority: Priority.high,
            autoCancel: false,
            playSound: true,
          ),
        ),
        uiLocalNotificationDateInterpretation:
            UILocalNotificationDateInterpretation.absoluteTime);

    // 前日の通知を設定する
    tz.TZDateTime notification_time = tz.TZDateTime(
      tz.local,
      year,
      month,
      day,
      20,
      0,
    );

    notification_time = notification_time.add(const Duration(days: -1));
    if (now.isBefore(notification_time)) {
      await flutterLocalNotificationsPlugin.zonedSchedule(
          androidAllowWhileIdle: true,
          id + 10000, // id
          '明日は$hour時$minutes分に起きよう！', // title
          '$id', // body
          notification_time,
          NotificationDetails(
            android: AndroidNotificationDetails(
              'my_channel_id',
              'my_channel_name',
              channelDescription: 'my_channel_description',
              importance: Importance.low,
              priority: Priority.low,
              playSound: false,
            ),
          ),
          uiLocalNotificationDateInterpretation:
              UILocalNotificationDateInterpretation.absoluteTime);
    }
  }
}

class NotificationSamplePage extends StatelessWidget {
  Notify notify = Notify();
  final tz.TZDateTime now =
      tz.TZDateTime.now(tz.local).add(const Duration(days: -20));
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Center(
            child: Row(children: [
      FloatingActionButton(
        onPressed: () {
          notify._alarm(2022, 10, 16, 16, 12);
        }, // ボタンを押したら通知をスケジュールする
        child: Text("${now.day}"),
      ),
    ])));
  }
}
