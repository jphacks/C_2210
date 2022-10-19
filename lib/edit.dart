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
    final String selectedMusic = ref.watch(selectedMusicProvider);
    final bool isSnoozeOn = ref.watch(isSnoozeOnProvider);

    final DateTime preparationDateTime = DateTime(0, 0, 0, 0, preparationTime);
    final DateTime travelDateTime = DateTime(0, 0, 0, 0, travelTime);

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
        title: Text('アラームを編集', style: TextStyle(color: Colors.black),),
        iconTheme: const IconThemeData(color: Colors.black),
        backgroundColor: Colors.transparent,
        elevation: 0.0,
      ),
        body: Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [Text('起床'), Text(getTime(wakeUpDateTime))],
            ),
          ),
          Container(
              child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text('支度時間'),
              TextButton(
                child: Text(getTime(preparationDateTime)),
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
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [Text('出発'), Text(getTime(departureTime))],
            ),
          ),
          Container(
            child: Row(mainAxisAlignment: MainAxisAlignment.center, children: [
              Text('移動時間'),
              TextButton(
                child: Text(getTime(travelDateTime)),
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
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [Text('到着'), Text(getTime(scheduleTime))],
            ),
          ),
          Container(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text('アラーム音'),
                TextButton(
                  child: Text(selectedMusic + ' >'),
                  onPressed: () {
                    showModalBottomSheet(
                      context: context,
                      builder: (context) {
                        return Container();
                      }
                    );
                  },
                )
              ],
            ),
          ),
          Container(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text('スヌーズ'),
                CupertinoSwitch(
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
        ],
      ),
    ));
  }
}
