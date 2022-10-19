import 'package:flutter/material.dart';
/* import 'package:google_place/google_place.dart';
import 'package:flutter_google_places/flutter_google_places.dart';
import 'package:google_maps_flutter_android/google_maps_flutter_android.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart'; */
import 'main.dart';

class SettingPage extends StatefulWidget {
  @override
  _SettingPageState createState() => _SettingPageState();
}

class _SettingPageState extends State<SettingPage> {
  List<Map> PlaceList = [];
  var NewPlaceName = '';
  var NewPlaceTime = 0;
  @override
  Widget build(BuildContext context) {
    return Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: FractionalOffset.topCenter,
            end: FractionalOffset.bottomCenter,
            colors: [
              const Color(0xffffffff),
              const Color(0xfffff2df),
            ],
            stops: const [
              0.0,
              1.0,
            ],
          ),
        ),
        child: Scaffold(
          backgroundColor: Colors.transparent,
          appBar: AppBar(
            elevation: 0,
            backgroundColor: Colors.transparent,
            automaticallyImplyLeading: false,
            centerTitle: true,
            leading: OverflowBox(
              maxWidth: 75,
              child: TextButton(
                onPressed: () {
                  // ボタンが押されたときに発動される処理
                  Navigator.pop(context);
                },
                child: Text('< 戻る',
                    style: TextStyle(color: Color(0xffff9900), fontSize: 16)),
              ),
            ),
            title: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.settings, color: Colors.grey),
                Text('設定', style: TextStyle(color: Colors.black, fontSize: 24))
              ],
            ),
            actions: [
              TextButton(
                onPressed: () {
                  // ボタンが押されたときに発動される処理
                  Navigator.pop(context);
                },
                child: Text('確定',
                    style: TextStyle(
                        color: Color(0xffff9900),
                        fontSize: 16,
                        fontWeight: FontWeight.bold)),
              ),
            ],
          ),
          body: Container(
              padding: EdgeInsets.symmetric(horizontal: 50, vertical: 50),
              child: Column(
                children: [
                  Container(
                    child: Column(
                      children: [
                        Text('デフォルトの支度時間'),
                      ],
                    ),
                  ),
                  Container(
                    child: Column(
                      children: [
                        Text('デフォルトの移動時間'),
                      ],
                    ),
                  ),
                  Container(
                    child: Column(
                      children: [
                        Text('通知'),
                      ],
                    ),
                  ),
                  Expanded(
                    child: Column(
                      children: [
                        Text('よく行く場所'),
                        Expanded(
                          child: ListView.builder(
                            itemCount: PlaceList.length,
                            itemBuilder: (context, index) {
                              return Text('a');
                            },
                          ),
                        ),
                        ElevatedButton.icon(
                          icon: const Icon(
                            Icons.add,
                            color: Colors.white,
                          ),
                          label: const Text('追加'),
                          onPressed: () {
                            if (/* NewPlaceName != "" && NewPlaceTime != "" */ true) {
                              try {
                                setState(() {
                                  // メンバーの追加
                                  PlaceList.add({
                                    'name': NewPlaceName, // 名前
                                  });
                                  // 新しいメンバーの値を初期化
                                  NewPlaceName = "";
                                });
                                // テキストフィールドの入力を削除
                                //_memberNameController.clear();
                                //_memberPaymentController.clear();
                              } catch (e) {
                                setState(() {
                                  //例外が発生したら実行する処理
                                  //FormExceptionText = "金額は数字で入力してください";
                                });
                              }
                            }
                          },
                        ),
                      ],
                    ),
                  )
                ],
              )),
        ));
  }
}

/* class _SettingPageState extends State<SettingPage> {
  late GooglePlace googlePlace;
  List<AutocompletePrediction> predictions = [];
  List<Map> placeList = [];
  var place = '';

  @override
  void initState() {
    googlePlace = GooglePlace(
        'AIzaSyBnKnBwKdnq1D2FtAZSn2dZnyd9nxe00qY'); // ⬅︎GoogleMapと同じAPIキーを指定。
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
              width: MediaQuery.of(context).size.width * 0.8,
              alignment: Alignment.centerLeft,
              child: TextFormField(
                onChanged: (value) {
                  if (value.isNotEmpty) {
                    autoCompleteSearch(value); // 入力される毎に引数にその入力文字を渡し、関数を実行
                  } else {
                    if (predictions.length > 0 && mounted) {
                      // ここで配列を初期化。初期化しないと文字が入力されるたびに検索結果が蓄積されてしまう。
                      setState(() {
                        predictions = [];
                      });
                    }
                  }
                },
                decoration: InputDecoration(
                  hintText: '場所を検索',
                  hintStyle:
                      TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
                  border: InputBorder.none,
                ),
              )),
          Flexible(
            child: ListView.builder(
              shrinkWrap: true,
              itemCount: predictions.length, // 検索結果を格納したpredictions配列の長さを指定
              itemBuilder: (context, index) {
                return Card(
                  child: ListTile(
                    title: Text(predictions[index]
                        .description
                        .toString()), // 検索結果を表示。descriptionを指定すると場所名が表示されます。
                    onTap: () async {
                      setState(() {
                        place = predictions[index].description.toString();
                      });
                    },
                  ),
                );
              },
            ),
          ),
          Text('${place}'),
          Text('設定ページです'),
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

  void autoCompleteSearch(String value) async {
    final result = await googlePlace.autocomplete.get(value, language: 'ja');
    if (result != null && result.predictions != null && mounted) {
      setState(() {
        predictions = result.predictions!;
      });
    }
  }
}
 */
