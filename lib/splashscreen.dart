import 'dart:async';

import 'package:flutter/material.dart';
import 'package:jobapp/constants.dart';
import 'package:jobapp/ui/screens/Welcome/welcome_screen.dart';
import 'package:jobapp/ui/screens/home.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'models/bottomsheet.dart';

class SplashScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _SplashScreenState();
  }
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    startTimer();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: new InkWell(
        child: new Stack(
          fit: StackFit.expand,
          children: <Widget>[
            new Container(
              decoration: new BoxDecoration(
                color: Colors.white,
              ),
            ),
            new Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                new Expanded(
                  flex: 2,
                  child: new Container(
                      child: new Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      new CircleAvatar(
                        backgroundColor: Colors.transparent,
                        child: new Container(
                            child: Image.asset('assets/logo.png')),
                        radius: 150.0,
                      ),
                      // new Padding(
                      //   padding: const EdgeInsets.only(top: 10.0),
                      // ),
                      // const Text(splashTitle,
                      //     style: TextStyle(
                      //         fontWeight: FontWeight.normal,
                      //         fontSize: 30.0,
                      //         color: Colors.white)),
                    ],
                  )),
                ),
                Expanded(
                  flex: 1,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      CircularProgressIndicator(
                        valueColor:
                            new AlwaysStoppedAnimation<Color>(Colors.blue[900]),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 20.0),
                      ),
                      new Text(loaderTitle,
                          style: new TextStyle(
                              fontStyle: FontStyle.normal,
                              color: Colors.blue[900])),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  void startTimer() {
    Timer(Duration(seconds: 3), () {
      navigateUser(); //It will redirect  after 3 seconds
    });
  }

  void navigateUser() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var status = prefs.getBool('isLoggedIn') ?? false;
    var isJobseeker = prefs.getBool('isJobseeker') ?? false;
    print(status);
    print(isJobseeker);
    if (status) {
      if (isJobseeker == true) {
        Navigator.pushReplacement(
            context,
            MaterialPageRoute(
                builder: (BuildContext context) =>
                    ChangeNotifierProvider<MyBottomSheetModel>(
                        create: (_) => MyBottomSheetModel(),
                        builder: (context, child) => HomeScreen())));
      } else if (isJobseeker == false) {
        Navigator.pushReplacement(
            context,
            MaterialPageRoute(
                builder: (BuildContext context) =>
                    ChangeNotifierProvider<MyBottomSheetModel>(
                        create: (_) => MyBottomSheetModel(),
                        builder: (context, child) => HomeScreen())));
      }
    } else {
      Navigator.pushReplacement(
          context,
          MaterialPageRoute(
              builder: (BuildContext context) => WelcomeScreen()));
    }
  }
}
