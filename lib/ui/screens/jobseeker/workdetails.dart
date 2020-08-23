import 'package:flutter/material.dart';
import 'package:jobapp/models/login_class.dart';
import 'package:shared_preferences/shared_preferences.dart';

class WorkDetails extends StatefulWidget {
  @override
  _WorkDetailsState createState() => _WorkDetailsState();
  final User userlist;
  WorkDetails({Key key, @required this.userlist}) : super(key: key);
}

class _WorkDetailsState extends State<WorkDetails>
    with AutomaticKeepAliveClientMixin<WorkDetails> {
  TextEditingController _controllerJobtitle;
  TextEditingController _controllerAbout;
  TextEditingController _controllerSkills;
  TextEditingController _controllerKeywords;
  TextEditingController _controllerQualification;
  TextEditingController _controllerExperience;
  TextEditingController _controllerCTC;
  TextEditingController _controllerSalary;

  @override
  void initState() {
    super.initState();
    _controllerJobtitle = TextEditingController(text: widget.userlist.jobtitle);
    _controllerAbout = TextEditingController(text: widget.userlist.about);
    _controllerSkills = TextEditingController(text: widget.userlist.skills);
    _controllerKeywords = TextEditingController(text: widget.userlist.keywords);
    _controllerQualification =
        TextEditingController(text: widget.userlist.qualification);
    _controllerExperience =
        TextEditingController(text: widget.userlist.experience);
    _controllerCTC = TextEditingController(text: widget.userlist.ctc);
    _controllerSalary =
        TextEditingController(text: widget.userlist.salaryrange);

    _savePageData();
  }

  _savePageData() async {
    var prefs = await SharedPreferences.getInstance();

    prefs.setString('jobtitle', _controllerJobtitle.text);
    prefs.setString('about', _controllerAbout.text);
    prefs.setString('skills', _controllerSkills.text);
    prefs.setString('keywords', _controllerKeywords.text);
    prefs.setString('qualification', _controllerQualification.text);
    prefs.setString('experience', _controllerExperience.text);
    prefs.setString('ctc', _controllerCTC.text);
    prefs.setString('salary', _controllerSalary.text);
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
                              'Job Title',
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
                            controller: _controllerJobtitle,
                            decoration: const InputDecoration(
                              hintText: "Job Title",
                            ),
                            onChanged: (String value) {
                              setState(() {
                                // _controllerJobtitle.text = value;
                              });
                              save('jobtitle', value);
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
                              'About',
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
                            controller: _controllerAbout,
                            maxLines: 4,
                            decoration: const InputDecoration(
                              hintText: "About yourself",
                            ),
                            onChanged: (String value) {
                              setState(() {
                                // _controllerAbout.text = value;
                              });
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
                              'Skills',
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
                            controller: _controllerSkills,
                            maxLines: 2,
                            decoration: const InputDecoration(
                                hintText: "Enter Your Skills"),
                            onChanged: (String value) {
                              setState(() {
                                // _controllerSkills.text = value;
                              });
                              save('skills', value);
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
                              'Keywords',
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
                            controller: _controllerKeywords,
                            maxLines: 2,
                            decoration: const InputDecoration(
                                hintText: "Enter Keywords"),
                            onChanged: (String value) {
                              setState(() {
                                // _controllerKeywords.text = value;
                              });
                              save('keywords', value);
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
                              'Qualification',
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
                            controller: _controllerQualification,
                            maxLines: 2,
                            decoration: const InputDecoration(hintText: ""),
                            onChanged: (String value) {
                              setState(() {
                                // _controllerQualification.text = value;
                              });
                              save('qualification', value);
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
                              'Experience',
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
                            controller: _controllerExperience,
                            maxLines: 2,
                            decoration: const InputDecoration(
                                hintText: "Your Experience"),
                            onChanged: (String value) {
                              setState(() {
                                // _controllerExperience.text = value;
                              });
                              save('experience', value);
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
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: <Widget>[
                        Expanded(
                          child: Container(
                            child: new Text(
                              'CTC',
                              style: TextStyle(
                                  fontSize: 16.0, fontWeight: FontWeight.bold),
                            ),
                          ),
                          flex: 2,
                        ),
                        Expanded(
                          child: Container(
                            child: new Text(
                              'Salary',
                              style: TextStyle(
                                  fontSize: 16.0, fontWeight: FontWeight.bold),
                            ),
                          ),
                          flex: 2,
                        ),
                      ],
                    )),
                Padding(
                    padding: EdgeInsets.only(left: 25.0, right: 25.0, top: 2.0),
                    child: new Row(
                      mainAxisSize: MainAxisSize.max,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: <Widget>[
                        Flexible(
                          child: Padding(
                            padding: EdgeInsets.only(right: 10.0),
                            child: new TextFormField(
                              controller: _controllerCTC,
                              decoration:
                                  const InputDecoration(hintText: "Enter CTC"),
                              onChanged: (String value) {
                                setState(() {
                                  // _controllerCTC.text = value;
                                });
                                save('ctc', value);
                              },
                            ),
                          ),
                          flex: 2,
                        ),
                        Flexible(
                          child: new TextFormField(
                            controller: _controllerSalary,
                            decoration: const InputDecoration(
                                hintText: "Enter Salary range"),
                            onChanged: (String value) {
                              setState(() {
                                // _controllerSalary.text = value;
                              });
                              save('salary', value);
                            },
                          ),
                          flex: 2,
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
