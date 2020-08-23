import 'dart:convert';
import 'package:empty_widget/empty_widget.dart';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:jobapp/constants.dart';
import 'package:jobapp/models/login_class.dart';
import 'package:jobapp/ui/screens/company/companyhome.dart';

import 'package:jobapp/ui/widgets/emptyresult.dart';
import 'package:shared_preferences/shared_preferences.dart';

Future<List<User>> fetchApplicantPosts(http.Client client) async {
  final response = await client.get(baseUrl + 'getallApplicantsbyJob/$jobID');
  print(response.body);

  return compute(parsePosts, response.body);
}

List<User> parsePosts(String responseBody) {
  Map<String, dynamic> map = json.decode(responseBody);
  final parsed = map['applicants'];
  print(parsed);
  // final parsed = json.decode(responseBody).cast<Map<String, dynamic>>();
  return parsed.map<User>((json) => User.fromJson(json)).toList();
}

String jobID;

class JobApplicant extends StatefulWidget {
  @override
  _ApplicantState createState() => _ApplicantState();
  final String jobid;
  JobApplicant({Key key, @required this.jobid}) : super(key: key);
}

class _ApplicantState extends State<JobApplicant> {
  bool _isPremium = false;
  @override
  void initState() {
    super.initState();
    jobID = widget.jobid;
    fetchApplicantPosts(http.Client());
    _fetchLogindata();
  }

  _fetchLogindata() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      if (prefs.getString('isPremium') == "1") {
        _isPremium = true;
      }
    });
  }

  // Future<bool> _onBackPressed() {
  //   return Navigator.of(context).pushReplacement(MaterialPageRoute(
  //       builder: (BuildContext context) =>
  //           ChangeNotifierProvider<MyBottomSheetModel>(
  //               create: (_) => MyBottomSheetModel(),
  //               builder: (context, child) => HomeScreen())));
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: _isPremium ? kPremiumColor : kSecondaryColor,
        // automaticallyImplyLeading: false,
        leading: new IconButton(
          icon: new Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: new Text('Applicants'),
      ),
      body: Stack(children: <Widget>[
        Positioned(
          top: 0,
          right: 0,
          left: 0,
          bottom: 20,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15.0),
            child: Column(
              children: <Widget>[
                SizedBox(
                  height: 11,
                ),
                Expanded(
                  child: FutureBuilder<List<User>>(
                    future: fetchApplicantPosts(http.Client()),
                    builder: (context, snapshot) {
                      if (snapshot.hasError) print(snapshot.error);
                      return snapshot.hasData && snapshot.data.isNotEmpty
                          ? CompanyHomeScreen(
                              emplist: snapshot.data,
                              joblist: null,
                            )
                          : snapshot.connectionState == ConnectionState.waiting
                              ? Center(child: CircularProgressIndicator())
                              : Center(
                                  child: EmptyResultWidget(
                                  image: PackageImage.Image_3,
                                  title: 'Sorry! No Applications.',
                                ));
                    },
                  ),
                )
              ],
            ),
          ),
        ),
      ]),
    );
  }
}
