import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'main.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:intl/intl.dart';
import 'package:flutter_picker/flutter_picker.dart';

class EditPage extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final int preparationTime = ref.watch(preparationTimeProvider);
    final DateTime preparationDateTime = DateTime(0, 0, 0, 0, preparationTime);
    final int travelTime = ref.watch(travelTimeProvider);
    final DateTime travelDateTime = DateTime(0, 0, 0, 0, travelTime);
    String getTime(dateTime) {
      return DateFormat.Hm().format(dateTime).toString();
    }

    // これはバックから受け取るようにする。状態管理できるようにする。
    final DateTime scheduleTime = DateTime(2022, 10, 16, 8, 45);
    // 出発時間などを計算、これも状態管理できるようにする。
    final DateTime departureTime = scheduleTime.subtract(
        Duration(hours: travelDateTime.hour, minutes: travelDateTime.minute));
    final DateTime wakeUpDateTime = departureTime.subtract(Duration(
        hours: preparationDateTime.hour, minutes: preparationDateTime.minute));

    return Scaffold(
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
