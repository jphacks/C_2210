import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:intl/intl.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'toppage.dart';
import 'login.dart';
import 'notify.dart';

final preparationTimeProvider = StateProvider((ref) {
  return 90;
});

final travelTimeProvider = StateProvider((ref) {
  return 30;
});

final selectedMusicProvider  = StateProvider((ref) {
  return 1;
});

final isSnoozeOnProvider = StateProvider((ref) {
  return false;
});

final scheduledDestinationProvider = StateProvider((ref) {
  return '〒464-8601 愛知県名古屋市千種区不老町';
});

class Music {
  const Music({required this.id, required this.name, required this.selected});
  final int id;
  final String name;
  final bool selected;

  Music copyWith({int? id, String? name, bool? selected}) {
    return Music(
      id:  id ?? this.id,
      name: name ?? this.name,
      selected: selected ?? this.selected
    );
  }
}


void main() async {
  await setup();
  runApp(ProviderScope(
    child: MaterialApp(
      title: 'timer',
      home: MyApp(),
    ),
  ));
  initializeDateFormatting('ja');
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(title: 'Welcome to Flutter', home: LoginPage());
  }
}
