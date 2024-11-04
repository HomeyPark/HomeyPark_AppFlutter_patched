import 'package:flutter/material.dart';
import 'config/themes/themes.dart';
import 'config/util/util.dart';
import 'screens/screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    // final brightness = View.of(context).platformDispatcher.platformBrightness;
    final textTheme = createTextTheme(context, "Rubik", "Rubik");
    final theme = MaterialTheme(textTheme);

    return MaterialApp(
      title: 'Flutter Demo',
      theme: theme.light(),
      home: const HomeScreen(),
    );
  }
}
