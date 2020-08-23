import 'package:flutter/material.dart';
import 'package:jobapp/models/login_company_class.dart';
import 'package:jobapp/ui/screens/company/premiuminfo.dart';
import 'package:shared_preferences/shared_preferences.dart';

class CompanyInfo extends StatefulWidget {
  @override
  _CompanyInfoState createState() => _CompanyInfoState();
  final Company userlist;
  CompanyInfo({Key key, @required this.userlist}) : super(key: key);
}

class _CompanyInfoState extends State<CompanyInfo>
    with AutomaticKeepAliveClientMixin<CompanyInfo> {
  TextEditingController _controllerCompanyname;
  TextEditingController _controllerAbout;
  TextEditingController _controllerEmail;
  TextEditingController _controllerMobile;
  bool _isPremium = false;

  @override
  void initState() {
    super.initState();
    _fetchLogindata();
    _controllerCompanyname =
        TextEditingController(text: widget.userlist.companyname);
    _controllerAbout = TextEditingController(text: widget.userlist.about);
    _controllerEmail = TextEditingController(text: widget.userlist.email);
    _controllerMobile = TextEditingController(text: widget.userlist.phone);
    _savePageData();
  }

  _fetchLogindata() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      if (prefs.getString('isPremium') == "1") {
        _isPremium = true;
      }
    });
  }

  _savePageData() async {
    var prefs = await SharedPreferences.getInstance();

    prefs.setString('companyname', _controllerCompanyname.text);
    prefs.setString('about', _controllerAbout.text);
    prefs.setString('email', _controllerEmail.text);
    prefs.setString('mobile', _controllerMobile.text);
  }

  save(String key, dynamic value) async {
    final SharedPreferences sharedPrefs = await SharedPreferences.getInstance();
    if (value is bool) {
      sharedPrefs.setBool(key, value);
    } else if (value is String) {
      sharedPrefs.setString(key, value);
    } else if (value is int) {
      sharedPrefs.setInt(key, value);
    } else if (value is double) {
      sharedPrefs.setDouble(key, value);
    } else if (value is List<String>) {
      sharedPrefs.setStringList(key, value);
    }
  }

  @override
  // ignore: must_call_super
  Widget build(BuildContext context) {
    return Container(
      child: Padding(
        padding: EdgeInsets.only(bottom: 5.0),
        child: SingleChildScrollView(
          child: new Form(
            child: new Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                Padding(
                    padding:
                        EdgeInsets.only(left: 25.0, right: 25.0, top: 25.0),
                    child: new Row(
                      mainAxisSize: MainAxisSize.max,
                      children: <Widget>[
                        new Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          mainAxisSize: MainAxisSize.min,
                          children: <Widget>[
                            new Text(
                              'Company Name',
                              style: TextStyle(
                                  fontSize: 16.0, fontWeight: FontWeight.bold),
                            ),
                          ],
                        ),
                      ],
                    )),
                Padding(
                    padding: EdgeInsets.only(left: 25.0, right: 25.0, top: 2.0),
                    child: new Row(
                      mainAxisSize: MainAxisSize.max,
                      children: <Widget>[
                        new Flexible(
                          child: new TextFormField(
                            decoration: const InputDecoration(
                              hintText: "Company Name",
                            ),
                            controller: _controllerCompanyname,
                            onChanged: (String value) {
                              save('companyname', value);
                            },
                          ),
                        ),
                      ],
                    )),
                Padding(
                    padding:
                        EdgeInsets.only(left: 25.0, right: 25.0, top: 25.0),
                    child: new Row(
                      mainAxisSize: MainAxisSize.max,
                      children: <Widget>[
                        new Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          mainAxisSize: MainAxisSize.min,
                          children: <Widget>[
                            new Text(
                              'About Company',
                              style: TextStyle(
                                  fontSize: 16.0, fontWeight: FontWeight.bold),
                            ),
                          ],
                        ),
                      ],
                    )),
                Padding(
                    padding: EdgeInsets.only(left: 25.0, right: 25.0, top: 2.0),
                    child: new Row(
                      mainAxisSize: MainAxisSize.max,
                      children: <Widget>[
                        new Flexible(
                          child: new TextFormField(
                            maxLines: 4,
                            decoration: const InputDecoration(
                              hintText: "About Company",
                            ),
                            controller: _controllerAbout,
                            onChanged: (String value) {
                              save('about', value);
                            },
                          ),
                        ),
                      ],
                    )),
                Padding(
                    padding:
                        EdgeInsets.only(left: 25.0, right: 25.0, top: 25.0),
                    child: new Row(
                      mainAxisSize: MainAxisSize.max,
                      children: <Widget>[
                        new Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          mainAxisSize: MainAxisSize.min,
                          children: <Widget>[
                            new Text(
                              'Email ID',
                              style: TextStyle(
                                  fontSize: 16.0, fontWeight: FontWeight.bold),
                            ),
                          ],
                        ),
                      ],
                    )),
                Padding(
                    padding: EdgeInsets.only(left: 25.0, right: 25.0, top: 2.0),
                    child: new Row(
                      mainAxisSize: MainAxisSize.max,
                      children: <Widget>[
                        new Flexible(
                          child: new TextFormField(
                            readOnly: true,
                            enabled: false,
                            decoration: const InputDecoration(
                                hintText: "Enter Email ID"),
                            controller: _controllerEmail,
                            onChanged: (String value) {
                              save('email', value);
                            },
                          ),
                        ),
                      ],
                    )),
                Padding(
                    padding:
                        EdgeInsets.only(left: 25.0, right: 25.0, top: 25.0),
                    child: new Row(
                      mainAxisSize: MainAxisSize.max,
                      children: <Widget>[
                        new Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          mainAxisSize: MainAxisSize.min,
                          children: <Widget>[
                            new Text(
                              'Contact Number',
                              style: TextStyle(
                                  fontSize: 16.0, fontWeight: FontWeight.bold),
                            ),
                          ],
                        ),
                      ],
                    )),
                Padding(
                    padding: EdgeInsets.only(left: 25.0, right: 25.0, top: 2.0),
                    child: new Row(
                      mainAxisSize: MainAxisSize.max,
                      children: <Widget>[
                        new Flexible(
                          child: new TextFormField(
                            decoration: const InputDecoration(
                                hintText: "Enter Contact Number"),
                            controller: _controllerMobile,
                            onChanged: (String value) {
                              save('phone', value);
                            },
                          ),
                        ),
                      ],
                    )),
                Padding(
                    padding:
                        EdgeInsets.only(left: 25.0, right: 15.0, top: 40.0),
                    child: Visibility(
                      visible: _isPremium ? false : true,
                      child: new Row(
                        mainAxisSize: MainAxisSize.max,
                        children: <Widget>[
                          Flexible(
                            child: Padding(
                              padding: EdgeInsets.only(right: 5.0),
                              child: Image.asset("assets/images/gift.gif",
                                  height: 80, width: 80),
                            ),
                            flex: 1,
                          ),
                          Flexible(
                            child: Padding(
                                padding: EdgeInsets.only(right: 0.0),
                                child: GestureDetector(
                                  onTap: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) {
                                          return CompanyPremium();
                                        },
                                      ),
                                    );
                                  },
                                  child: Text("Become a Premium Member",
                                      style: TextStyle(
                                        color: Colors.black,
                                        fontSize: 16.0,
                                        fontWeight: FontWeight.bold,
                                      )),
                                )),
                            flex: 4,
                          ),
                        ],
                      ),
                    )),
              ],
            ),
          ),
        ),
      ),
    );
  }

  @override
  bool get wantKeepAlive => true;
}
