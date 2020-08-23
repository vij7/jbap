import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:jobapp/constants.dart';
import 'package:jobapp/models/job.dart';

import 'package:jobapp/models/login_class.dart';
import 'package:jobapp/ui/screens/company/applicants.dart';
import 'package:jobapp/ui/screens/company/screens.dart';
import 'package:jobapp/ui/screens/home.dart';
import 'package:jobapp/ui/widgets/myjobcontainer.dart';
import 'package:jobapp/ui/widgets/widgets.dart';

// ignore: must_be_immutable
class CompanyHomeScreen extends StatefulWidget {
  final List<User> emplist;
  List<JobModel> joblist;
  CompanyHomeScreen({Key key, @required this.emplist, @required this.joblist})
      : super(key: key);

  @override
  _CompanyHomeScreenState createState() => _CompanyHomeScreenState();
}

class _CompanyHomeScreenState extends State<CompanyHomeScreen> {
  void removeItem(int index) {
    setState(() {
      widget.joblist = List.from(widget.joblist)..removeAt(index);
    });
  }

  @override
  Widget build(BuildContext context) {
    return widget.emplist != null
        ? ListView.builder(
            itemCount: widget.emplist.length,
            itemBuilder: (ctx, i) {
              return UserContainer(
                firstname: widget.emplist[i].firstname,
                lastname: widget.emplist[i].lastname,
                email: widget.emplist[i].email,
                phone: widget.emplist[i].phone,
                skills: widget.emplist[i].skills,
                jobtitle: widget.emplist[i].jobtitle,
                onTap: () => Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (ctx) => DetailsScreen(emplist: widget.emplist[i]),
                  ),
                ),
              );
            },
          )
        : ListView.builder(
            itemCount: widget.joblist.length,
            itemBuilder: (ctx, i) {
              return MyJobContainer(
                description: widget.joblist[i].description,
                iconUrl: widget.joblist[i].iconUrl,
                location: widget.joblist[i].location,
                title: widget.joblist[i].title,
                company: widget.joblist[i].companyname,
                salaryFrom: widget.joblist[i].salaryFrom,
                salaryTo: widget.joblist[i].salaryTo,
                onPressView: () => Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (ctx) =>
                          JobApplicant(jobid: widget.joblist[i].id)),
                ),
                onPressDel: () async {
                  final ConfirmAction action =
                      await _asyncConfirmDialog(context);
                  print("Confirm Action $action");
                  if (action == ConfirmAction.Accept) {
                    deleteJob(widget.joblist[i].id, companyID).then((value) {
                      if (value == true) {
                        removeItem(i);
                      }
                    });
                  }
                },
              );
            },
          );
  }

  Future<bool> deleteJob(String id, String companyid) async {
    try {
      FormData formData =
          new FormData.fromMap({"company_id": companyid, "job_id": id});
      print(formData.fields);
      Response response =
          await Dio().post(baseUrl + 'deletejob', data: formData);
      print("response: $response");

      final Map<String, dynamic> responseData = json.decode(response.data);
      bool error = responseData['error'];
      if (error == false) {
        return true;
      } else if (error == true) {
        return false;
      }
    } catch (e) {
      print("Exception Caught: $e");
      return false;
    }
    return false;
  }
}

enum ConfirmAction { Cancel, Accept }
Future<ConfirmAction> _asyncConfirmDialog(BuildContext context) async {
  return showDialog<ConfirmAction>(
    context: context,
    barrierDismissible: false, // user must tap button for close dialog!
    builder: (BuildContext context) {
      return AlertDialog(
        title: Text('Confirmation'),
        content: const Text('Do you really want to delete this job?'),
        actions: <Widget>[
          FlatButton(
            child: const Text('No'),
            onPressed: () {
              Navigator.of(context).pop(ConfirmAction.Cancel);
            },
          ),
          FlatButton(
            child: const Text('Yes'),
            onPressed: () {
              Navigator.of(context).pop(ConfirmAction.Accept);
            },
          )
        ],
      );
    },
  );
}
