import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:intl/intl.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'toppage.dart';
import 'login.dart';
import 'notify.dart';
import 'package:http/http.dart' as http;

import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';

final preparationTimeProvider = StateProvider((ref) {
  return 90;
});

final travelTimeProvider = StateProvider((ref) {
  return 30;
});

final selectedMusicProvider = StateProvider((ref) {
  return 1;
});

final isSnoozeOnProvider = StateProvider((ref) {
  return false;
});

final scheduledDestinationProvider = StateProvider((ref) {
  return '〒464-8601 愛知県名古屋市千種区不老町';
});

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  await setup();
  runApp(ProviderScope(
    child: MaterialApp(
      debugShowCheckedModeBanner: false,
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
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Welcome to Flutter',
      home: LoginPage(),
    );
  }
}
