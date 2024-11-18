import 'package:flutter/material.dart';
import 'package:homey_park/config/pref/preferences.dart';
import 'config/themes/themes.dart';
import 'config/util/util.dart';
import 'screens/screen.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

Future main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await preferences.init();
  await dotenv.load(fileName: ".env");
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  late bool _isAuth;
  bool loading = true;

  @override
  void initState() {
    super.initState();
    preferences.getUserId().then((value) {
      setState(() {
        _isAuth = value != null;
        loading = false;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    final textTheme = createTextTheme(context, "Rubik", "Rubik");
    final theme = MaterialTheme(textTheme);

    return MaterialApp(
      title: 'Flutter Demo',
      theme: theme.light(),
      home: loading
          ? const Scaffold(
              body: Center(
                child: CircularProgressIndicator(),
              ),
            )
          : _isAuth
              ? const HomeScreen()
              : const LoginScreen(),
    );
  }
}
