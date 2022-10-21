import 'package:googleapis/calendar/v3.dart' as calendarO;
import 'package:extension_google_sign_in_as_googleapis_auth/extension_google_sign_in_as_googleapis_auth.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:googleapis/websecurityscanner/v1.dart';
import 'loginF.dart';

class GetInfo {
  late calendarO.CalendarApi googleCalendarApiO;
  Future<void> getStartTime() async {
    //ここエラー処理いる？
    try {
      final storage = FlutterSecureStorage();
      final String? googleCalendarAccesstoken =
          await storage.read(key: 'GOOGLE_CALENDAR_ACCESSTOKEN');
      if (googleCalendarAccesstoken == null) {
        print("キャンセル");
        throw Exception();
      }
    } catch (e) {
      return;
    }

    // Google認証情報を入れるプロパティ
// 本来はAuthClient型で宣言するプロパティだが、AuthClientを明示すると、googleapis_authパッケージのインポートが必要になるので、varで宣言してインポートを回避する
// ※googleapis_authパッケージは、extension_google_sign_in_as_googleapis_authパッケージ内でインポート済のため、本コード内でインポートしなくても動作する
    late var httpClientO;
    httpClientO = SignIn().httpClientO;

    /// Googleカレンダーからの情報取得処理
// 起動後最初にこのボタンを実行した場合に備え、ここでも
// Googleサインインで認証済のHTTPクライアントのインスタンスを作成
//     try {
//       //httpClientO = (await SignIn().googleSignInO.authenticatedClient())!;
//     } catch (eO) {
//       print("権限付与エラー $eO");
// // エラーの場合は、同意画面に再度チェックさせるため、一度完全サインアウトする
//       await SignIn().signOutFromGoogleO();
//       return;
//     }
// // Google Calendar APIのインスタンスを作成
    googleCalendarApiO = calendarO.CalendarApi(httpClientO);
// 予定情報を取得したいカレンダーのIDを指定
// 本サンプルコードでは、「primary」カレンダーとする
    //String calendarIdO = "primary";
    String calendarIdO = "ja.japanese#holiday@group.v.calendar.google.com";
    List<String> calendarIdList = [];
    int count = 0;
    List<calendarO.CalendarListEntry>? calendarListEntryO;
    try {
      calendarO.CalendarList calendarListO =
          await googleCalendarApiO.calendarList.list();
      calendarListEntryO = calendarListO.items;
      calendarListEntryO!.forEach((elementO) {
        print("calendarIdを表示 ${elementO.id}");
        calendarIdList.add(elementO.id.toString());
        count++;
      });
// iOSで同意画面にチェックせず続行した場合のエラー処理
    } catch (eO) {
      print("権限付与エラー $eO");
      //await SignIn().signOutFromGoogleO();
      return;
    }
    //データ取得
    for (int i = 0; i < count; i++) {
      try {
        await googleCalendarApiO.events
            .list(calendarIdList[i],
                timeMin: DateTime.now(),
                maxResults: 9999,
                //timeZone: "Asia/Tokyo",デフォルトはカレンダーのタイムゾーンのため指定せず
                singleEvents: true,
                orderBy: "startTime")
            .then(
// events.listメソッドの返り値（Event型）をvalueOで受ける
          (valueO) {
// 端末のTimeZoneで表示するため、.toLocal()をつける
            //print(valueO.toJson());
            for (int i = 0; i < valueO.items!.length; i++) {
              print(valueO.items![i].start!.dateTime!.toLocal().toString());
              print(valueO.items![i].location);
            }
          },
        ); //このitemの中身がない時とそもそものエラーの時とかの違いどうしよ...
// エラーの時はデータが無いので、何もせずリターン
      } catch (e) {
        print("${i}個目、予定データなし $e");
        //return;
      }
    }
  }
}
