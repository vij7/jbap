import 'dart:async';
import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:jobapp/models/bottomsheet.dart';
import 'package:jobapp/models/job.dart';
import 'package:jobapp/models/login_class.dart';
import 'package:jobapp/models/login_company_class.dart';
import 'package:jobapp/ui/screens/company/companyhome.dart';
import 'package:jobapp/ui/screens/jobseeker/screens.dart';
import 'package:jobapp/ui/screens/profile.dart';
import 'package:jobapp/ui/widgets/emptyresult.dart';
import 'package:jobapp/ui/widgets/widgets.dart';
import 'package:provider/provider.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:empty_widget/empty_widget.dart';
import 'package:jobapp/constants.dart';

Future<List<JobModel>> fetchPosts(http.Client client) async {
  final response =
      await client.get(baseUrl + 'getAlljobsbycategory/$_myInterest');
  return compute(parsePosts, response.body);
}

Future<List<JobModel>> fetchAllJobs(http.Client client) async {
  final response = await client.get(baseUrl + 'getAlljobs');
  return compute(parsePosts, response.body);
}

Future<List<JobModel>> fetchJobPosts(http.Client client) async {
  final response = await client
      .get(baseUrl + 'getAlljobsbycompanyandcategory/$companyID/$_myInterest');
  return compute(parsePosts, response.body);
}

List<JobModel> parsePosts(String responseBody) {
  Map<String, dynamic> map = json.decode(responseBody);
  final parsed = map['jobs'];
  return parsed.map<JobModel>((json) => JobModel.fromJson(json)).toList();
}

Future<List<User>> fetchEmploye(http.Client client) async {
  final response = await client.get(baseUrl + 'getAllemployees');
  return compute(parseEmploye, response.body);
}

Future<List<User>> fetchAllEmployeCategory(http.Client client) async {
  String url;
  if (_myInterest == null) {
    url = baseUrl + 'getAllemployees';
  } else {
    url = baseUrl + 'getAllemployeesbyCategory/$_myInterest';
  }
  final response = await client.get(url);
  return compute(parseEmploye, response.body);
}

List<User> parseEmploye(String responseBody) {
  Map<String, dynamic> map = json.decode(responseBody);
  final parsed = map['employees'];
  // final parsed = json.decode(responseBody).cast<Map<String, dynamic>>();
  return parsed.map<User>((json) => User.fromJson(json)).toList();
}

