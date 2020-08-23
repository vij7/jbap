import 'package:flutter/material.dart';
import 'package:jobapp/constants.dart';
import 'package:jobapp/models/bottomsheet.dart';
import 'package:jobapp/models/login_class.dart';
import 'package:jobapp/models/login_company_class.dart';
import 'package:jobapp/ui/screens/company/companyinfo.dart';
import 'package:jobapp/ui/screens/company/personalinfo.dart';
import 'package:jobapp/ui/screens/home.dart';

import 'package:jobapp/ui/screens/jobseeker/contactdetails.dart';
import 'package:jobapp/ui/screens/jobseeker/personaldetails.dart';
import 'package:jobapp/ui/screens/jobseeker/workdetails.dart';
import 'package:jobapp/ui/widgets/mybottomnavbar.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
// import 'package:jobapp/ui/widgets/mybottomnavbar.dart';

class Profile extends StatefulWidget {
  @override
  _ProfileState createState() => _ProfileState();
  final User userinfo;
  final Company companyinfo;
  Profile({Key key, @required this.userinfo, @required this.companyinfo})
      : super(key: key);
}

class _ProfileState extends State<Profile> {
  bool _isJobseeker;
  bool _isPremium = false;
  int _tabIndex = 0;

  TabController _tabController;

  void initState() {
    super.initState();
    _fetchLogindata();
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

  Future<bool> _onBackPressed() {
    return Navigator.of(context).pushReplacement(MaterialPageRoute(
        builder: (BuildContext context) =>
            ChangeNotifierProvider<MyBottomSheetModel>(
                create: (_) => MyBottomSheetModel(),
                builder: (context, child) => HomeScreen())));
  }

  // ignore: unused_element
  void _toggleTab() {
    _tabIndex = _tabController.index + 1;
    _tabController.animateTo(_tabIndex);
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: _onBackPressed,
      child: DefaultTabController(
        length: _isJobseeker ? 3 : 2,
        child: Scaffold(
          appBar: AppBar(
            backgroundColor: _isJobseeker
                ? kPrimaryColor
                : _isPremium ? kPremiumColor : kSecondaryColor,
            automaticallyImplyLeading: false,
            leading: new Icon(Icons.person_pin),
            title: new Text('Profile'),
            bottom: TabBar(
              controller: _tabController,
              tabs: _isJobseeker
                  ? [
                      Tab(icon: Icon(Icons.person)),
                      Tab(icon: Icon(Icons.work)),
                      Tab(icon: Icon(Icons.contacts))
                    ]
                  : [
                      Tab(icon: Icon(Icons.home)),
                      Tab(icon: Icon(Icons.person))
                    ],
            ),
          ),
          body: Stack(
            children: <Widget>[
              Positioned(
                top: 0,
                right: 0,
                left: 0,
                bottom: 50,
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 15.0),
                  child: Column(
                    children: <Widget>[
                      SizedBox(
                        height: 11,
                      ),
                      Expanded(
                        child: TabBarView(
                          controller: _tabController,
                          children: _isJobseeker
                              ? [
                                  PersonalDetails(userlist: widget.userinfo),
                                  WorkDetails(userlist: widget.userinfo),
                                  ContactDetails(userlist: widget.userinfo)
                                ]
                              : [
                                  CompanyInfo(userlist: widget.companyinfo),
                                  PersonalInfo(userlist: widget.companyinfo)
                                ],
                        ),
                      )
                    ],
                  ),
                ),
              ),
              Positioned(
                bottom: 0,
                left: 0,
                right: 0,
                height: 60,
                child: MyBottomNavBar(
                  userinfo: widget.userinfo,
                  companyinfo: widget.companyinfo,
                  active: 1,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
