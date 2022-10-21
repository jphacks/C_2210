import 'package:flutter/material.dart';

// クラス名、メソッド名、プロパティ名（変数名）について、筆者が作成したもの（名前変更可のもの）
// の名前の末尾には、大文字のオー「O」をつけています
// ※ライブラリ（パッケージ）で予め決められているもの（名前の変更不可のもの）と、
//  自分で作成したもの（名前の変更可のもの）の区別をしやすくするため
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart' as signInO;
import 'package:googleapis/calendar/v3.dart' as calendarO;
import 'package:extension_google_sign_in_as_googleapis_auth/extension_google_sign_in_as_googleapis_auth.dart';
//import 'package:uuid/uuid.dart';
import 'package:http/http.dart' as http;

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import 'package:googleapis_auth/auth_browser.dart';

// class SignIn extends StatefulWidget {
//   @override
//   _SignInState createState() => _SignInState();
// }

//アクセストークンがなければサインインの必要があるが、あればその必要はない
class SignIn {
// Google SignIn認証のためのインスタンス
  late signInO.GoogleSignIn googleSignInO;
// GoogleSignInAccount?（ユーザー情報を保持するクラス）のインスタンス
// サインインをキャンセルしたときはnullになりうるので、null許容「?」で定義するcredentials
  signInO.GoogleSignInAccount? accountO;
// Google認証情報を入れるプロパティ
// 本来はAuthClient型で宣言するプロパティだが、AuthClientを明示すると、googleapis_authパッケージのインポートが必要になるので、varで宣言してインポートを回避する
// ※googleapis_authパッケージは、extension_google_sign_in_as_googleapis_authパッケージ内でインポート済のため、本コード内でインポートしなくても動作する
  late var httpClientO;
// Google Calendar APIのインスタンス
// ※googleapisパッケージのインポート文に、as calendarO を付けているので、googleapisのクラスには「calendarO.」を付けて表記
  late calendarO.CalendarApi googleCalendarApiO;
// Google SignInの状態を示す文字列 ※起動時は空文字
  String signInStatusO = "";

  /// Google SignIn処理をするメソッド
  Future<bool> googleSignInMethodO() async {
    //リフレッシュトークンのやつが実装できればこれを有効にしてもいいかも
    // final storage = FlutterSecureStorage();
    // final String? password =
    //     await storage.read(key: 'GOOGLE_CALENDAR_ACCESSTOKEN');

// Google SignIn認証のためのインスタンスを作成
    googleSignInO = signInO.GoogleSignIn(scopes: [
// Google APIで使用したいスコープを指定
// ※ここではGoogleカレンダーへのアクセス権を要求
      //calendarO.CalendarApi.calendarScope,
      calendarO.CalendarApi
          .calendarReadonlyScope, //calendarScopeだと権限が大きすぎるのでこっちの方が良いと思われる
    ]);
// サインイン画面や同意画面のポップアップをキャンセルした場合のエラーを回避するため、try catchを設定
// 但し、デバッグモードでは止まってしまうので、キャンセル時の挙動を確かめるには、Runモードで実行する必要あり
    try {
// isSignedInメソッドでサインイン済か否か確認
      final checkSignInResultO = await googleSignInO.isSignedIn();
      print("サインインしているか否か $checkSignInResultO");
// サインイン済の場合は、サインインのポップアップを出さずにサインイン処理する
// ※iOSの場合はsignInSilentlyにしないと、毎回サインインのポップアップが出てしまうため
      if (checkSignInResultO) {
        accountO = await googleSignInO.signInSilently();
// サインイン済にもかかわらず返り値がnullの場合、
// ユーザーがGoogleアカウントの設定画面で接続解除をした可能性があるので、
// disconnectメソッドで完全サインアウトし、認証情報を初期化する
        if (accountO == null) {
          print("認証情報を初期化する必要が生じたため、もう一度ボタンを押してください。");
          await googleSignInO.disconnect();
          throw Exception();
        }
      } else {
// サインインしていない場合は、ポップアップを出してサインイン処理
        accountO = await googleSignInO.signIn();
// 返り値がnullだったら、サインインもしくは同意処理がキャンセルされたと判断し、
        if (accountO == null) {
          print("キャンセル");
          throw Exception();
        }
      }
//アクセストークン保存　　　　//リフレッシュトークンうんぬんカンヌンも実装したい、、、
      httpClientO = (await googleSignInO.authenticatedClient())!;
      print("Googleカレンダーアクセストークン：${httpClientO.credentials.accessToken}");
      String googleCalendarAccesstoken =
          httpClientO.credentials.accessToken.data;
      final storage = FlutterSecureStorage();
      await storage.write(
          key: 'GOOGLE_CALENDAR_ACCESSTOKEN',
          value: '${googleCalendarAccesstoken}');
// /// firebase上にサインインしたユーザー情報を記録する場合は以下を追加
// // ※firebase_auth、firebase_coreのインポートが必要
//アクセストークンを得て、それをローカルに保存するだけ、つまりGoogleカレンダーから予定の時間と場所を取得するためだけならばfirebaseにユーザー情報を登録する必要はないと思うので、今のところここからの何行かは消しても良い
      signInO.GoogleSignInAuthentication authO = await accountO!.authentication;

      final OAuthCredential credentialO = GoogleAuthProvider.credential(
        idToken: authO.idToken,
        accessToken: authO.accessToken,
      );
//
// // このユーザーデータ（userO）を必要に応じて使用する //どうしよ、、、
      User? userO =
          (await FirebaseAuth.instance.signInWithCredential(credentialO)).user;

// // 使用する一例として、Firebase上で管理される「ユーザーUID」をログに表示 //とりあえずこれは使わなさそう？
      print("ユーザーUID: ${userO!.uid}");
// サインイン表示に変更し、再描画
      print("サインイン中");
// 返り値trueを返す
      return true;
    } catch (e) {
// サインアウト表示に変更し、再描画
      print("サインアウト中");
// 返り値falseを返す
      print("サインインできず $e");
      return false;
    }
  }

