import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class TermsAndCondition extends StatelessWidget {
  final Color color;
  const TermsAndCondition({
    Key key,
    this.color,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Text(
          "I accept the ",
          style: TextStyle(color: color),
        ),
        GestureDetector(
          onTap: () {
            launch('http://starwingjobs.com/terms');
          },
          child: Text(
            "terms of service",
            style: TextStyle(
              color: color,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        Text(
          " & ",
          style: TextStyle(color: color),
        ),
        GestureDetector(
          onTap: () {
            launch('http://starwingjobs.com/privacy');
          },
          child: Text(
            "privacy policy",
            style: TextStyle(
              color: color,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ],
    );
  }
}
