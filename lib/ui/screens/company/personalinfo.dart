import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:jobapp/constants.dart';
import 'package:jobapp/models/bottomsheet.dart';
import 'package:jobapp/models/login_company_class.dart';
import 'dart:io';
import 'package:dio/dio.dart';
import 'package:file_picker/file_picker.dart';
import 'package:jobapp/ui/screens/home.dart';
import 'package:path/path.dart';
import 'package:progress_dialog/progress_dialog.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class PersonalInfo extends StatefulWidget {
  @override
  _PersonalInfoState createState() => _PersonalInfoState();
  final Company userlist;
  PersonalInfo({Key key, @required this.userlist}) : super(key: key);
}

class _PersonalInfoState extends State<PersonalInfo>
    with AutomaticKeepAliveClientMixin<PersonalInfo> {
  ProgressDialog pr;
  String _isUserid;
  String fileName;
  bool _isPremium = false;
  File _file;

  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  final GlobalKey<FormState> _formKey = new GlobalKey<FormState>();

  Company companyData = new Company();

  TextEditingController _controllerFirstname;
  TextEditingController _controllerLastname;
  TextEditingController _controllerLocation;
  TextEditingController _controllerLogo;

  @override
  void initState() {
    super.initState();

    _fetchLogindata();

    _controllerFirstname =
        TextEditingController(text: widget.userlist.firstname);
    _controllerLastname = TextEditingController(text: widget.userlist.lastname);
    _controllerLocation = TextEditingController(text: widget.userlist.location);
    _controllerLogo = TextEditingController(text: widget.userlist.logo);

    _savePageData();
    _fetchSaveddata();
  }

  _fetchLogindata() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      _isUserid = (prefs.getString('userid') ?? null);
      if (prefs.getString('isPremium') == "1") {
        _isPremium = true;
      }
    });
  }

  _savePageData() async {
    var prefs = await SharedPreferences.getInstance();

    prefs.setString('firstname', _controllerFirstname.text);
    prefs.setString('lastname', _controllerLastname.text);
    prefs.setString('location', _controllerLocation.text);
    prefs.setString('logo', _controllerLogo.text);
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
        allowedExtensions: ['jpg', 'jpge', 'png'], type: FileType.custom);
    fileName = basename(file.path);
    setState(() {
      _file = file;
      print(_file);
      print(fileName);
      _controllerLogo = TextEditingController(text: fileName);
    });
  }

  // Methode for file upload
  void _uploadFile(filePath) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      pr.show();
    });
    final FormState form = _formKey.currentState;

    if (filePath != null) {
      fileName = basename(filePath.path);
      print("File base name: $fileName");
    }

    if (!form.validate()) {
      showMessage('Form is not valid!  Please review and correct.');
    } else {
      try {
        FormData formData;
        if (filePath != null) {
          formData = new FormData.fromMap({
            "company_id": _isUserid,
            "first_name": companyData.firstname,
            "last_name": companyData.lastname,
            "company_name": companyData.companyname,
            "about_company": companyData.about,
            "phone": companyData.phone,
            "location": companyData.location,
            "logo":
                await MultipartFile.fromFile(filePath.path, filename: fileName)
          });
        } else {
          formData = new FormData.fromMap({
            "company_id": _isUserid,
            "first_name": companyData.firstname,
            "last_name": companyData.lastname,
            "company_name": companyData.companyname,
            "about_company": companyData.about,
            "phone": companyData.phone,
            "location": companyData.location
          });
        }

        print(formData.fields);
        Response response =
            await Dio().post(baseUrl + 'companyprofileupdate', data: formData);
        print("File upload response: $response");

        final Map<String, dynamic> responseData = json.decode(response.data);
        bool error = responseData['error'];
        String message = responseData['message'];
        if (error == false) {
          String jsonString = _toJsonforsave(companyData);
          Map decodedata = jsonDecode(jsonString);
          final parsed = decodedata;
          print(parsed);
          String company = jsonEncode(Company.fromJson(parsed));
          prefs.setString('company', company);
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
  }

  String _toJsonforsave(Company reg) {
    var mapData = new Map();
    mapData["user_id"] = reg.userid;
    mapData["first_name"] = reg.firstname;
    mapData["last_name"] = reg.lastname;
    mapData["email"] = reg.email;
    mapData["phone"] = reg.phone;
    mapData["company_name"] = reg.companyname;
    mapData["location"] = reg.location;
    mapData["logo"] = reg.logo;
    mapData["about"] = reg.about;
    print('printing mapdata');
    print(mapData);
    String jsonReg = json.encode(mapData);
    return jsonReg;
  }

  void showMessage(String message, [MaterialColor color]) {
    _scaffoldKey.currentState.showSnackBar(
        new SnackBar(backgroundColor: color, content: new Text(message)));
  }

  _fetchSaveddata() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      companyData.firstname = prefs.getString('firstname');
      companyData.lastname = prefs.getString('lastname');
      companyData.email = prefs.getString('email');
      companyData.phone = prefs.getString('mobile');
      companyData.companyname = prefs.getString('companyname');
      companyData.location = prefs.getString('location');
      companyData.about = prefs.getString('about');
      companyData.logo = prefs.getString('logo');
      companyData.userid = _isUserid;
    });
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
                                'First Name',
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
                                hintText: "Enter Your Last Name",
                              ),
                              controller: _controllerLastname,
                              onChanged: (String value) {
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
                                'Location',
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
                              decoration:
                                  const InputDecoration(hintText: "Location"),
                              controller: _controllerLocation,
                              onChanged: (String value) {
                                save('location', value);
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
                                'Logo',
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
                              child: _file == null
                                  ? new Image.network(
                                      _controllerLogo.text,
                                      height: 100,
                                      width: 100,
                                    )
                                  : new Image.file(
                                      _file,
                                      height: 100,
                                      width: 100,
                                    )),
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
                child: new Text("Save"),
                textColor: Colors.white,
                color: _isPremium ? kPremiumColor : kSecondaryColor,
                onPressed: () {
                  _savePageData();
                  _fetchSaveddata();
                  _uploadFile(_file);
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

  @override
  bool get wantKeepAlive => true;
}
