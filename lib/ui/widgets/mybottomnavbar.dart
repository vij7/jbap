import 'package:flutter/material.dart';
import 'package:jobapp/constants.dart';
import 'package:jobapp/models/bottomsheet.dart';
import 'package:jobapp/models/login_class.dart';
import 'package:jobapp/models/login_company_class.dart';
import 'package:jobapp/ui/screens/Welcome/welcome_screen.dart';
import 'package:jobapp/ui/screens/company/myjobs.dart';
import 'package:jobapp/ui/screens/home.dart';
import 'package:jobapp/ui/screens/jobseeker/jobapplied.dart';
import 'package:jobapp/ui/screens/profile.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'mybottomnavitem.dart';

class MyBottomNavBar extends StatefulWidget {
  final User userinfo;
  final Company companyinfo;
  final int active;
  MyBottomNavBar(
      {Key key,
      @required this.userinfo,
      @required this.companyinfo,
      @required this.active})
      : super(key: key);

  @override
  _MyBottomNavBarState createState() => _MyBottomNavBarState();
}

class _MyBottomNavBarState extends State<MyBottomNavBar> {
  int _active = 0;
  bool _isJobseeker = false;
  bool _isPremium = false;

  void initState() {
    super.initState();
    _fetchLogindata();
    _active = widget.active;
  }

  _fetchLogindata() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      _isJobseeker = (prefs.getBool('isJobseeker') ?? false);
      if (prefs.getString('isPremium') == "1") {
        _isPremium = true;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(5.0),
      height: double.infinity,
      width: double.infinity,
      decoration: BoxDecoration(
        color: _isJobseeker
            ? kPrimaryColor
            : _isPremium ? kPremiumColor : kSecondaryColor,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(25),
          topRight: Radius.circular(25),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: <Widget>[
          MyBottomNavItem(
            text: "Search",
            icon: Icons.search,
            id: 0,
            onPressed: () {
              setState(() {
                _active = 0;
              });
              Navigator.of(context).pushReplacement(MaterialPageRoute(
                  builder: (BuildContext context) =>
                      ChangeNotifierProvider<MyBottomSheetModel>(
                          create: (_) => MyBottomSheetModel(),
                          builder: (context, child) => HomeScreen())));
            },
            active: widget.active,
          ),
          MyBottomNavItem(
            text: "Profile",
            icon: Icons.person_pin,
            id: 1,
            onPressed: () {
              setState(() {
                _active = 1;
              });
              Navigator.of(context).pushReplacement(MaterialPageRoute(
                  builder: (context) => Profile(
                        userinfo: widget.userinfo,
                        companyinfo: widget.companyinfo,
                      )));
            },
            active: _active,
          ),
          MyBottomNavItem(
            text: _isJobseeker ? "Applied Jobs" : "My Jobs",
            icon: _isJobseeker ? Icons.work : Icons.mail,
            id: 3,
            onPressed: () {
              if (!_isJobseeker) {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => MyJob(
                              userinfo: widget.userinfo,
                              companyinfo: widget.companyinfo,
                            )));
              } else if (_isJobseeker) {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => JobApplied(
                              userinfo: widget.userinfo,
                              companyinfo: widget.companyinfo,
                            )));
              }
            },
            active: _active,
          ),
          MyBottomNavItem(
            text: "Logout",
            icon: Icons.power_settings_new,
            id: 2,
            onPressed: () async {
              final ConfirmAction action = await _asyncConfirmDialog(context);
              print("Confirm Action $action");
              if (action == ConfirmAction.Accept) {
                logoutUser();
              }
            },
            active: _active,
          ),
        ],
      ),
    );
  }

  Future<void> logoutUser() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs?.clear();
    Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (BuildContext context) => WelcomeScreen()),
        ModalRoute.withName('/home'));
  }
}

enum ConfirmAction { Cancel, Accept }
Future<ConfirmAction> _asyncConfirmDialog(BuildContext context) async {
  return showDialog<ConfirmAction>(
    context: context,
    barrierDismissible: false, // user must tap button for close dialog!
    builder: (BuildContext context) {
      return AlertDialog(
        title: Text('Confirmation'),
        content: const Text('Do you really want to logout?'),
        actions: <Widget>[
          FlatButton(
            child: const Text('No'),
            onPressed: () {
              Navigator.of(context).pop(ConfirmAction.Cancel);
            },
          ),
          FlatButton(
            child: const Text('Yes'),
            onPressed: () {
              Navigator.of(context).pop(ConfirmAction.Accept);
            },
          )
        ],
      );
    },
  );
}
