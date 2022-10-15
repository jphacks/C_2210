import 'package:flutter/material.dart';
import 'main.dart';

class EditPage extends StatefulWidget {
  @override
  _EditPageState createState() => _EditPageState();
}

class _EditPageState extends State<EditPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text('編集ページです'),
          TextButton(
            child: Text('トップに戻る'),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
        ],
      ),
    ));
  }
}
