import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:async';
import 'dart:convert';
import 'package:jobapp/constants.dart';

import '../models/login_class.dart';

class LoginService {
  static const _serviceUrl = baseUrl + 'login_employee';
  static final _headers = {'Content-Type': 'application/json'};

  Future<ResMessage> authAccount(User user) async {
    try {
      SharedPreferences preferences = await SharedPreferences.getInstance();
      String json = _toJson(user);
      print(json);
      final response =
          await http.post(_serviceUrl, headers: _headers, body: json);

      String jsonString = response.body;
      var c = _fromJson(jsonString);
      if (c.error == false) {
        Map decodedata = jsonDecode(jsonString);

        print(decodedata);
        if (decodedata != null) {
          final parsed = decodedata['user'];
          String jobseeker = jsonEncode(User.fromJson(parsed));
          preferences.setString('jobseeker', jobseeker);
        }
      }
      return c;
    } catch (e) {
      print('Server Exception.');
      print(e);
      return null;
    }
  }

  ResMessage _fromJson(String jsonReg) {
    print("print jsonreg........................... 2");
    print(jsonReg);
    Map<String, dynamic> map = json.decode(jsonReg);
    var res = new ResMessage();
    res.error = map['error'];
    print(res.error);
    res.message = map['message'];
    print(res.message);
    if (res.error == false) {
      print('//////USER DATA///////////');
      res.token = map['token'];
      print(res.token);
      res.user = _fromuserJson(map['user']);
    } else {
      res.user = null;
    }

    return res;
  }

  User _fromuserJson(Map<String, dynamic> json) {
    print('from user json.....3');
    var usermap = new User();
    usermap.userid = json["user_id"];
    usermap.firstname = json["first_name"];
    usermap.lastname = json["last_name"];
    usermap.phone = json["phone"];
    usermap.email = json["email"];
    usermap.about = json["about"];
    usermap.address = json["address"];
    usermap.city = json["city"];
    usermap.state = json["state"];
    usermap.postcode = json["postcode"];
    usermap.jobtitle = json["job_title"];
    usermap.keywords = json["keywords"];
    usermap.skills = json["skills"];
    usermap.qualification = json["qualification"];
    usermap.experience = json["experience"];
    usermap.ctc = json["ctc"];
    usermap.salaryrange = json["salary_range"];
    usermap.resumeUrl = json["resume"];
    usermap.password = json["password"];
    usermap.category = json["category"];

    return usermap;
  }

  String _toJson(User user) {
    var mapData = new Map();
    mapData["email"] = user.email;
    mapData["password"] = user.password;
    mapData["devicetoken"] = user.userDeviceID;

    String jsonReg = json.encode(mapData);
    return jsonReg;
  }
}
