import 'package:http/http.dart' as http;
import 'package:jobapp/constants.dart';
import 'dart:async';
import 'dart:convert';

import 'package:jobapp/models/jobapply.dart';

class JobApplyService {
  static const _serviceUrl = baseUrl + 'applyjob';
  static final _headers = {
    "Accept": "application/json",
    "Content-Type": "application/x-www-form-urlencoded"
  };

  Future<JobApply> postJob(JobApply reg) async {
    try {
      Map json = _toJson(reg);
      print(json);
      final response =
          await http.post(_serviceUrl, headers: _headers, body: json);
      print(response.body);
      if (response.statusCode == 200) {
        var c = _fromJson(response.body);
        return c;
      } else {
        print(response.statusCode);
        return null;
      }
    } catch (e) {
      print('Server Exception.');
      print(e);
      return null;
    }
  }

  JobApply _fromJson(String jsonReg) {
    // print("print jsonreg...........................");
    // print(jsonReg);
    Map<String, dynamic> map = json.decode(jsonReg);
    var reg = new JobApply();
    reg.error = map['error'];
    reg.message = map['errmsg'];

    return reg;
  }

  Map<dynamic, dynamic> _toJson(JobApply reg) {
    var mapData = new Map();
    mapData["user_id"] = reg.userid;
    mapData["job_id"] = reg.jobid;
    mapData["message"] = reg.message;
    print('printing mapdata');
    print(mapData);
    // String jsonReg = json.encode(mapData);
    return mapData;
  }
}
