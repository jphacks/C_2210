import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'main.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:intl/intl.dart';
import 'package:flutter_picker/flutter_picker.dart';
import 'package:flutter/cupertino.dart';

class EditPage extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // 予定もproviderで管理できるようにする
    final DateTime scheduleTime = DateTime(2022, 10, 16, 8, 45);

    // providerから値を受け取る
    final int preparationTime = ref.watch(preparationTimeProvider);
    final int travelTime = ref.watch(travelTimeProvider);
    final String scheduledDestination = ref.watch(scheduledDestinationProvider);
    int selectedMusic = ref.watch(selectedMusicProvider);
    final bool isSnoozeOn = ref.watch(isSnoozeOnProvider);

    final DateTime preparationDateTime = DateTime(0, 0, 0, 0, preparationTime);
    final DateTime travelDateTime = DateTime(0, 0, 0, 0, travelTime);

    List<String> musics = ['未選択', 'Hello World!', 'ウタカタララバイ', 'オドループ', '天国と地獄'];

    // DateTime型を変換
    String getTime(dateTime) {
      return DateFormat.Hm().format(dateTime).toString();
    }

    // 出発時間などを計算、これも状態管理できるようにする。
    final DateTime departureTime = scheduleTime.subtract(
        Duration(hours: travelDateTime.hour, minutes: travelDateTime.minute));
    final DateTime wakeUpDateTime = departureTime.subtract(Duration(
        hours: preparationDateTime.hour, minutes: preparationDateTime.minute));

    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text('アラームを編集', style: TextStyle(fontSize: 16, color: Colors.black),),
        iconTheme: const IconThemeData(color: Colors.black),
        backgroundColor: Colors.transparent,
        elevation: 0.0,
        leadingWidth: 100,
        leading: TextButton(
          child: Text('キャンセル', style: TextStyle(fontSize: 16, color: Color(0xFFFF9900))),
          onPressed: () {Navigator.pop(context);}),
        actions: [TextButton(
          child: Text('保存', style: TextStyle(fontSize: 16, color: Color(0xFFFF9900))),
          onPressed: () {Navigator.pop(context);}
        )],
      ),
        body: Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            height: MediaQuery.of(context).size.height * 0.1,
            width: MediaQuery.of(context).size.width * 0.6,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('起床', style: TextStyle(fontSize: 24),),
                Text(getTime(wakeUpDateTime), style: TextStyle(fontSize: 32))],
            ),
          ),
          Container(
            height: MediaQuery.of(context).size.height * 0.1,
            width: MediaQuery.of(context).size.width * 0.6,
            color: Color(0xFFF4F4F4),
              child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('支度', style: TextStyle(fontSize: 20)),
              TextButton(
                child: Container(
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            Text(preparationDateTime.hour.toString(), style: TextStyle(fontSize: 32, color: Color(0xFFFF9900))),
                            Text('h', style: TextStyle(fontSize: 24, color: Color(0xFF000000))),
                            SizedBox(width: 20,),
                            Text(preparationDateTime.minute.toString(), style: TextStyle(fontSize: 32, color: Color(0xFFFF9900))),
                            Text('m', style: TextStyle(fontSize: 24, color: Color(0xFF000000)))
                          ]),
                      ),
                onPressed: () async {
                  Picker(
                      adapter: DateTimePickerAdapter(
                          type: PickerDateTimeType.kHM,
                          value: preparationDateTime),
                      title: Text('支度時間を編集'),
                      onConfirm: (Picker picker, List value) {
                        ref
                            .read(preparationTimeProvider.notifier)
                            .update((state) {
                          state = value[0] * 60 + value[1];
                          return state;
                        });
                      }).showModal(context);
                },
              ),
            ],
          )),
          Container(
            height: MediaQuery.of(context).size.height * 0.1,
            width: MediaQuery.of(context).size.width * 0.6,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [Text('出発', style: TextStyle(fontSize: 20)), Text(getTime(departureTime), style: TextStyle(fontSize: 32))],
            ),
          ),
          Container(
            height: MediaQuery.of(context).size.height * 0.1,
            width: MediaQuery.of(context).size.width * 0.6,
            color: Color(0xFFF4F4F4),
            child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
              Text('移動', style: TextStyle(fontSize: 20)),
              TextButton(
                child: Container(
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            Text(travelDateTime.hour.toString(), style: TextStyle(fontSize: 32, color: Color(0xFFFF9900))),
                            Text('h', style: TextStyle(fontSize: 24, color: Color(0xFF000000))),
                            SizedBox(width: 20,),
                            Text(travelDateTime.minute.toString(), style: TextStyle(fontSize: 32, color: Color(0xFFFF9900))),
                            Text('m', style: TextStyle(fontSize: 24, color: Color(0xFF000000)))
                          ]),
                      ),
                onPressed: () async {
                  Picker(
                      adapter: DateTimePickerAdapter(
                          type: PickerDateTimeType.kHM, value: travelDateTime),
                      title: Text('移動時間を編集'),
                      onConfirm: (Picker picker, List value) {
                        ref.read(travelTimeProvider.notifier).update((state) {
                          state = value[0] * 60 + value[1];
                          return state;
                        });
                      }).showModal(context);
                },
              ),
            ]),
          ),
          Container(
            height: MediaQuery.of(context).size.height * 0.1,
            width: MediaQuery.of(context).size.width * 0.6,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [Text('到着', style: TextStyle(fontSize: 24)), Text(getTime(scheduleTime), style: TextStyle(fontSize: 32))],
            ),
          ),
          Container(
            height: MediaQuery.of(context).size.height * 0.1,
            width: MediaQuery.of(context).size.width * 0.6,
            margin: EdgeInsets.only(bottom: 48),
            color: Color(0xFFF4F4F4),
            child: Row(
              children: [
                Container(child: Row(children: [
                  Icon(Icons.place),
                  Text('場所'),
                  ]),
                ),
                SizedBox(width: 20),
                Flexible(child: Text(scheduledDestination))
              ]),
          ),
          Divider(
            color: Color(0xFFD9D9D9),
            indent: 50,
            endIndent: 50,
            thickness: 2,
          ),
          Container(
            height: MediaQuery.of(context).size.height * 0.05,
            width: MediaQuery.of(context).size.width * 0.6,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('アラーム音'),
                TextButton(
                  child: Text(musics[selectedMusic] + ' >', style: TextStyle(color: Color(0xFFFF9900)),),
                  onPressed: () {
                    showModalBottomSheet(
                      context: context,
                      builder: (context) {
                        return Container(
                          child: ListView(
                            children: [
                              RadioListTile(
                                value: 1,
                                groupValue: selectedMusic,
                                title: Text(musics[1]),
                                onChanged: (int? value) {
                                  ref.read(selectedMusicProvider.notifier).update((state) {
                                    state = value!;
                                    return state;
                                  });
                                },
                              ),
                              RadioListTile(
                                value: 2,
                                groupValue: selectedMusic,
                                title: Text(musics[2]),
                                onChanged: (int? value) {
                                  ref.read(selectedMusicProvider.notifier).update((state) {
                                    state = value!;
                                    return state;
                                  });
                                },
                              ),
                              RadioListTile(
                                value: 3,
                                groupValue: selectedMusic,
                                title: Text(musics[3]),
                                onChanged: (int? value) {
                                  ref.read(selectedMusicProvider.notifier).update((state) {
                                    state = value!;
                                    return state;
                                  });
                                },
                              ),
                              RadioListTile(
                                value: 4,
                                groupValue: selectedMusic,
                                title: Text(musics[4]),
                                onChanged: (int? value) {
                                  ref.read(selectedMusicProvider.notifier).update((state) {
                                    state = value!;
                                    return state;
                                  });
                                },
                              ),
                            ],
                          ),
                        );
                      }
                    );
                  },
                )
              ],
            ),
          ),
          Divider(
            color: Color(0xFFD9D9D9),
            indent: 50,
            endIndent: 50,
            thickness: 2,
          ),
          Container(
            height: MediaQuery.of(context).size.height * 0.05,
            width: MediaQuery.of(context).size.width * 0.6,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('スヌーズ'),
                CupertinoSwitch(
                  activeColor: Color(0xFFFF9900),
                  value: isSnoozeOn,
                  onChanged: (value) {
                    ref.read(isSnoozeOnProvider.notifier).update((state) {
                      state = value;
                      return state;
                    });
                  },
                )
              ],
            ),
          ),
          Divider(
            color: Color(0xFFD9D9D9),
            indent: 50,
            endIndent: 50,
            thickness: 2,
          ),
        ],
      ),
    ));
  }
}