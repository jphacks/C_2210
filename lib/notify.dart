import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/data/latest.dart' as tz;
import 'package:timezone/timezone.dart' as tz;

import 'main.dart';

/*
仕様書
Notify hoge = Notify();のようにしてインスタンス作成
notify._alarm(DateTime(アラーム日時), int(アラーム音現状1~5まで), bool(バイブレーションの有無));
で目覚まし&前日の通知をセット
notify._cancelNotification(DateTime(キャンセルする日付));
で目覚まし&前日の通知をキャンセル
時間やアラーム音を変更するだけなら上の関数を実行すれば上書きされる
 */
//日本標準時に設定
Future<void> setup() async {
  tz.initializeTimeZones();
  var tokyo = tz.getLocation('Asia/Tokyo');
  tz.setLocalLocation(tokyo);
}

class Notify {
  // インスタンス生成
  final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  Future<void> _cancelNotification(DateTime time) async {
    //IDを指定して通知をキャンセル
    await flutterLocalNotificationsPlugin.cancel(time.month * 100 + time.day);
    await flutterLocalNotificationsPlugin
        .cancel(time.month * 100 + time.day + 10000);
  }

  /// ローカル通知をスケジュールする
  Future<void> _alarm(DateTime time, int sound, bool vibration) async {
    final tz.TZDateTime now = tz.TZDateTime.now(tz.local);
    // 初期化
    flutterLocalNotificationsPlugin.initialize(
      InitializationSettings(
          android: AndroidInitializationSettings(
              'mipmap/ic_launcher'), // app_icon.pngを配置
          iOS: DarwinInitializationSettings()),
    );
    // アラームを設定する
    int id = time.month * 100 + time.day;
    await flutterLocalNotificationsPlugin.zonedSchedule(
        androidAllowWhileIdle: true,
        id, // id
        'アラーム', // title
        '朝ですよ $id', // body
        tz.TZDateTime(
          tz.local,
          time.year,
          time.month,
          time.day,
          time.hour,
          time.minute,
        ), //通知時間
        //通知の詳細を指定
        NotificationDetails(
          android: AndroidNotificationDetails(
            'sound${sound},vibration${vibration}',
            'my_channel_name',
            channelDescription: 'my_channel_description',
            importance: Importance.max,
            priority: Priority.high,
            playSound: true, //音の有無
            sound: RawResourceAndroidNotificationSound('sound${sound}'), //音の指定
            enableVibration: vibration, //バイブレーションの設定
          ),
          iOS: DarwinNotificationDetails(
              threadIdentifier: 'signal',
              //sound:'sound1',
              presentSound: true, //音の有無
              presentAlert: true,
              presentBadge: true),
        ),
        uiLocalNotificationDateInterpretation:
            UILocalNotificationDateInterpretation.absoluteTime);

    // 前日の通知を設定する
    tz.TZDateTime notification_time = tz.TZDateTime(
      tz.local,
      time.year,
      time.month,
      time.day,
      20,
      0,
    );

    notification_time = notification_time.add(const Duration(days: -1));
    if (now.isBefore(notification_time)) {
      await flutterLocalNotificationsPlugin.zonedSchedule(
          androidAllowWhileIdle: true,
          id + 10000, // id
          '明日は${time.hour}時${time.minute}分に起きよう！', // title
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
              enableVibration: false,
            ),
            iOS: DarwinNotificationDetails(
              threadIdentifier: 'Notification',
              presentSound: false,
              presentAlert: false,
              presentBadge: false,
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
          notify._alarm(DateTime.now().add(Duration(minutes: 1)), 1, true);
        }, // ボタンを押したら通知をスケジュールする
        child: Text("${now.day}"),
      ),
      FloatingActionButton(
        onPressed: () {
          notify._cancelNotification(DateTime.now());
        }, // ボタンを押したら通知を削除
        child: Text("cancel"),
      ),
    ])));
  }
}
