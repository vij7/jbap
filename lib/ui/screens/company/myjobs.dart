import 'package:flutter/material.dart';
import 'package:jobapp/constants.dart';
import 'package:jobapp/models/bottomsheet.dart';
import 'package:jobapp/models/login_class.dart';
import 'package:jobapp/models/login_company_class.dart';
import 'package:jobapp/ui/screens/company/jobpost.dart';
import 'package:jobapp/ui/screens/company/viewlist.dart';
import 'package:jobapp/ui/screens/home.dart';

import 'package:jobapp/ui/widgets/mybottomnavbar.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MyJob extends StatefulWidget {
  @override
  _MyJobState createState() => _MyJobState();
  final User userinfo;
  final Company companyinfo;
  MyJob({Key key, @required this.userinfo, @required this.companyinfo})
      : super(key: key);
}

class _MyJobState extends State<MyJob> with SingleTickerProviderStateMixin {
  TabController _tabController;
  bool _isPremium = false;
  void initState() {
    super.initState();
    _tabController = TabController(vsync: this, length: 2);
    _fetchLogindata();
  }

  changeMyTab() {
    setState(() {
      _tabController.index = 1;
    });
  }

  _fetchLogindata() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
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

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: _onBackPressed,
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: _isPremium ? kPremiumColor : kSecondaryColor,
          automaticallyImplyLeading: false,
          leading: new Icon(Icons.mail),
          title: new Text('My Jobs'),
          bottom: TabBar(
            controller: _tabController,
            tabs: [
              Tab(icon: Icon(Icons.edit)),
              Tab(icon: Icon(Icons.view_list))
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
                        children: [
                          JobPost(
                            userinfo: widget.userinfo,
                            companyinfo: widget.companyinfo,
                            onTabChangeCallback: () => {changeMyTab()},
                          ),
                          ViewListPage(
                            userinfo: widget.userinfo,
                            companyinfo: widget.companyinfo,
                          )
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
                active: 3,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
