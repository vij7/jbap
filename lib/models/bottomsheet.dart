import 'package:flutter/material.dart';
import 'package:jobapp/models/job.dart';

class MyBottomSheetModel extends ChangeNotifier {
  bool _visible = false;
  bool _isResult = false;
  List<JobModel> jobresult = [];
  MyBottomSheetModel({this.jobresult});

  get visible => _visible;
  get isResult => _isResult;
  getJobslist() => jobresult;
  void changeState() {
    _visible = !_visible;
    print(_visible);
    notifyListeners();
  }

  void changeResultState() {
    _isResult = true;
    print(_isResult);
    notifyListeners();
  }

  void addJoblist(List<JobModel> job) {
    jobresult = job;

    notifyListeners();
  }
}
