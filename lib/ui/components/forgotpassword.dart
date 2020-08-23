import 'package:flutter/material.dart';

class ForgotPasswordCheck extends StatelessWidget {
  final Function press;
  final Color color;
  const ForgotPasswordCheck({
    Key key,
    this.press,
    this.color,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        GestureDetector(
          onTap: press,
          child: Text(
            "Forgot Password ?",
            style: TextStyle(
              color: color,
              fontWeight: FontWeight.bold,
            ),
          ),
        )
      ],
    );
  }
}
