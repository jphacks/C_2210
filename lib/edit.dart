import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'main.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:intl/intl.dart';
import 'package:flutter_picker/flutter_picker.dart';

class EditPage extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final preparationTime = ref.watch(preparationTimeProvider);
    final preparationDateTime = DateTime(0, 0, 0, 0, preparationTime);
    final travelTime = ref.watch(travelTimeProvider);
    final travelDateTime = DateTime(0, 0, 0, 0, travelTime);
    String getTime(dateTime) {
      return DateFormat.Hm().format(dateTime).toString();
    }

    return Scaffold(
        body: Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text('支度時間'),
          TextButton(
            child: Text(getTime(preparationDateTime)),
            onPressed: () async {
              Picker(
                  adapter: DateTimePickerAdapter(
                      type: PickerDateTimeType.kHM, value: preparationDateTime),
                  title: Text('支度時間を編集'),
                  onConfirm: (Picker picker, List value) {
                    ref.read(preparationTimeProvider.notifier).update((state) {
                      state = value[0] * 60 + value[1];
                      return state;
                    });
                  }).showModal(context);
            },
          ),
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
