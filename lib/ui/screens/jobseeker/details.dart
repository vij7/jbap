import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:jobapp/constants.dart';
import 'package:jobapp/models/job.dart';
import 'package:jobapp/models/jobapply.dart';
import 'package:jobapp/services/jobapply_service.dart';
import 'package:shared_preferences/shared_preferences.dart';

enum ConfirmAction { Cancel, Accept }

class DetailsScreen extends StatefulWidget {
  final JobModel joblist;
  DetailsScreen({Key key, @required this.joblist}) : super(key: key);

  @override
  _DetailsScreenState createState() => _DetailsScreenState();
}

class _DetailsScreenState extends State<DetailsScreen> {
  String _isUserid, _jobid;
  bool _isApplied = false;
  String covermsg;
  TextEditingController _textFieldController = TextEditingController();
  JobApply job = new JobApply();

  @override
  void initState() {
    super.initState();
    _fetchLogindata();
  }

  _fetchLogindata() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      _isUserid = (prefs.getString('userid') ?? null);
      print("userid : $_isUserid");
      _jobid = widget.joblist.id;
      print("jobid $_jobid");
      getSWData();
    });
  }

  List<dynamic> data = List(); //edited line

  Future<String> getSWData() async {
    final String url = baseUrl + 'isjobapplied/$_isUserid/$_jobid';
    print("URL : $url");
    var res = await http
        .get(Uri.encodeFull(url), headers: {"Accept": "application/json"});

    Map<String, dynamic> map = json.decode(res.body);
    List<dynamic> dataitem = map["appliedjobs"];
    print(dataitem[0]["is_applied"].toString());
    setState(() {
      data = dataitem;
      if (dataitem[0]["is_applied"] == 1) {
        _isApplied = true;
      }
    });

    // print(data);

    return "Success";
  }

  void _submitForm() {
    job.jobid = widget.joblist.id;
    job.userid = _isUserid;
    job.message = covermsg;
    var registerService = new JobApplyService();
    registerService.postJob(job).then((value) {
      if (value.error == false) {
        setState(() {
          _isApplied = true;
        });
      } else if (value.error == true) {
        // setState(() {
        //   _isLoading = false;
        // });

      }
    });
  }

  Future<ConfirmAction> _displayMessage(BuildContext context) async {
    return showDialog<ConfirmAction>(
        context: context,
        barrierDismissible: false,
        builder: (context) {
          return AlertDialog(
            title: Text('Cover Letter'),
            content: TextField(
              maxLines: 3,
              maxLength: 150,
              controller: _textFieldController,
              decoration: InputDecoration(hintText: "Enter message (optional)"),
            ),
            actions: <Widget>[
              FlatButton(
                child: const Text('Cancel'),
                onPressed: () {
                  Navigator.of(context).pop(ConfirmAction.Cancel);
                },
              ),
              FlatButton(
                child: new Text('SUBMIT'),
                onPressed: () {
                  setState(() {
                    covermsg = _textFieldController.text;
                  });
                  Navigator.of(context).pop(ConfirmAction.Accept);
                },
              )
            ],
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Stack(
          children: <Widget>[
            Positioned(
              top: 0,
              left: 0,
              right: 0,
              height: MediaQuery.of(context).size.height / 2,
              child: widget.joblist.iconUrl.isEmpty
                  ? Image.network(
                      "https://cdn.pixabay.com/photo/2015/01/08/18/26/write-593333_960_720.jpg",
                      fit: BoxFit.cover,
                      color: Colors.black38,
                      colorBlendMode: BlendMode.darken,
                    )
                  : Image.network(
                      widget.joblist.iconUrl,
                      fit: BoxFit.cover,
                      color: Colors.black38,
                      colorBlendMode: BlendMode.darken,
                    ),
            ),
            Positioned(
              top: 0,
              left: 0,
              right: 0,
              child: Row(
                children: <Widget>[
                  IconButton(
                    icon: Icon(
                      Icons.chevron_left,
                      color: Colors.white,
                    ),
                    onPressed: () => Navigator.pop(context),
                  ),
                  Spacer(),
                ],
              ),
            ),
            Positioned(
              left: 0,
              right: 0,
              bottom: 0,
              height: MediaQuery.of(context).size.height / 2,
              child: Container(
                padding: const EdgeInsets.all(15.0),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(25),
                    topRight: Radius.circular(25),
                  ),
                ),
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text(
                        widget.joblist.title,
                        style: Theme.of(context).textTheme.headline5,
                      ),
                      Text(
                        widget.joblist.companyname +
                            ", " +
                            widget.joblist.location,
                        style: Theme.of(context)
                            .textTheme
                            .bodyText1
                            .apply(color: Colors.grey),
                      ),
                      SizedBox(
                        height: 25.0,
                      ),
                      Text(
                        "Overview",
                        style: Theme.of(context).textTheme.subtitle1,
                      ),
                      Text(
                        widget.joblist.description,
                        style: Theme.of(context)
                            .textTheme
                            .bodyText1
                            .apply(color: Colors.grey),
                      ),
                      SizedBox(
                        height: 10.0,
                      ),
                      Container(
                        width: MediaQuery.of(context).size.height * .7,
                        height: 45,
                        child: !_isApplied
                            ? RaisedButton(
                                child: Text(
                                  "Apply for this job",
                                  style: Theme.of(context)
                                      .textTheme
                                      .button
                                      .apply(color: Colors.white),
                                ),
                                color: Colors.blue,
                                onPressed: () async {
                                  final ConfirmAction action =
                                      await _displayMessage(context);
                                  print("Confirm Action $action");
                                  if (action == ConfirmAction.Accept) {
                                    _submitForm();
                                  }
                                },
                              )
                            : RaisedButton(
                                child: Text(
                                  "Applied",
                                  style: Theme.of(context)
                                      .textTheme
                                      .button
                                      .apply(color: Colors.white),
                                ),
                                color: Colors.green,
                                onPressed: () {},
                              ),
                      )
                    ],
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