String companyID, _myInterest;
List<JobModel> jobs = List();
List<User> emps = List();

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  bool _isJobseeker = false;
  bool _isPremium = false;
  bool _isSearching = false;
  bool _isBottomSearching = false;
  Future<User> usd;
  Future<Company> cmyd;
  User userinfo;
  Company companyinfo;
  List<JobModel> filteredJobs = List();
  List<User> filteredUsers = List();
  List<JobModel> salarySearchList = List();

  void initState() {
    super.initState();
    _fetchLogindata();
    _myInterest = "55";
    usd = getSavedInfo();
    usd.then((value) {
      userinfo = value;
    });

    cmyd = getSavedCompanyInfo();
    cmyd.then((value) {
      companyinfo = value;
      companyID = value.userid;
    });
  }

  _fetchLogindata() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      _isJobseeker = (prefs.getBool('isJobseeker') ?? false);
      if (prefs.getString('isPremium') == "1") {
        _isPremium = true;
      } else {
        _myInterest = "55";
      }
    });

    if (!_isJobseeker) {
      if (_isPremium) {
        fetchEmploye(http.Client()).then((value) {
          setState(() {
            emps = value;
          });
        });
      } else {
        fetchJobPosts(http.Client()).then((value) {
          setState(() {
            jobs = value;
          });
        });
      }
    } else {
      fetchAllJobs(http.Client()).then((value) {
        setState(() {
          jobs = value;
          _myInterest = "55";
        });
      });
    }
  }

  Future<User> getSavedInfo() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    Map userMap = jsonDecode(preferences.getString('jobseeker'));
    User userinfo = User.fromJson(userMap);
    return userinfo;
  }

  Future<Company> getSavedCompanyInfo() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    Map userMap = jsonDecode(preferences.getString('company'));
    Company userinfo = Company.fromJson(userMap);
    return userinfo;
  }

  @override
  Widget build(BuildContext context) {
    final searchList = Provider.of<MyBottomSheetModel>(context, listen: false);
    setState(() {
      if (searchList.isResult == true) {
        _isBottomSearching = true;
      } else {
        _isBottomSearching = false;
      }
    });
    return SafeArea(
      child: Scaffold(
        backgroundColor: Color(0xfff0f0f6),
        body: Stack(
          children: <Widget>[
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
                      height: 7.0,
                    ),
                    Row(
                      children: <Widget>[
                        MyDropDownButton(
                          onChanged: (String newVal) {
                            print(newVal);

                            setState(() {
                              _isSearching = false;
                              if (_isBottomSearching == true) {
                                Provider.of<MyBottomSheetModel>(context,
                                        listen: false)
                                    .changeResultState();
                              }
                              _myInterest = newVal;
                            });

                            print("isbottom $_isBottomSearching");

                            if (_isJobseeker) {
                              fetchPosts(http.Client());
                            } else if (_isPremium) {
                              fetchAllEmployeCategory(http.Client());
                            } else {
                              fetchJobPosts(http.Client());
                            }
                          },
                          value: _myInterest,
                        ),
                        Spacer(),
                        GestureDetector(
                          onTap: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => Profile(
                                          userinfo: userinfo,
                                          companyinfo: companyinfo,
                                        )));
                          },
                          child: CircleAvatar(
                            backgroundImage: NetworkImage(
                                "https://cdn.pixabay.com/photo/2017/06/09/07/37/notebook-2386034_960_720.jpg"),
                          ),
                        )
                      ],
                    ),
                    SizedBox(
                      height: 15,
                    ),
                    Container(
                      height: 51,
                      child: Row(
                        children: <Widget>[
                          Expanded(
                            child: TextField(
                              decoration: InputDecoration(
                                prefixIcon: Icon(Icons.search),
                                hintText: _isPremium
                                    ? "Name,designation,skills or location"
                                    : "Job title,company or location.",
                                border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(15.0),
                                    borderSide: BorderSide.none),
                                fillColor: Color(0xffe6e6ec),
                                filled: true,
                              ),
                              onChanged: (string) {
                                setState(() {
                                  if (_isBottomSearching == true) {
                                    Provider.of<MyBottomSheetModel>(context,
                                            listen: false)
                                        .changeResultState();
                                  }
                                  _isSearching = true;
                                  if (_isPremium == true) {
                                    print(filteredUsers.length);
                                    filteredUsers = emps
                                        .where((u) => (u.firstname
                                                .toLowerCase()
                                                .contains(
                                                    string.toLowerCase()) ||
                                            u.jobtitle.toLowerCase().contains(
                                                string.toLowerCase()) ||
                                            u.city.toLowerCase().contains(
                                                string.toLowerCase()) ||
                                            u.skills.toLowerCase().contains(
                                                string.toLowerCase())))
                                        .toList();
                                  } else {
                                    filteredJobs = jobs
                                        .where((u) => (u.title
                                                .toLowerCase()
                                                .contains(
                                                    string.toLowerCase()) ||
                                            u.companyname
                                                .toLowerCase()
                                                .contains(
                                                    string.toLowerCase()) ||
                                            u.location.toLowerCase().contains(
                                                string.toLowerCase())))
                                        .toList();
                                  }
                                });
                              },
                            ),
                          ),
                          SizedBox(width: 15),
                          _isJobseeker
                              ? Container(
                                  decoration: BoxDecoration(
                                    color: Color(0xffe6e6ec),
                                    borderRadius: BorderRadius.circular(9.0),
                                  ),
                                  child: IconButton(
                                    icon: Icon(Icons.tune),
                                    onPressed: () {
                                      Provider.of<MyBottomSheetModel>(context,
                                              listen: false)
                                          .changeState();
                                    },
                                  ),
                                )
                              : Container(),
                        ],
                      ),
                    ),
                    SizedBox(
                      height: 11,
                    ),
                    _isBottomSearching
                        ? Expanded(
                            child: searchList.getJobslist() != null &&
                                    searchList.getJobslist().length > 0
                                ? SeekerHomeScreen(
                                    joblist: searchList.getJobslist())
                                : Center(
                                    child: EmptyResultWidget(
                                      image: PackageImage.Image_1,
                                      title: 'Sorry! No Jobs Found.',
                                    ),
                                  ))
                        : !_isSearching
                            ? Expanded(
                                child: _isJobseeker
                                    ? FutureBuilder<List<JobModel>>(
                                        future: fetchPosts(http.Client()),
                                        builder: (context, snapshot) {
                                          if (snapshot.hasError)
                                            print(snapshot.error);
                                          return snapshot.hasData &&
                                                  snapshot.data.isNotEmpty
                                              ? SeekerHomeScreen(
                                                  joblist: snapshot.data)
                                              : snapshot.connectionState ==
                                                      ConnectionState.waiting
                                                  ? Center(
                                                      child:
                                                          CircularProgressIndicator())
                                                  : Center(
                                                      child: EmptyResultWidget(
                                                          image: PackageImage
                                                              .Image_1,
                                                          title:
                                                              'Sorry! No Jobs Found.',
                                                          subtitle:
                                                              'Search by Job title, company or location'),
                                                    );
                                        },
                                      )
                                    : _isPremium
                                        ? FutureBuilder<List<User>>(
                                            future: fetchAllEmployeCategory(
                                                http.Client()),
                                            builder: (context, snapshot) {
                                              if (snapshot.hasError)
                                                print(snapshot.error);
                                              return snapshot.hasData &&
                                                      snapshot.data.isNotEmpty
                                                  ? CompanyHomeScreen(
                                                      emplist: snapshot.data,
                                                      joblist: null,
                                                    )
                                                  : snapshot.connectionState ==
                                                          ConnectionState
                                                              .waiting
                                                      ? Center(
                                                          child:
                                                              CircularProgressIndicator())
                                                      : Center(
                                                          child: EmptyResultWidget(
                                                              image:
                                                                  PackageImage
                                                                      .Image_1,
                                                              title:
                                                                  'Sorry! No Employees Available',
                                                              subtitle:
                                                                  'Search by Job title, company or location'),
                                                        );
                                            },
                                          )
                                        : FutureBuilder<List<JobModel>>(
                                            future:
                                                fetchJobPosts(http.Client()),
                                            builder: (context, snapshot) {
                                              if (snapshot.hasError)
                                                print(snapshot.error);
                                              return snapshot.hasData &&
                                                      snapshot.data.isNotEmpty
                                                  ? CompanyHomeScreen(
                                                      emplist: null,
                                                      joblist: snapshot.data,
                                                    )
                                                  : snapshot.connectionState ==
                                                          ConnectionState
                                                              .waiting
                                                      ? Center(
                                                          child:
                                                              CircularProgressIndicator())
                                                      : Center(
                                                          child:
                                                              EmptyResultWidget(
                                                            image: PackageImage
                                                                .Image_1,
                                                            title:
                                                                'No Jobs Posted Yet.',
                                                          ),
                                                        );
                                            },
                                          ),
                              )
                            : Expanded(
                                child: _isJobseeker
                                    ? filteredJobs.length > 0
                                        ? SeekerHomeScreen(
                                            joblist: filteredJobs)
                                        : Center(
                                            child: EmptyResultWidget(
                                              image: PackageImage.Image_3,
                                              title: 'Sorry! No Jobs Found.',
                                            ),
                                          )
                                    : _isPremium
                                        ? filteredUsers.length > 0
                                            ? CompanyHomeScreen(
                                                emplist: filteredUsers,
                                                joblist: null)
                                            : Center(
                                                child: EmptyResultWidget(
                                                  image: PackageImage.Image_3,
                                                  title:
                                                      'Sorry! No Employees Found.',
                                                ),
                                              )
                                        : filteredJobs.length > 0
                                            ? CompanyHomeScreen(
                                                emplist: null,
                                                joblist: filteredJobs)
                                            : Center(
                                                child: EmptyResultWidget(
                                                  image: PackageImage.Image_3,
                                                  title:
                                                      'Sorry! No Jobs Found.',
                                                ),
                                              )),
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
                userinfo: userinfo,
                companyinfo: companyinfo,
                active: 0,
              ),
            ),
            Provider.of<MyBottomSheetModel>(context).visible
                ? Positioned(
                    bottom: 0,
                    left: 0,
                    right: 0,
                    // height: MediaQuery.of(context).size.height / 1.3,
                    child: MyBottomSheet(),
                  )
                : Container(),
          ],
        ),
      ),
    );
  }
}
