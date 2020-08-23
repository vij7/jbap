import 'package:http/http.dart' as http;
import 'package:jobapp/constants.dart';
import 'dart:async';
import 'dart:convert';

import 'package:jobapp/models/register_class.dart';

class CompanyRegisterService {
  static const _serviceUrl = baseUrl + 'register_company';
  static final _headers = {'Content-Type': 'application/json'};

  Future<Registeration> createAccount(Registeration reg) async {
    try {
      String json = _toJson(reg);
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

  Registeration _fromJson(String jsonReg) {
    // print("print jsonreg...........................");
    // print(jsonReg);
    Map<String, dynamic> map = json.decode(jsonReg);
    var reg = new Registeration();
    reg.error = map['error'];
    reg.message = map['message'];

    return reg;
  }

  String _toJson(Registeration reg) {
    var mapData = new Map();
    mapData["first_name"] = reg.firstname;
    mapData["last_name"] = reg.lastname;
    mapData["company_name"] = reg.companyname;
    mapData["email"] = reg.email;
    mapData["phone"] = reg.phone;
    mapData["password"] = reg.password;
    String jsonReg = json.encode(mapData);
    return jsonReg;
  }
}
