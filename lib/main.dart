import 'package:client_holder/screens/home_page_screen.dart';
import 'package:client_holder/screens/login_screen.dart';
import 'package:client_holder/screens/signup_screen.dart';
import 'package:client_holder/utils/colors.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding
      .ensureInitialized(); // used to enseure that our widgits are intialized before flutter makes connection to firebase
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'CRUD Operations and Email Authentication',
      theme: ThemeData(useMaterial3: true),
      home: LoginScreen(),
    );
  }
}
