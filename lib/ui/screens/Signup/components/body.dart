import 'package:flutter/material.dart';

import 'package:flutter_svg/svg.dart';
import 'package:jobapp/constants.dart';
import 'package:jobapp/models/register_class.dart';
import 'package:jobapp/services/register_service.dart';
import 'package:jobapp/ui/components/already_have_an_account_acheck.dart';
import 'package:jobapp/ui/components/rounded_button.dart';
import 'package:jobapp/ui/components/rounded_input_field.dart';
import 'package:jobapp/ui/components/rounded_password_field.dart';
import 'package:jobapp/ui/components/terms_and_policy.dart';
import 'package:jobapp/ui/screens/Login/login_screen.dart';
import 'package:jobapp/ui/screens/Signup/components/background.dart';
import 'package:jobapp/ui/screens/Signup/components/or_divider.dart';
import 'package:jobapp/ui/screens/Signup/signup_screen_company.dart';

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

  void showMessage(String message, [MaterialColor color = Colors.red]) {
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
      print('Name: ${newContact.firstname}');
      print('Dob: ${newContact.lastname}');
      print('Email: ${newContact.email}');
      print('Gender: ${newContact.phone}');
      print('Caste: ${newContact.password}');
      print('========================================');
      print('Submitting to back end...');
      var registerService = new RegisterService();
      registerService.createAccount(newContact).then((value) {
        if (value.error == false) {
          print("error false");
          setState(() {
            _isLoading = false;
          });
          showMessage(
              'New Account created for ${newContact.firstname}!', Colors.green);
        } else if (value.error == true) {
          print("error true");
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
                  "JOB SEEKER SIGNUP",
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                SizedBox(height: size.height * 0.03),
                SvgPicture.asset(
                  "assets/icons/signup.svg",
                  height: size.height * 0.20,
                ),
                RoundedInputField(
                  hintText: "First Name",
                  icon: Icons.person,
                  keyboardType: TextInputType.text,
                  validator: (val) =>
                      val.isEmpty ? 'First Name is required' : null,
                  onSaved: (String val) {
                    newContact.firstname = val;
                  },
                ),
                RoundedInputField(
                  hintText: "Last Name",
                  icon: Icons.person,
                  keyboardType: TextInputType.text,
                  validator: (val) =>
                      val.isEmpty ? 'Last Name is required' : null,
                  onSaved: (String val) {
                    newContact.lastname = val;
                  },
                ),
                RoundedInputField(
                  hintText: "Phone",
                  icon: Icons.phone,
                  keyboardType: TextInputType.phone,
                  validator: (val) =>
                      val.isEmpty ? 'Phone Number is required' : null,
                  onSaved: (String val) {
                    newContact.phone = val;
                  },
                ),
                RoundedInputField(
                  hintText: "Your Email",
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
                  onPressed: _toggle,
                  obscureText: _obscureText,
                  validator: (val) =>
                      val.isEmpty ? 'Password is required' : null,
                  onSaved: (String val) {
                    newContact.password = val;
                  },
                ),
                TermsAndCondition(
                  color: kPrimaryColor,
                ),
                SizedBox(height: size.height * 0.01),
                !_isLoading
                    ? RoundedButton(
                        text: "SIGNUP",
                        press: _submitForm,
                      )
                    : Center(
                        child: CircularProgressIndicator(
                            valueColor: new AlwaysStoppedAnimation<Color>(
                                kPrimaryColor)),
                      ),
                SizedBox(height: size.height * 0.02),
                AlreadyHaveAnAccountCheck(
                  login: false,
                  press: () {
                    Navigator.pushAndRemoveUntil(
                        context,
                        MaterialPageRoute(
                            builder: (BuildContext context) => LoginScreen()),
                        (r) => false);
                  },
                ),
                OrDivider(),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    RoundedButton(
                      color: kSecondaryColor,
                      text: "REGISTER AS COMPANY",
                      press: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) {
                              return SignUpScreenCompany();
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
