import 'package:flutter/material.dart';
import 'package:jobapp/models/login_class.dart';
import 'package:jobapp/ui/screens/jobseeker/premiuminfo.dart';
import 'package:jobapp/ui/widgets/mydropdownbutton.dart';
import 'package:shared_preferences/shared_preferences.dart';

class PersonalDetails extends StatefulWidget {
  @override
  _PersonalDetailsState createState() => _PersonalDetailsState();
  final User userlist;
  PersonalDetails({Key key, @required this.userlist}) : super(key: key);
}

class _PersonalDetailsState extends State<PersonalDetails>
    with AutomaticKeepAliveClientMixin<PersonalDetails> {
  String _myInterest;

  TextEditingController _controllerFirstname;
  TextEditingController _controllerLastname;
  TextEditingController _controllerEmail;
  TextEditingController _controllerMobile;

  @override
  void initState() {
    super.initState();
    _controllerFirstname =
        TextEditingController(text: widget.userlist.firstname);
    _controllerLastname = TextEditingController(text: widget.userlist.lastname);
    _controllerEmail = TextEditingController(text: widget.userlist.email);
    _controllerMobile = TextEditingController(text: widget.userlist.phone);
    _myInterest = widget.userlist.category;
    print(_myInterest);
    _savePageData();
  }

  _savePageData() async {
    var prefs = await SharedPreferences.getInstance();

    prefs.setString('firstname', _controllerFirstname.text);
    prefs.setString('lastname', _controllerLastname.text);
    prefs.setString('email', _controllerEmail.text);
    prefs.setString('mobile', _controllerMobile.text);
    prefs.setString('category', _myInterest);
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
                              'First Name',
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
                              hintText: "Enter Your First Name",
                            ),
                            controller: _controllerFirstname,
                            onChanged: (String value) {
                              save('firstname', value);
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
                              'Last Name',
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
                              hintText: "Enter Your Last Name",
                            ),
                            controller: _controllerLastname,
                            onChanged: (String value) {
                              setState(() {
                                // _controllerLastname.text = value;
                              });
                              save('lastname', value);
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
                            controller: _controllerEmail,
                            decoration: const InputDecoration(
                                hintText: "Enter Email ID"),
                            onChanged: (String value) {
                              setState(() {
                                // _controllerEmail.text = value;
                              });
                              save('email', value);
                            },
                            readOnly: true,
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
                              'Mobile',
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
                            controller: _controllerMobile,
                            decoration: const InputDecoration(
                                hintText: "Enter Mobile Number"),
                            onChanged: (String value) {
                              setState(() {
                                // _controllerMobile.text = value;
                              });
                              save('mobile', value);
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
                              'Job Category',
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
                        MyDropDownButton(
                          onChanged: (String newVal) {
                            setState(() {
                              _myInterest = newVal;
                              // state.didChange(newVal);
                            });
                            save('category', newVal);
                          },
                          value: _myInterest,
                        ),
                      ],
                    )),
                Padding(
                    padding:
                        EdgeInsets.only(left: 25.0, right: 15.0, top: 40.0),
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
                                          return EmployeePremium();
                                        },
                                      ),
                                    );
                                  },
                                  child: Text("Become a Premium Member",
                                      style: TextStyle(
                                        color: Colors.black,
                                        fontSize: 16.0,
                                        fontWeight: FontWeight.bold,
                                      )))),
                          flex: 4,
                        ),
                      ],
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
