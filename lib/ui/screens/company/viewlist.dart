import 'dart:convert';
import 'package:empty_widget/empty_widget.dart';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:jobapp/constants.dart';
import 'package:jobapp/models/job.dart';
import 'package:jobapp/models/login_class.dart';
import 'package:jobapp/models/login_company_class.dart';
import 'package:jobapp/ui/screens/company/companyhome.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:jobapp/ui/widgets/emptyresult.dart';

Future<List<JobModel>> fetchJobPosts(http.Client client) async {
  final response = await client.get(baseUrl + 'getAlljobsbycompany/$_isUserid');
  // print(response.body);

  return compute(parsePosts, response.body);
}

List<JobModel> parsePosts(String responseBody) {
  Map<String, dynamic> map = json.decode(responseBody);
  final parsed = map['jobs'];
  // final parsed = json.decode(responseBody).cast<Map<String, dynamic>>();
  return parsed.map<JobModel>((json) => JobModel.fromJson(json)).toList();
}

String _isUserid;

class ViewListPage extends StatefulWidget {
  @override
  _ViewListPageState createState() => _ViewListPageState();
  final User userinfo;
  final Company companyinfo;
  ViewListPage({Key key, @required this.userinfo, @required this.companyinfo})
      : super(key: key);
}

class _ViewListPageState extends State<ViewListPage> {
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
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
                        ? CompanyHomeScreen(
                            joblist: snapshot.data,
                            emplist: null,
                          )
                        : snapshot.connectionState == ConnectionState.waiting
                            ? Center(child: CircularProgressIndicator())
                            : Center(
                                child: EmptyResultWidget(
                                image: PackageImage.Image_2,
                                title: 'No Jobs Posted yet.',
                              ));
                  },
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
