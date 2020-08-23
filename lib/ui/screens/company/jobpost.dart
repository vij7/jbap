import 'package:flutter/material.dart';
import 'package:jobapp/constants.dart';
import 'package:jobapp/models/bottomsheet.dart';
import 'package:jobapp/models/job.dart';
import 'package:jobapp/models/login_class.dart';
import 'package:jobapp/models/login_company_class.dart';
import 'package:jobapp/services/jobpost_service.dart';
import 'package:jobapp/ui/screens/home.dart';
import 'package:jobapp/ui/widgets/mydropdownbutton.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class JobPost extends StatefulWidget {
  final User userinfo;
  final Company companyinfo;
  final TabChangeCallback onTabChangeCallback;
  JobPost(
      {Key key,
      @required this.userinfo,
      @required this.companyinfo,
      this.onTabChangeCallback})
      : super(key: key);
  createState() {
    return _JobPostState(onTabChangeCallback);
  }
}

class _JobPostState extends State<JobPost> {
  TabChangeCallback onTabChangeCallback;
  _JobPostState(TabChangeCallback onTabChangeCallback) {
    this.onTabChangeCallback = onTabChangeCallback;
  }
  @override
  void initState() {
    super.initState();
    _fetchLogindata();
  }

  String _isUserid;
  String _myInterest;
  bool _isPremium = false;

  _fetchLogindata() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      _isUserid = (prefs.getString('userid') ?? null);
      if (prefs.getString('isPremium') == "1") {
        _isPremium = true;
      }
    });
  }

  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  final GlobalKey<FormState> _formKey = new GlobalKey<FormState>();

  String descriptionresult = "";

  JobModel newContact = new JobModel();

  void showMessage(String message, [MaterialColor color]) {
    _scaffoldKey.currentState.showSnackBar(
        new SnackBar(backgroundColor: color, content: new Text(message)));
  }

  void _submitForm() {
    final FormState form = _formKey.currentState;

    if (!form.validate()) {
      showMessage('Form is not valid!  Please review and correct.');
    } else {
      form.save();
      print('Form save called, newContact is now up to date...');
      print('Name: ${newContact.title}');
      print('Email: ${newContact.companyid}');
      print('Email: ${newContact.description}');
      print('Gender: ${newContact.salaryFrom}');
      print('Caste: ${newContact.salaryTo}');
      print('========================================');
      print('Submitting to back end...');
      var registerService = new JobPostService();
      registerService.postJob(newContact).then((value) {
        if (value.error == false) {
          // showMessage(value.message, Colors.green);
          onTabChangeCallback();
        } else if (value.error == true) {
          showMessage(value.message, Colors.red);
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      body: Container(
        child: Padding(
          padding: EdgeInsets.only(bottom: 5.0),
          child: SingleChildScrollView(
            child: new Form(
              key: _formKey,
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
                                    fontSize: 16.0,
                                    fontWeight: FontWeight.bold),
                              ),
                            ],
                          ),
                        ],
                      )),
                  Padding(
                      padding:
                          EdgeInsets.only(left: 25.0, right: 25.0, top: 2.0),
                      child: new Row(
                        mainAxisSize: MainAxisSize.max,
                        children: <Widget>[
                          new Flexible(
                            child: new TextFormField(
                              decoration: const InputDecoration(
                                hintText: "Job Title",
                              ),
                              onSaved: (String val) {
                                newContact.title = val;
                                newContact.companyid = _isUserid;
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
                                    fontSize: 16.0,
                                    fontWeight: FontWeight.bold),
                              ),
                            ],
                          ),
                        ],
                      )),
                  Padding(
                      padding:
                          EdgeInsets.only(left: 25.0, right: 25.0, top: 2.0),
                      child: new Row(
                        mainAxisSize: MainAxisSize.max,
                        children: <Widget>[
                          MyDropDownButton(
                            onChanged: (String newVal) {
                              setState(() {
                                _myInterest = newVal;
                                newContact.category = _myInterest;
                              });
                            },
                            value: _myInterest,
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
                                'Salary From',
                                style: TextStyle(
                                    fontSize: 16.0,
                                    fontWeight: FontWeight.bold),
                              ),
                            ),
                            flex: 2,
                          ),
                          Expanded(
                            child: Container(
                              child: new Text(
                                'Salary To',
                                style: TextStyle(
                                    fontSize: 16.0,
                                    fontWeight: FontWeight.bold),
                              ),
                            ),
                            flex: 2,
                          ),
                        ],
                      )),
                  Padding(
                      padding:
                          EdgeInsets.only(left: 25.0, right: 25.0, top: 2.0),
                      child: new Row(
                        mainAxisSize: MainAxisSize.max,
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: <Widget>[
                          Flexible(
                            child: Padding(
                              padding: EdgeInsets.only(right: 10.0),
                              child: new TextFormField(
                                decoration: const InputDecoration(
                                    hintText: "Salary From"),
                                onSaved: (String val) {
                                  newContact.salaryFrom = val;
                                },
                              ),
                            ),
                            flex: 2,
                          ),
                          Flexible(
                            child: new TextFormField(
                              decoration:
                                  const InputDecoration(hintText: "Salary To"),
                              onSaved: (String val) {
                                newContact.salaryTo = val;
                              },
                            ),
                            flex: 2,
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
                                'Description',
                                style: TextStyle(
                                    fontSize: 16.0,
                                    fontWeight: FontWeight.bold),
                              ),
                            ],
                          ),
                        ],
                      )),
                  Padding(
                      padding:
                          EdgeInsets.only(left: 25.0, right: 25.0, top: 2.0),
                      child: new Row(
                        mainAxisSize: MainAxisSize.max,
                        children: <Widget>[
                          new Flexible(
                            child: new TextFormField(
                              maxLines: 8,
                              onSaved: (String val) {
                                setState(() {
                                  descriptionresult = val;
                                });
                                newContact.description = descriptionresult;
                              },
                            ),
                          ),
                        ],
                      )),
                  _getActionButtons(),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _getActionButtons() {
    return Padding(
      padding: EdgeInsets.only(left: 25.0, right: 25.0, top: 45.0),
      child: new Row(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
          Expanded(
            child: Padding(
              padding: EdgeInsets.only(right: 10.0),
              child: Container(
                  child: new RaisedButton(
                child: new Text("Submit"),
                textColor: Colors.white,
                color: _isPremium ? kPremiumColor : kSecondaryColor,
                onPressed: _submitForm,
                shape: new RoundedRectangleBorder(
                    borderRadius: new BorderRadius.circular(20.0)),
              )),
            ),
            flex: 2,
          ),
          Expanded(
            child: Padding(
              padding: EdgeInsets.only(left: 10.0),
              child: Container(
                  child: new RaisedButton(
                child: new Text("Cancel"),
                textColor: Colors.black,
                color: _isPremium ? kPremiumLightColor : kSecondaryLightColor,
                onPressed: () {
                  Navigator.of(this.context).pushAndRemoveUntil(
                      MaterialPageRoute(
                          builder: (context) =>
                              ChangeNotifierProvider<MyBottomSheetModel>(
                                  create: (_) => MyBottomSheetModel(),
                                  builder: (context, child) => HomeScreen())),
                      (r) => false);
                },
                shape: new RoundedRectangleBorder(
                    borderRadius: new BorderRadius.circular(20.0)),
              )),
            ),
            flex: 2,
          ),
        ],
      ),
    );
  }
}

typedef TabChangeCallback = void Function();
