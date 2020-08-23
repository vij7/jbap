import 'package:flutter/material.dart';

import 'package:jobapp/splashscreen.dart';
import 'package:jobapp/constants.dart';
import 'package:jobapp/ui/screens/Welcome/welcome_screen.dart';
import 'package:jobapp/ui/screens/home.dart';
import 'package:provider/provider.dart';

import 'models/bottomsheet.dart';

void main() {
  runApp(new MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primaryColor: kPrimaryColor,
        scaffoldBackgroundColor: Colors.white,
      ),
      initialRoute: '/',
      routes: {
        // When navigating to the "/" route, build the FirstScreen widget.
        '/': (context) => SplashScreen(),
        '/welcome': (context) => WelcomeScreen(),
        // When navigating to the "/second" route, build the SecondScreen widget.
        '/home': (context) => ChangeNotifierProvider<MyBottomSheetModel>(
            create: (_) => MyBottomSheetModel(),
            builder: (context, child) => HomeScreen()),
      },
      // home: new SplashScreen(),
    );
  }
}
