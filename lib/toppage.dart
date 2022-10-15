import 'package:flutter/material.dart';
import 'main.dart';
import 'edit.dart';
import 'setting.dart';

class TopPage extends StatefulWidget {
  @override
  _TopPageState createState() => _TopPageState();
}

class _TopPageState extends State<TopPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text('トップページです'),
          TextButton(
            child: Text('ログイン画面に戻る'),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
          TextButton(
            child: Text('編集ページへ'),
            onPressed: () {
              Navigator.push(
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
