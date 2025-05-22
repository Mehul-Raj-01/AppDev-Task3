import 'package:flutter/material.dart';
// import 'package:flutter_application_1/search_bar.dart';
import 'homepage/homepage.dart';
import 'package:hive_flutter/hive_flutter.dart';

void main() async {
  await Hive.initFlutter();
  await Hive.openBox('db');
  // await Hive.deleteBoxFromDisk('db');
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      darkTheme: ThemeData.dark(),
      themeMode: ThemeMode.dark,
      debugShowCheckedModeBanner: false,
      home: Homepage(),
      // home: SearchBarC(),
      //  home: Homepage(),
    );
  }
}
