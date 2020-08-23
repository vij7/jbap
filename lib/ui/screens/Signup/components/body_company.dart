import 'package:flutter/material.dart';

import 'package:flutter_svg/svg.dart';
import 'package:jobapp/constants.dart';
import 'package:jobapp/models/register_class.dart';
import 'package:jobapp/services/company_register_service.dart';
import 'package:jobapp/ui/components/already_have_an_account_acheck.dart';
import 'package:jobapp/ui/components/rounded_button.dart';
import 'package:jobapp/ui/components/rounded_input_field.dart';
import 'package:jobapp/ui/components/rounded_password_field.dart';
import 'package:jobapp/ui/components/terms_and_policy.dart';
import 'package:jobapp/ui/screens/Login/login_screen_company.dart';
import 'package:jobapp/ui/screens/Signup/components/background.dart';
import 'package:jobapp/ui/screens/Signup/components/or_divider.dart';
import 'package:jobapp/ui/screens/Signup/signup_screen.dart';
import 'package:jobapp/ui/screens/Welcome/company_welcome.dart';

class Body extends StatefulWidget {
  @override
  _BodyPageState createState() => _BodyPageState();
}

class _BodyPageState extends State<Body> {
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  final GlobalKey<FormState> _formKey = new GlobalKey<FormState>();

  bool _obscureText = true;
  bool _isLoading = false;

  Registeration newContact = new Registeration();

  bool isValidEmail(String input) {
    final RegExp regex = new RegExp(
        r"^[a-zA-Z0-9.!#$%&'*+/=?^_`{|}~-]+@[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,253}[a-zA-Z0-9])?(?:\.[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,253}[a-zA-Z0-9])?)*$");
    return regex.hasMatch(input);
  }

  void showMessage(String message, [MaterialColor color]) {
    _scaffoldKey.currentState.showSnackBar(
        new SnackBar(backgroundColor: color, content: new Text(message)));
  }

  void _submitForm() {
    final FormState form = _formKey.currentState;

    if (!form.validate()) {
      showMessage('Form is not valid!  Please review and correct.');
    } else {
      form.save(); //This invokes each onSaved event
      setState(() {
        _isLoading = true;
      });
      print('Form save called, newContact is now up to date...');
      print('Name: ${newContact.companyname}');

      print('Email: ${newContact.email}');
      print('Gender: ${newContact.phone}');
      print('Caste: ${newContact.password}');
      print('========================================');
      print('Submitting to back end...');
      var registerService = new CompanyRegisterService();
      registerService.createAccount(newContact).then((value) {
        if (value.error == false) {
          setState(() {
            _isLoading = false;
          });
          Navigator.of(context).pushReplacement(MaterialPageRoute(
              builder: (BuildContext context) => CompanyWelcomeScreen()));
        } else if (value.error == true) {
          setState(() {
            _isLoading = false;
          });
          showMessage(value.message, Colors.red);
        }
      });
    }
  }

  void _toggle() {
    setState(() {
      _obscureText = !_obscureText;
    });
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      key: _scaffoldKey,
      body: Background(
        child: SingleChildScrollView(
          child: new Form(
            key: _formKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Text(
                  "COMPANY SIGNUP",
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                SizedBox(height: size.height * 0.03),
                SvgPicture.asset(
                  "assets/icons/signup.svg",
                  height: size.height * 0.25,
                ),
                RoundedInputField(
                  hintText: "Company Name",
                  icon: Icons.home,
                  color: kSecondaryLightColor,
                  iconcolor: kSecondaryColor,
                  keyboardType: TextInputType.text,
                  validator: (val) =>
                      val.isEmpty ? 'Company Name is required' : null,
                  onSaved: (String val) {
                    newContact.companyname = val;
                    newContact.firstname = '';
                    newContact.lastname = '';
                  },
                ),
                RoundedInputField(
                  hintText: "Contact Number",
                  color: kSecondaryLightColor,
                  iconcolor: kSecondaryColor,
                  keyboardType: TextInputType.phone,
                  validator: (val) =>
                      val.isEmpty ? 'Contact Number is required' : null,
                  icon: Icons.phone,
                  onSaved: (String val) {
                    newContact.phone = val;
                  },
                ),
                RoundedInputField(
                  hintText: "Your Email",
                  color: kSecondaryLightColor,
                  iconcolor: kSecondaryColor,
                  icon: Icons.email,
                  keyboardType: TextInputType.emailAddress,
                  validator: (value) => isValidEmail(value)
                      ? null
                      : 'Please enter a valid email address',
                  onSaved: (String val) {
                    newContact.email = val;
                  },
                ),
                RoundedPasswordField(
                  onChanged: (value) {},
                  color: kSecondaryLightColor,
                  iconcolor: kSecondaryColor,
                  onPressed: _toggle,
                  obscureText: _obscureText,
                  validator: (val) =>
                      val.isEmpty ? 'Password is required' : null,
                  onSaved: (String val) {
                    newContact.password = val;
                  },
                ),
                TermsAndCondition(
                  color: kSecondaryColor,
                ),
                !_isLoading
                    ? RoundedButton(
                        color: kSecondaryColor,
                        text: "SIGNUP",
                        press: _submitForm,
                      )
                    : Center(
                        child: CircularProgressIndicator(
                            valueColor: new AlwaysStoppedAnimation<Color>(
                                kSecondaryColor)),
                      ),
                SizedBox(height: size.height * 0.03),
                AlreadyHaveAnAccountCheck(
                  color: kSecondaryColor,
                  login: false,
                  press: () {
                    Navigator.pushAndRemoveUntil(
                        context,
                        MaterialPageRoute(
                            builder: (BuildContext context) =>
                                LoginScreenCompany()),
                        (r) => false);
                  },
                ),
                OrDivider(color: kSecondaryColor),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    RoundedButton(
                      text: "REGISTER AS JOB SEEKER",
                      press: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) {
                              return SignUpScreen();
                            },
                          ),
                        );
                      },
                    ),
                  ],
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
