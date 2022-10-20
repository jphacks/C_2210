// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'main.dart';
import 'toppage.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Color.fromARGB(255, 255, 244, 228), // 背景色設定
        body: Container(
          alignment: Alignment.center,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: FractionalOffset.topLeft,
              end: FractionalOffset.bottomRight,
              colors: [
                Color.fromARGB(255, 255, 255, 255).withOpacity(0.6),
                Color.fromARGB(255, 255, 226, 169).withOpacity(0.6),
              ],
              stops: const [
                0.0,
                1.0,
              ],
            ),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Image.asset('logo.png'),
              Container(
                alignment: Alignment.center,
                margin: EdgeInsets.only(top: 30),
                child: Text('alarm',
                    style: TextStyle(
                        fontSize: 36,
                        fontWeight: FontWeight.bold,
                        color: Colors.grey[700])),
              ),
              Container(
                  width: 275,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: FractionalOffset.topLeft,
                      end: FractionalOffset.bottomRight,
                      colors: [
                        Color.fromARGB(255, 255, 143, 45).withOpacity(0.6),
                        Color.fromARGB(255, 255, 119, 0).withOpacity(0.6),
                      ],
                      stops: const [
                        0.0,
                        1.0,
                      ],
                    ),
                    borderRadius: BorderRadius.all(
                      Radius.circular(15),
                    ),
                  ),
                  padding: EdgeInsets.symmetric(vertical: 15, horizontal: 15),
                  margin: EdgeInsets.only(top: 50),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Image(
                        image: AssetImage("google_logo_white.png"),
                        height: 25.0,
                      ),
                      Container(
                        alignment: Alignment.centerLeft,
                        padding:
                            EdgeInsets.symmetric(vertical: 0, horizontal: 30),
                        child: Text('Googleでログイン',
                            style: TextStyle(
                              fontSize: 18,
                              color: Colors.white,
                            )),
                      )
                    ],
                  )),
              Container(
                  padding: EdgeInsets.only(top: 10),
                  width: 275,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        "アカウントを持っていませんか？",
                        style: TextStyle(fontSize: 10, color: Colors.grey[700]),
                      ),
                      Text(
                        '：サインイン',
                        style: TextStyle(fontSize: 10, color: Colors.grey[700]),
                      )
                    ],
                  ))
            ],
          ),
        ));
  }
}