  /// ステップ② 予定情報の取得
  Future<void> getScheduleO() async {
    /// Google SignInの処理
// サインインせずに実行した場合に備え、ここでもサインイン処理をする
    final signInResultO = await googleSignInMethodO();
    if (!signInResultO) {
// サインインできなかった場合は、早期リターン
      return;
    }

    /// Googleカレンダーからの情報取得処理
// 起動後最初にこのボタンを実行した場合に備え、ここでも
// Googleサインインで認証済のHTTPクライアントのインスタンスを作成
    try {
      httpClientO = (await googleSignInO.authenticatedClient())!;
    } catch (eO) {
      print("権限付与エラー $eO");
// エラーの場合は、同意画面に再度チェックさせるため、一度完全サインアウトする
      await signOutFromGoogleO();
      return;
    }
    // var hoge = AccessCredentials ();
    //final storage = FlutterSecureStorage();

    //hoge.credentials.accessToken =
    //   storage.read(key: 'GOOGLE_CALENDAR_ACCESSTOKEN');
// Google Calendar APIのインスタンスを作成
    googleCalendarApiO = calendarO.CalendarApi(httpClientO);
// 予定情報を取得したいカレンダーのIDを指定
// 本サンプルコードでは、「primary」カレンダーとする
    //String calendarIdO = "primary";
    String calendarIdO = "dev7618jifekd@gmail.com";
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
        //print(elementO.id.nextSyncToken.toString());
        count++;
      });
// iOSで同意画面にチェックせず続行した場合のエラー処理
    } catch (eO) {
      print("権限付与エラー $eO");
      await signOutFromGoogleO();
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
            print(valueO.toJson());
            print("これから");
            print(valueO.nextSyncToken);
            for (int i = 0; i < valueO.items!.length; i++) {
              print(valueO.items![i].start!.dateTime!.toLocal().toString());
              print(valueO.items![i].location);
            }

            final storage = FlutterSecureStorage();
            final Future<String?> googleCalendarAccesstoken =
                storage.read(key: 'GOOGLE_CALENDAR_ACCESSTOKEN');

// var client = http.Client();
// try {
//   var response =  client.post(
//       Uri.https('example.com', 'whatsit/create'),
//       body: {'name': 'doodle', 'color': 'blue'});
//   var decodedResponse = jsonDecode(utf8.decode(response.bodyBytes)) as Map;
//   var uri = Uri.parse(decodedResponse['uri'] as String);
//   print(await client.get(uri));
// } finally {
//   client.close();
// }

            final httpsUri = Uri.https(
                'www.googleapis.com',
                '/calendar/v3/calendars/${calendarIdO}/events',
                {'key': 'AIzaSyAbvyniuFwheOG4n3bgxgJbwTanVZR3DPA'});
            var response = http.get(httpsUri, headers: {
              'Authorization': 'Bearer ${googleCalendarAccesstoken}',
              'Accept': 'application/json'
            });
            print("まじまじまじまじ");
            print(response);
          },
        ); //このitemの中身がない時とそもそものエラーの時とかの違いどうしよ...
// エラーの時はデータが無いので、何もせずリターン
      } catch (e) {
        print("${i}個目、予定データなし $e");
        //return;
      }
    }
  }

  /// ステップ⑤ サインアウト処理
  Future<void> signOutFromGoogleO() async {
// サインインせずこのボタンを押した場合を想定し、
// ここでもGoogle SignIn認証のためのインスタンスを作成する
    googleSignInO = signInO.GoogleSignIn(scopes: [
      //calendarO.CalendarApi.calendarScope,
      calendarO.CalendarApi.calendarReadonlyScope
    ]);
    try {
      await googleSignInO.disconnect();
// // 再サインインするときに同意画面を表示させたくない場合は、上記1文を以下に変更
// await googleSignInO.signOut();

      //削除したいけどエラーが出るからとりあえず放置
      // final storage = FlutterSecureStorage();
      // await storage.remove(key: 'GOOGLE_CALENDAR_ACCESSTOKEN');

// // firebase上にサインインしたユーザー情報を記録している場合は以下を追加
// // ※firebase_auth、firebase_coreのインポートが必要
      await FirebaseAuth.instance.signOut(); //なんかうまくサインアウトできてない気がする。。。
// サインアウト表示に変更し、再描画
      print("サインアウト中");
    } catch (e) {
      print("サインアウトエラー $e");
// サインイン中か否か判定して、それに応じた表示に変更
      final isSignedInO = await googleSignInO.isSignedIn();
      isSignedInO ? print("サインイン中") : print("サインアウト中");
      return;
    }
  }
}
