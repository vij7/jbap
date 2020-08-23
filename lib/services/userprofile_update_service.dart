import 'package:http/http.dart' as http;
import 'package:jobapp/constants.dart';
import 'dart:async';
import 'dart:convert';

import 'package:jobapp/models/login_class.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ProfileUpdateService {
  static const _serviceUrl = baseUrl + 'employeeprofileupdate';
  static final _headers = {
    "Accept": "application/json",
    "Content-Type": "application/x-www-form-urlencoded"
  };

  Future<ResMessage> updateProfile(User reg) async {
    try {
      SharedPreferences preferences = await SharedPreferences.getInstance();
      Map json = _toJson(reg);
      // print(json);
      final response =
          await http.post(_serviceUrl, headers: _headers, body: json);
      print(response.body);
      if (response.statusCode == 200) {
        var c = _fromJson(response.body);
        if (c.error == false) {
          String jsonString = _toJsonforsave(reg);
          Map decodedata = jsonDecode(jsonString);
          final parsed = decodedata;
          String jobseeker = jsonEncode(User.fromJson(parsed));
          preferences.setString('jobseeker', jobseeker);
        }
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

  ResMessage _fromJson(String jsonReg) {
    // print("print jsonreg...........................");
    // print(jsonReg);
    Map<String, dynamic> map = json.decode(jsonReg);
    var reg = new ResMessage();
    reg.error = map['error'];
    reg.message = map['message'];

    return reg;
  }

  Map<dynamic, dynamic> _toJson(User reg) {
    var mapData = new Map();
    mapData["user_id"] = reg.userid;
    mapData["first_name"] = reg.firstname;
    mapData["last_name"] = reg.lastname;
    mapData["phone"] = reg.phone;
    mapData["address"] = reg.address;
    mapData["city"] = reg.city;
    mapData["state"] = reg.state;
    mapData["postcode"] = reg.postcode;
    mapData["job_title"] = reg.jobtitle;
    mapData["keywords"] = reg.keywords;
    mapData["skills"] = reg.skills;
    mapData["qualification"] = reg.qualification;
    mapData["experience"] = reg.experience;
    mapData["ctc"] = reg.ctc;
    mapData["salary_range"] = reg.salaryrange;
    mapData["about"] = reg.about;
    mapData["category"] = reg.category;
    print('printing mapdata');
    print(mapData);
    return mapData;
  }

  String _toJsonforsave(User reg) {
    var mapData = new Map();
    mapData["user_id"] = reg.userid;
    mapData["first_name"] = reg.firstname;
    mapData["last_name"] = reg.lastname;
    mapData["email"] = reg.email;
    mapData["phone"] = reg.phone;
    mapData["address"] = reg.address;
    mapData["city"] = reg.city;
    mapData["state"] = reg.state;
    mapData["postcode"] = reg.postcode;
    mapData["job_title"] = reg.jobtitle;
    mapData["keywords"] = reg.keywords;
    mapData["skills"] = reg.skills;
    mapData["qualification"] = reg.qualification;
    mapData["experience"] = reg.experience;
    mapData["ctc"] = reg.ctc;
    mapData["salary_range"] = reg.salaryrange;
    mapData["about"] = reg.about;
    mapData["category"] = reg.category;
    String jsonReg = json.encode(mapData);
    return jsonReg;
  }
}
