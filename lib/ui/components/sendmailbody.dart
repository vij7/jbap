import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:jobapp/constants.dart';
import 'package:jobapp/models/register_class.dart';
import 'package:jobapp/ui/components/rounded_button.dart';
import 'package:jobapp/ui/components/rounded_input_field.dart';
import 'package:jobapp/ui/components/rounded_password_field.dart';
import 'package:jobapp/ui/screens/Login/components/background.dart';
import 'package:jobapp/ui/screens/Login/login_screen.dart';
import 'package:jobapp/ui/screens/Login/login_screen_company.dart';

class SendMailBody extends StatefulWidget {
  final Color color;
  final bool jobseeker;
  SendMailBody({Key key, this.color, this.jobseeker}) : super(key: key);

  @override
  _BodyState createState() => _BodyState();
}

class _BodyState extends State<SendMailBody> {
  bool _isLoading = false;
  bool _isVisible = true;
  bool _isMsg = false;
  bool _obscureText = true;
  bool _isVerified = false;
  bool _isSuccess = false;
  String alertmessage = '';
  String code;
  String userid;
  String type;

  Registeration reg = new Registeration();
  final GlobalKey<FormState> _formKey = new GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    if (widget.jobseeker == true) {
      type = "employee";
    } else {
      type = "company";
    }
  }

  void _toggle() {
    setState(() {
      _obscureText = !_obscureText;
    });
  }

  Future<void> submitForm() async {
    setState(() {
      _isLoading = true;
    });

    final FormState form = _formKey.currentState;
    if (!form.validate()) {
      setState(() {
        _isMsg = true;
        _isLoading = false;
        alertmessage = "Form is not valid! Please review and correct.";
      });
    } else {
      form.save();

      setState(() {
        _isMsg = false;
      });

      String url;

      if (widget.jobseeker == true) {
        url = baseUrl + 'sendVerificationcodeEmployees';
      } else {
        url = baseUrl + 'sendVerificationcodeCompanies';
      }

      try {
        FormData formData = new FormData.fromMap({
          "email": reg.email,
        });

        Response response = await Dio().post(url, data: formData);
        print("response: $response");

        final Map<String, dynamic> responseData = json.decode(response.data);
        bool error = responseData['error'];
        String message = responseData['message'];
        if (error == false) {
          setState(() {
            _isLoading = false;
            _isVisible = false;
          });
        } else {
          setState(() {
            _isLoading = false;
            alertmessage = message;
            _isMsg = true;
          });
        }
      } catch (e) {
        print("Exception Caught: $e");
      }
    }
  }

  Future<void> submitVerificationForm() async {
    setState(() {
      _isLoading = true;
    });

    final FormState form = _formKey.currentState;
    if (!form.validate()) {
      setState(() {
        _isMsg = true;
        _isLoading = false;
        alertmessage = "Form is not valid! Please review and correct.";
      });
    } else {
      form.save();
      setState(() {
        _isMsg = false;
        alertmessage = '';
      });
      try {
        FormData formData =
            new FormData.fromMap({"verification_code": code, "type": type});

        print(formData.fields);

        Response response = await Dio()
            .post(baseUrl + 'validateVerificationcode', data: formData);
        print("response: $response");

        final Map<String, dynamic> responseData = json.decode(response.data);
        bool error = responseData['error'];
        String message = responseData['message'];
        if (error == false) {
          setState(() {
            _isLoading = false;
            _isVerified = true;
            userid = responseData['user_id'];
            _isMsg = false;
          });
        } else {
          setState(() {
            _isLoading = false;
            alertmessage = message;
            _isMsg = true;
          });
        }
      } catch (e) {
        print("Exception Caught: $e");
      }
    }
  }

  Future<void> submitResetForm() async {
    setState(() {
      _isLoading = true;
    });

    final FormState form = _formKey.currentState;
    if (!form.validate()) {
      setState(() {
        _isMsg = true;
        _isLoading = false;
        alertmessage = "Form is not valid! Please review and correct.";
      });
    } else {
      form.save();
      setState(() {
        _isMsg = false;
      });
      try {
        FormData formData = new FormData.fromMap(
            {"user_id": userid, "password": reg.password, "type": type});
        print(formData.fields);
        Response response =
            await Dio().post(baseUrl + 'updatePassword', data: formData);
        print("response: $response");

        final Map<String, dynamic> responseData = json.decode(response.data);
        bool error = responseData['error'];
        String message = responseData['message'];
        if (error == false) {
          setState(() {
            _isLoading = false;
            _isSuccess = true;
            _isMsg = false;
          });
        } else {
          setState(() {
            _isLoading = false;
            alertmessage = message;
            _isMsg = true;
          });
        }
      } catch (e) {
        print("Exception Caught: $e");
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      body: Background(
        child: SingleChildScrollView(
          child: new Form(
            key: _formKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                SvgPicture.asset(
                  "assets/icons/forgot.svg",
                  height: size.height * 0.30,
                ),
                SizedBox(height: size.height * 0.03),
                //for email verification
                Visibility(
                    visible: _isVisible,
                    child: Column(children: <Widget>[
                      Text(
                        "FORGOT PASSWORD ?",
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      SizedBox(height: size.height * 0.03),
                      RoundedInputField(
                        icon: Icons.person,
                        hintText: "Enter Your Email",
                        validator: (val) =>
                            val.isEmpty ? 'Email id is required' : null,
                        onSaved: (String val) {
                          reg.email = val;
                        },
                      ),
                      !_isLoading
                          ? RoundedButton(
                              text: "SUBMIT",
                              press: submitForm,
                            )
                          : Center(
                              child: CircularProgressIndicator(
                                  valueColor: new AlwaysStoppedAnimation<Color>(
                                      kPrimaryColor)),
                            ),
                    ])),
                //for code verification
                Visibility(
                    visible: _isVerified ? false : !_isVisible,
                    child: Column(children: <Widget>[
                      Text(
                        "Verification code sent to registered email id.",
                        style: TextStyle(color: Colors.green),
                      ),
                      SizedBox(height: size.height * 0.02),
                      Text(
                        "Enter 4 digit Verification Code",
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      SizedBox(height: size.height * 0.03),
                      RoundedInputField(
                        icon: null,
                        hintText: "Enter Code",
                        validator: (val) =>
                            val.isEmpty ? 'Code is required' : null,
                        onSaved: (String val) {
                          code = val;
                        },
                      ),
                      RoundedButton(
                        text: "VERIFY",
                        press: submitVerificationForm,
                      ),
                    ])),
                //for reset password
                Visibility(
                    visible: _isVerified,
                    child: Column(children: <Widget>[
                      Text(
                        "Enter New Password",
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      SizedBox(height: size.height * 0.03),
                      RoundedPasswordField(
                        onPressed: _toggle,
                        obscureText: _obscureText,
                        validator: (val) =>
                            val.isEmpty ? 'Password is required' : null,
                        onSaved: (val) => reg.password = val,
                      ),
                      RoundedButton(
                        text: "SUBMIT",
                        press: submitResetForm,
                      ),
                    ])),
                SizedBox(height: size.height * 0.03),
                Visibility(
                  visible: _isMsg,
                  child: Text(
                    "$alertmessage",
                    style: TextStyle(color: Colors.red),
                  ),
                ),
                //for reset password
                Visibility(
                    visible: _isSuccess,
                    child: Column(children: <Widget>[
                      Text(
                        "Password Updated Successfully",
                        style: TextStyle(
                            fontWeight: FontWeight.bold, color: Colors.green),
                      ),
                      SizedBox(height: size.height * 0.03),
                      RoundedButton(
                        color: Colors.grey[850],
                        text: "BACK TO LOGIN",
                        press: () {
                          if (type == "employee") {
                            Navigator.pushAndRemoveUntil(
                                context,
                                MaterialPageRoute(
                                    builder: (BuildContext context) =>
                                        LoginScreen()),
                                (r) => false);
                          } else if (type == "company") {
                            Navigator.pushAndRemoveUntil(
                                context,
                                MaterialPageRoute(
                                    builder: (BuildContext context) =>
                                        LoginScreenCompany()),
                                (r) => false);
                          }
                        },
                      ),
                    ])),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
