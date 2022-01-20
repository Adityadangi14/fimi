import 'package:fimi/views/logInSignUp/logInSignUp.dart';
import 'package:fimi/views/newUserInfo/newUserInfo.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(ProviderScope(child: MyApp()));
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: 'Fimi',
        theme: ThemeData(canvasColor: Color(0xfffbeff7)),
        home: LogInSignUp());
  }
}
