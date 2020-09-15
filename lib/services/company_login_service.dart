import 'package:http/http.dart' as http;
import 'package:jobapp/constants.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:async';
import 'dart:convert';
// import 'package:intl/intl.dart';

import '../models/login_company_class.dart';

class LoginService {
  static const _serviceUrl = baseUrl + 'login_company';
  static final _headers = {'Content-Type': 'application/json'};

  Future<ResMessage> authAccount(Company company) async {
    try {
      SharedPreferences preferences = await SharedPreferences.getInstance();
      String json = _toJson(company);
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
          print('here');
          print(parsed);
          String company = jsonEncode(Company.fromJson(parsed));
          print(company);
          print('here 3');
          preferences.setString('company', company);
        }
      }

      return c;
      // print(jsonDecode(response.body));
      //  return response;

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
      res.company = _fromuserJson(map['user']);
    } else {
      res.company = null;
    }

    return res;
  }

  Company _fromuserJson(Map<String, dynamic> json) {
    print('from user json.....3');
    var companymap = new Company();
    companymap.userid = json["user_id"];
    companymap.firstname = json["first_name"];
    companymap.lastname = json["last_name"];
    companymap.phone = json["phone"];
    companymap.email = json["email"];
    companymap.companyname = json["company_name"];
    companymap.location = json["location"];
    companymap.logo = json["logo"];
    companymap.about = json["about_company"];
    companymap.isPremium = json["is_premium"];
    companymap.isVerified = json["is_verified"];
    print(companymap.email);

    return companymap;
  }

  String _toJson(Company company) {
    var mapData = new Map();
    mapData["email"] = company.email;
    mapData["password"] = company.password;
    mapData["devicetoken"] = company.userDeviceID;

    String jsonReg = json.encode(mapData);
    return jsonReg;
  }
}
