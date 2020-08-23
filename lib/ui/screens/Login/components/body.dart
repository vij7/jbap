import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:jobapp/constants.dart';
import 'package:jobapp/services/login_service.dart';
import 'package:jobapp/ui/components/forgotpassword.dart';
import 'package:jobapp/ui/components/sendmailbody.dart';
import 'package:jobapp/ui/screens/profile.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:flutter_svg/svg.dart';
import 'package:jobapp/models/bottomsheet.dart';
import 'package:jobapp/models/login_class.dart';
import 'package:jobapp/ui/components/already_have_an_account_acheck.dart';
import 'package:jobapp/ui/components/rounded_button.dart';
import 'package:jobapp/ui/components/rounded_input_field.dart';
import 'package:jobapp/ui/components/rounded_password_field.dart';
import 'package:jobapp/ui/screens/Login/components/background.dart';

import 'package:jobapp/ui/screens/Login/login_screen_company.dart';
import 'package:jobapp/ui/screens/Signup/components/or_divider.dart';
import 'package:jobapp/ui/screens/Signup/signup_screen.dart';
import 'package:jobapp/ui/screens/home.dart';
import 'package:provider/provider.dart';

class Body extends StatefulWidget {
  const Body({
    Key key,
  }) : super(key: key);

  @override
  _BodyState createState() => _BodyState();
}

class _BodyState extends State<Body> {
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  final GlobalKey<FormState> _formKey = new GlobalKey<FormState>();

  List<User> userList;
  bool _obscureText = true;
  bool _isLoading = false;

  User userDetails = new User();

  bool isValidEmail(String input) {
    final RegExp regex = new RegExp(
        r"^[a-zA-Z0-9.!#$%&'*+/=?^_`{|}~-]+@[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,253}[a-zA-Z0-9])?(?:\.[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,253}[a-zA-Z0-9])?)*$");
    return regex.hasMatch(input);
  }

  void showMessage(String message, [MaterialColor color = Colors.red]) {
    print('showmsg');
    print(message);
    _scaffoldKey.currentState.showSnackBar(
        new SnackBar(backgroundColor: color, content: new Text(message)));
  }

  void _submitForm() {
    final FormState form = _formKey.currentState;
    if (!form.validate()) {
      showMessage('Form is not valid! Please review and correct.');
    } else {
      form.save(); //This invokes each onSaved event
      setState(() {
        _isLoading = true;
      });
      print('Form save called, newContact is now up to date...');
      print('Username: ${userDetails.email}');
      print('Password: ${userDetails.password}');
      print('========================================');
      print('Submitting to back end...');
      var loginService = new LoginService();
      var data = loginService.authAccount(userDetails);
      data.then((value) {
        setState(() {
          _isLoading = false;
        });
        print('.................5..........');
        print(value.message);
        if (value.error == false) {
          _saveLogindata(value.user.userid, value.token);
          if (value.user.about == null) {
            Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(
                    builder: (BuildContext context) => Profile(
                          userinfo: value.user,
                          companyinfo: null,
                        )),
                (r) => false);
          } else {
            Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(
                    builder: (context) =>
                        ChangeNotifierProvider<MyBottomSheetModel>(
                            create: (_) => MyBottomSheetModel(),
                            builder: (context, child) => HomeScreen())),
                (r) => false);
          }
        } else if (value.error == true) {
          showMessage(value.message, Colors.red);
        }
        print('---------------------------');
      });
    }
  }

  _saveLogindata(String userid, String token) async {
    var prefs = await SharedPreferences.getInstance();

    prefs?.setBool("isLoggedIn", true);
    prefs?.setBool("isJobseeker", true);
    prefs.setString('token', token);
    prefs.setString('userid', userid);
  }

  void _toggle() {
    setState(() {
      _obscureText = !_obscureText;
    });
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
                  "JOB SEEKER LOGIN",
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                SizedBox(height: size.height * 0.03),
                SvgPicture.asset(
                  "assets/icons/login.svg",
                  height: size.height * 0.35,
                ),
                SizedBox(height: size.height * 0.03),
                RoundedInputField(
                  icon: Icons.person,
                  hintText: "Your Email",
                  validator: (val) =>
                      val.isEmpty ? 'Email id is required' : null,
                  onSaved: (String val) {
                    userDetails.email = val;
                  },
                ),
                RoundedPasswordField(
                  onPressed: _toggle,
                  obscureText: _obscureText,
                  validator: (val) =>
                      val.isEmpty ? 'Password is required' : null,
                  onSaved: (val) => userDetails.password = val,
                ),
                !_isLoading
                    ? RoundedButton(
                        text: "LOGIN",
                        press: _submitForm,
                      )
                    : Center(
                        child: CircularProgressIndicator(
                            valueColor: new AlwaysStoppedAnimation<Color>(
                                kPrimaryColor)),
                      ),
                SizedBox(height: size.height * 0.02),
                ForgotPasswordCheck(
                  color: kPrimaryColor,
                  press: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) {
                          return SendMailBody(
                            jobseeker: true,
                          );
                        },
                      ),
                    );
                  },
                ),
                SizedBox(height: size.height * 0.03),
                AlreadyHaveAnAccountCheck(
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
                OrDivider(),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    RoundedButton(
                      color: kSecondaryColor,
                      text: "LOGIN AS COMPANY",
                      press: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) {
                              return LoginScreenCompany();
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
