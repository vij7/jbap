import 'dart:convert';
import 'package:empty_widget/empty_widget.dart';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:jobapp/constants.dart';
import 'package:jobapp/models/bottomsheet.dart';
import 'package:jobapp/models/job.dart';
import 'package:jobapp/models/login_class.dart';
import 'package:jobapp/models/login_company_class.dart';
import 'package:jobapp/ui/screens/home.dart';
import 'package:jobapp/ui/screens/jobseeker/seekerhome.dart';
import 'package:jobapp/ui/widgets/mybottomnavbar.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:jobapp/ui/widgets/emptyresult.dart';

Future<List<JobModel>> fetchJobPosts(http.Client client) async {
  final response =
      await client.get(baseUrl + 'getallAppliedJobsbyuser/$_isUserid');
  print(response.body);

  return compute(parsePosts, response.body);
}

List<JobModel> parsePosts(String responseBody) {
  Map<String, dynamic> map = json.decode(responseBody);
  final parsed = map['appliedjobs'];
  print(parsed);
  // final parsed = json.decode(responseBody).cast<Map<String, dynamic>>();
  return parsed.map<JobModel>((json) => JobModel.fromJson(json)).toList();
}

String _isUserid;

class JobApplied extends StatefulWidget {
  @override
  _JobAppliedState createState() => _JobAppliedState();
  final User userinfo;
  final Company companyinfo;
  JobApplied({Key key, @required this.userinfo, @required this.companyinfo})
      : super(key: key);
}

class _JobAppliedState extends State<JobApplied> {
  JobModel newContact = new JobModel();

  @override
  void initState() {
    super.initState();
    _fetchLogindata();
  }

  _fetchLogindata() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      _isUserid = (prefs.getString('userid') ?? null);
      print(_isUserid);
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
          backgroundColor: kPrimaryColor,
          automaticallyImplyLeading: false,
          leading: Icon(Icons.work),
          title: new Text('Applied Jobs'),
        ),
        body: Stack(children: <Widget>[
          Positioned(
            top: 0,
            right: 0,
            left: 0,
            bottom: 60,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 15.0),
              child: Column(
                children: <Widget>[
                  SizedBox(
                    height: 11,
                  ),
                  Expanded(
                    child: FutureBuilder<List<JobModel>>(
                      future: fetchJobPosts(http.Client()),
                      builder: (context, snapshot) {
                        if (snapshot.hasError) print(snapshot.error);
                        return snapshot.hasData && snapshot.data.isNotEmpty
                            ? SeekerHomeScreen(joblist: snapshot.data)
                            : snapshot.connectionState ==
                                    ConnectionState.waiting
                                ? Center(child: CircularProgressIndicator())
                                : Center(
                                    child: EmptyResultWidget(
                                    image: PackageImage.Image_2,
                                    title: 'Sorry! No Jobs Applied yet.',
                                  ));
                      },
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
        ]),
      ),
    );
  }
}
