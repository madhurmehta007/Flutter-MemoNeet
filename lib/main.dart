import 'dart:io';

import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_memoneet/view/HomeScreen.dart';
import 'package:flutter_memoneet/view/LoginScreen.dart';
import 'package:flutter_memoneet/view/SignUpScreen.dart';
import 'package:flutter_memoneet/view/SplashScreen.dart';
import 'package:flutter_memoneet/viewmodel/AuthViewModel.dart';
import 'package:flutter_memoneet/viewmodel/DataViewModel.dart';
import 'package:provider/provider.dart';

Future main() async {
  WidgetsFlutterBinding.ensureInitialized();

  Platform.isAndroid
      ? await Firebase.initializeApp(
      options: const FirebaseOptions(
          apiKey: "AIzaSyB0pSx_kKa3GPxZljTeWGlmFvwaELy9HiY",
          appId: "1:753139647242:android:84672f5c2c89de677c30f3",
          messagingSenderId: "753139647242",
          projectId: "flutter-memoneet"))
      : Firebase.initializeApp();
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AuthViewModel()),
        ChangeNotifierProvider(create: (_) => DataViewModel()),
      ],
      child: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Memo Neet',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: FutureBuilder(
        future:
        Provider.of<AuthViewModel>(context, listen: true).checkLoggedIn(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return SplashScreen();
          } else {
            if (snapshot.hasData && snapshot.data == true) {
              return HomeScreen();
            } else {
              return LoginScreen();
            }
          }
        },
      ),
      routes: {
        '/login': (context) => LoginScreen(),
        '/signup': (context) => SignUpScreen(),
        '/home': (context) => HomeScreen(),
      },
    );
  }
}
