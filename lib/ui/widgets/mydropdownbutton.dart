import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:jobapp/constants.dart';
import 'package:http/http.dart' as http;

class MyDropDownButton extends StatefulWidget {
  final ValueChanged<String> onSaved;
  final ValueChanged<String> onChanged;
  final String value;
  const MyDropDownButton({
    Key key,
    this.onSaved,
    this.onChanged,
    this.value,
  }) : super(key: key);

  @override
  _MyDropDownButtonState createState() => _MyDropDownButtonState();
}

class _MyDropDownButtonState extends State<MyDropDownButton> {
  // String _myInterest = '1';
  final String url = baseUrl + "category_list";

  List<dynamic> data = List(); //edited line

  Future<String> getSWData() async {
    var res = await http
        .get(Uri.encodeFull(url), headers: {"Accept": "application/json"});

    Map<String, dynamic> map = json.decode(res.body);
    List<dynamic> dataitem = map["categories"];

    setState(() {
      data = dataitem;
    });

    // print(data);

    return "Success";
  }

  @override
  void initState() {
    super.initState();
    this.getSWData();
  }

  @override
  Widget build(BuildContext context) {
    return DropdownButton(
      underline: Container(),
      // onChanged: (String newVal) {
      //   setState(() {
      //     _myInterest = newVal;
      //     // state.didChange(newVal);
      //   });
      // },
      onChanged: widget.onChanged,
      value: widget.value,
      items: data.map((item) {
        return new DropdownMenuItem(
          value: item['id'].toString(),
          child: new Text(
            item['name'],
            overflow: TextOverflow.fade,
            style: new TextStyle(fontWeight: FontWeight.bold, fontSize: 10.0),
          ),
        );
      }).toList(),
    );
  }
}
