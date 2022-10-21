import 'package:flutter/material.dart';
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

final isAlarmOnProvider = StateProvider((ref) {
  return true;
});

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
