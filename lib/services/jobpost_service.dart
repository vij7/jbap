import 'package:http/http.dart' as http;
import 'package:jobapp/constants.dart';
import 'package:jobapp/models/job.dart';
import 'dart:async';
import 'dart:convert';

class JobPostService {
  static const _serviceUrl = baseUrl + 'postjob';
  static final _headers = {
    "Accept": "application/json",
    "Content-Type": "application/x-www-form-urlencoded"
  };

  Future<JobModel> postJob(JobModel reg) async {
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

  JobModel _fromJson(String jsonReg) {
    Map<String, dynamic> map = json.decode(jsonReg);
    var reg = new JobModel();
    reg.error = map['error'];
    reg.message = map['message'];

    return reg;
  }

  Map<dynamic, dynamic> _toJson(JobModel reg) {
    var mapData = new Map();
    mapData["title"] = reg.title;
    mapData["description"] = reg.description;
    mapData["from_salary"] = reg.salaryFrom;
    mapData["to_salary"] = reg.salaryTo;
    mapData["company_id"] = reg.companyid;
    mapData["category"] = reg.category;
    return mapData;
  }
}
