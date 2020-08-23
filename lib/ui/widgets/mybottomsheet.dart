import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:jobapp/constants.dart';
import 'package:jobapp/models/bottomsheet.dart';
import 'package:jobapp/models/job.dart';
import 'package:provider/provider.dart';

class MyBottomSheet extends StatefulWidget {
  @override
  _MyBottomSheetState createState() => _MyBottomSheetState();
}

class JobTypes {
  String id;
  String title;
  bool checked;
  // final int count;

  JobTypes({this.id, this.title, this.checked});
}

class _MyBottomSheetState extends State<MyBottomSheet> {
  bool _isResult = false;
  bool get isResult => _isResult;
  List<JobTypes> jobTypes = List();
  List<JobModel> jobs = List();
  RangeValues _rangeValues = RangeValues(5000, 80000);
  String _salaryFrom;
  String _salaryTo;
  String ids;

  void getSWData() async {
    Response response = await Dio().get(baseUrl + 'category_list');
    print(response.data.toString());
    Map<String, dynamic> map = json.decode(response.data);
    List<dynamic> dataitem = map["categories"];

    for (int i = 0; i < 10; i++) {
      var jobcategory = new JobTypes();
      jobcategory.id = dataitem[i]['id'].toString();
      jobcategory.title = dataitem[i]['name'].toString();
      jobcategory.checked = false;
      jobTypes.add(jobcategory);
    }
  }

  var tmpArray = [];

  getCheckboxItems() {
    ids = '';
    jobTypes.forEach((element) {
      if (element.checked == true) {
        tmpArray.add(element.id);
        ids += element.id + ",";
      }
    });

    // Printing all selected items on Terminal screen.
    print(tmpArray);
    print(ids);
    // Here you will get all your selected Checkbox items.

    // Clear array after use.
  }

  void _submitForm() async {
    getCheckboxItems();

    try {
      FormData formData = new FormData.fromMap({
        "from_salary": _salaryFrom,
        "to_salary": _salaryTo,
        "category": tmpArray
      });

      // print(formData.fields);

      Response response =
          await Dio().post(baseUrl + 'jobsearch', data: formData);

      tmpArray.clear();

      final Map<String, dynamic> responseData = json.decode(response.data);
      if (responseData.containsKey('jobs')) {
        final parsed = responseData['jobs'];

        jobs = parsed.map<JobModel>((json) => JobModel.fromJson(json)).toList();

        Provider.of<MyBottomSheetModel>(context, listen: false)
            .addJoblist(jobs);
      } else if (responseData.containsKey('error')) {
        Provider.of<MyBottomSheetModel>(context, listen: false)
            .addJoblist(null);
      }
      Provider.of<MyBottomSheetModel>(context, listen: false)
          .changeResultState();
      Provider.of<MyBottomSheetModel>(context, listen: false).changeState();
    } catch (e) {
      print("Exception Caught: $e");
    }
  }

  @override
  void initState() {
    super.initState();
    this.getSWData();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(15.0),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(25.0),
          topRight: Radius.circular(25.0),
        ),
      ),
      child: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            Text(
              "Salary Estimate",
              style: Theme.of(context).textTheme.headline6,
            ),
            SliderTheme(
              data: SliderThemeData(
                showValueIndicator: ShowValueIndicator.always,
              ),
              child: RangeSlider(
                divisions: 20,
                min: 0,
                max: 200000,
                values: _rangeValues,
                onChanged: (rangeValue) {
                  setState(() {
                    if (rangeValue.end.round() - rangeValue.start.round() >=
                        20) {
                      _rangeValues = rangeValue;
                    } else {
                      if (_rangeValues.start.round() ==
                          rangeValue.start.round()) {
                        _rangeValues = RangeValues(
                            _rangeValues.start.roundToDouble(),
                            _rangeValues.start.roundToDouble() + 20);
                      } else {
                        _rangeValues = RangeValues(
                            _rangeValues.end.roundToDouble() - 20,
                            _rangeValues.end.roundToDouble());
                      }
                    }
                    _salaryFrom = _rangeValues.start.round().toString();
                    _salaryTo = _rangeValues.end.round().toString();
                  });
                },
                labels: RangeLabels(_rangeValues.start.round().toString(),
                    _rangeValues.end.round().toString()),
              ),
            ),
            Text(
              "Job Type",
              style: Theme.of(context).textTheme.headline6,
            ),
            GridView.count(
              // primary: false,
              scrollDirection: Axis.vertical,
              shrinkWrap: true,
              childAspectRatio: 4.0,
              crossAxisCount: 2,
              children: List.generate(
                jobTypes.length,
                (i) {
                  return Row(
                    children: <Widget>[
                      Checkbox(
                        value: jobTypes[i].checked,
                        onChanged: (value) {
                          setState(() {
                            jobTypes[i].checked = value;
                          });
                        },
                      ),
                      Text(
                        "${jobTypes[i].title}",
                        style: TextStyle(
                          fontSize: 9.0,
                        ),
                        overflow: TextOverflow.fade,
                      ),
                    ],
                  );
                },
              ),
            ),
            Container(
              height: 40,
              width: double.infinity,
              margin: EdgeInsets.symmetric(horizontal: 25.0),
              child: RaisedButton(
                color: Colors.blue,
                child: Text(
                  "Submit",
                  style: Theme.of(context)
                      .textTheme
                      .button
                      .apply(color: Colors.white),
                ),
                onPressed: () {
                  _submitForm();
                },
              ),
            )
          ],
        ),
      ),
    );
  }
}
