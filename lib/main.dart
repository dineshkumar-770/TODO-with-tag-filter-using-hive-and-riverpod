import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:hive_demo_todo/model/data_model.dart';
import 'package:hive_demo_todo/view/grid_view_notes.dart';
import 'package:hive_demo_todo/view/notification_screen.dart';
import 'package:hive_demo_todo/view/with_riverpod.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

const String boxName = 'notes_box';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Hive.initFlutter();
  Hive.registerAdapter(DataModelAdapter());
  await Hive.openBox(boxName);
  AwesomeNotifications().initialize(
    null,[
      NotificationChannel(
        groupKey: 'reminder',
        defaultColor: Colors.purple,
        ledColor: Colors.white,
        enableVibration: true,
        enableLights: true,
        playSound: true,
        channelKey: 'instant_notification', channelName: 'Basic Notification', channelDescription: 'Instant trigger notification channel')
    ]
  );
  runApp(const ProviderScope(child: MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.yellow,
      ),
      initialRoute: '/',
      routes: {
        '/': (context) => const WithRiverpod(),
        '/second' :(context) => const NotificationUI(),
        '/third' : (context) => GridViewOfNotes()
      },
    );
  }
}
