import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:jobapp/constants.dart';
import 'package:jobapp/models/bottomsheet.dart';
import 'package:jobapp/models/login_class.dart';
import 'package:jobapp/services/userprofile_update_service.dart';
import 'package:jobapp/ui/screens/home.dart';
import 'dart:io';
import 'package:path/path.dart';
import 'package:dio/dio.dart';
import 'package:file_picker/file_picker.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:progress_dialog/progress_dialog.dart';

class ContactDetails extends StatefulWidget {
  @override
  _ContactDetailsState createState() => _ContactDetailsState();
  final User userlist;
  ContactDetails({Key key, @required this.userlist}) : super(key: key);
}

class _ContactDetailsState extends State<ContactDetails>
    with AutomaticKeepAliveClientMixin<ContactDetails> {
  ProgressDialog pr;
  String _isUserid;
  String fileName;
  bool _visible = false;
  File _file;

  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  final GlobalKey<FormState> _formKey = new GlobalKey<FormState>();

  User userData = new User();

  TextEditingController _controllerAddress;
  TextEditingController _controllerCity;
  TextEditingController _controllerPincode;
  TextEditingController _controllerState;
  TextEditingController _controllerResume;

  @override
  void initState() {
    super.initState();
    _fetchLogindata();

    _controllerAddress = TextEditingController(text: widget.userlist.address);
    _controllerCity = TextEditingController(text: widget.userlist.city);
    _controllerPincode = TextEditingController(text: widget.userlist.postcode);
    _controllerState = TextEditingController(text: widget.userlist.state);
    _controllerResume = TextEditingController(text: widget.userlist.resumeName);

    _savePageData();
    _fetchSaveddata();
  }

  _fetchLogindata() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      _isUserid = (prefs.getString('userid') ?? null);
      print(_isUserid);
    });
  }

  _savePageData() async {
    var prefs = await SharedPreferences.getInstance();

    prefs.setString('address', _controllerAddress.text);
    prefs.setString('city', _controllerCity.text);
    prefs.setString('postcode', _controllerPincode.text);
    prefs.setString('state', _controllerState.text);
    prefs.setString('resumename', _controllerResume.text);
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

  Future getFile() async {
    File file = await FilePicker.getFile(
        allowedExtensions: ['pdf'], type: FileType.custom);
    fileName = basename(file.path);
    setState(() {
      _file = file;
      print(_file);
      print(fileName);
      _controllerResume = TextEditingController(text: fileName);
      _visible = true;
    });
  }

  // Methode for file upload
  void _uploadFile(filePath) async {
    // Get base file name
    setState(() {
      pr.show();
    });

    fileName = basename(filePath.path);
    print("File base name: $fileName");

    try {
      FormData formData = new FormData.fromMap({
        "user_id": _isUserid,
        "resume":
            await MultipartFile.fromFile(filePath.path, filename: fileName)
      });

      Response response =
          await Dio().post(baseUrl + 'resumeupdate', data: formData);
      print("File upload response: $response");

      final Map<String, dynamic> responseData = json.decode(response.data);
      bool error = responseData['error'];
      String message = responseData['message'];
      if (error == false) {
        setState(() {
          pr.hide();
        });
        showMessage(message, Colors.green);
      } else {
        setState(() {
          pr.hide();
        });
        showMessage(message, Colors.red);
      }
    } catch (e) {
      print("Exception Caught: $e");
    }
  }

  void showMessage(String message, [MaterialColor color]) {
    _scaffoldKey.currentState.showSnackBar(
        new SnackBar(backgroundColor: color, content: new Text(message)));
  }

  _fetchSaveddata() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      userData.firstname = prefs.getString('firstname');
      userData.lastname = prefs.getString('lastname');
      userData.email = prefs.getString('email');
      userData.phone = prefs.getString('mobile');
      userData.category = prefs.getString('category');
      userData.jobtitle = prefs.getString('jobtitle');
      userData.about = prefs.getString('about');
      userData.skills = prefs.getString('skills');
      userData.keywords = prefs.getString('keywords');
      userData.qualification = prefs.getString('qualification');
      userData.experience = prefs.getString('experience');
      userData.ctc = prefs.getString('ctc');
      userData.salaryrange = prefs.getString('salary');
      userData.address = prefs.getString('address');
      userData.city = prefs.getString('city');
      userData.postcode = prefs.getString('postcode');
      userData.state = prefs.getString('state');
      userData.userid = _isUserid;
    });
  }

  void _submitForm() {
    print('submit home');
    setState(() {
      pr.show();
    });
    final FormState form = _formKey.currentState;

    if (!form.validate()) {
      showMessage('Form is not valid!  Please review and correct.');
    } else {
      print('Form save called, newContact is now up to date...');
      print('firstname: ${userData.firstname}');
      print('jobtitle: ${userData.jobtitle}');
      print('address: ${userData.address}');
      // print('========================================');
      print('Submitting to back end...');
      var registerService = new ProfileUpdateService();
      registerService.updateProfile(userData).then((value) {
        if (value.error == false) {
          setState(() {
            pr.hide();
          });
          showMessage(value.message, Colors.green);
        } else if (value.error == true) {
          setState(() {
            pr.hide();
          });
          showMessage(value.message, Colors.red);
        }
      });
    }
  }

  @override
  // ignore: must_call_super
  Widget build(BuildContext context) {
    pr = new ProgressDialog(context, type: ProgressDialogType.Normal);

    //Optional
    pr.style(
      message: 'Please wait...',
      borderRadius: 10.0,
      backgroundColor: Colors.white,
      progressWidget: CircularProgressIndicator(),
      elevation: 10.0,
      insetAnimCurve: Curves.easeInOut,
      progressTextStyle: TextStyle(
          color: Colors.black, fontSize: 13.0, fontWeight: FontWeight.w400),
      messageTextStyle: TextStyle(
          color: Colors.black, fontSize: 19.0, fontWeight: FontWeight.w600),
    );

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
                                'Address',
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
                            controller: _controllerAddress,
                            maxLines: 3,
                            decoration: const InputDecoration(
                              hintText: "Enter Your Address",
                            ),
                            onChanged: (String value) {
                              setState(() {
                                // _controllerAddress.text = value;
                              });

                              save('address', value);
                            },
                          )),
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
                                'City',
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
                              controller: _controllerCity,
                              decoration: const InputDecoration(
                                hintText: "Enter Your City",
                              ),
                              onChanged: (String value) {
                                setState(() {
                                  // _controllerCity.text = value;
                                });

                                save('city', value);
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
                                'Pin Code',
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
                                'State',
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
                                controller: _controllerPincode,
                                decoration: const InputDecoration(
                                    hintText: "Enter Pin Code"),
                                onChanged: (String value) {
                                  setState(() {
                                    // _controllerPincode.text = value;
                                  });

                                  save('postcode', value);
                                },
                              ),
                            ),
                            flex: 2,
                          ),
                          Flexible(
                            child: new TextFormField(
                              controller: _controllerState,
                              decoration: const InputDecoration(
                                  hintText: "Enter State"),
                              onChanged: (String value) {
                                setState(() {
                                  // _controllerState.text = value;
                                });

                                save('state', value);
                              },
                            ),
                            flex: 2,
                          ),
                        ],
                      )),
                  _getActionButtons(),
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
                                'Upload Resume',
                                style: TextStyle(
                                    fontSize: 16.0,
                                    fontWeight: FontWeight.bold),
                              ),
                            ),
                            flex: 2,
                          ),
                          Expanded(
                            child: Container(
                              child: Padding(
                                padding: EdgeInsets.only(right: 10.0),
                                child: new RaisedButton(
                                  child: Text('choose'),
                                  onPressed: getFile,
                                ),
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
                        children: <Widget>[
                          new Flexible(
                            child: new TextFormField(
                              readOnly: true,
                              controller: _controllerResume,
                            ),
                          ),
                        ],
                      )),
                  Padding(
                      padding:
                          EdgeInsets.only(left: 25.0, right: 25.0, top: 45.0),
                      child: new Row(
                        mainAxisSize: MainAxisSize.max,
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: <Widget>[
                          Visibility(
                            visible: _visible,
                            child: new Flexible(
                              child: new RaisedButton(
                                child: new Text("Upload Resume"),
                                textColor: Colors.white,
                                color: kPrimaryColor,
                                onPressed: () {
                                  _uploadFile(_file);
                                },
                                shape: new RoundedRectangleBorder(
                                    borderRadius:
                                        new BorderRadius.circular(20.0)),
                              ),
                            ),
                          ),
                        ],
                      )),
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
                child: new Text("Save"),
                textColor: Colors.white,
                color: kPrimaryColor,
                onPressed: () {
                  _savePageData();
                  _fetchSaveddata();
                  _submitForm();
                },
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
                color: kPrimaryLightColor,
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

  @override
  bool get wantKeepAlive => true;
}
