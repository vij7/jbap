import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';

import 'package:flutter_svg/svg.dart';
import 'package:jobapp/constants.dart';
import 'package:jobapp/models/bottomsheet.dart';
import 'package:jobapp/models/login_company_class.dart';
import 'package:jobapp/services/company_login_service.dart';
import 'package:jobapp/ui/components/already_have_an_account_acheck.dart';
import 'package:jobapp/ui/components/forgotpassword.dart';
import 'package:jobapp/ui/components/rounded_button.dart';
import 'package:jobapp/ui/components/rounded_input_field.dart';
import 'package:jobapp/ui/components/rounded_password_field.dart';
import 'package:jobapp/ui/components/sendmailbody.dart';
import 'package:jobapp/ui/screens/Login/components/background.dart';
import 'package:jobapp/ui/screens/Signup/components/or_divider.dart';
import 'package:jobapp/ui/screens/Signup/signup_screen_company.dart';
import 'package:jobapp/ui/screens/home.dart';
import 'package:jobapp/ui/screens/profile.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:jobapp/ui/screens/Welcome/company_welcome.dart';

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
  // DeviceInfoPlugin deviceInfo =
  //     DeviceInfoPlugin(); // instantiate device info plugin
  // AndroidDeviceInfo androidDeviceInfo;

  List<String> companyList;
  bool _obscureText = true;
  String androidid;

  Company userDetails = new Company();

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
      showMessage('Form is not valid!  Please review and correct.');
    } else {
      form.save(); //This invokes each onSaved event

      print('Form save called, newContact is now up to date...');
      print('Username: ${userDetails.email}');
      print('Password: ${userDetails.password}');
      print('========================================');
      print('Submitting to back end...');
      var loginService = new LoginService();
      var data = loginService.authAccount(userDetails);
      data.then((value) {
        print(value.message);
        if (value.error == false) {
          _saveLogindata(value.company.userid, value.token,
              value.company.isPremium, value.company.isVerified);
          if (value.company.isVerified == "1") {
            if (value.company.about == null) {
              Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(
                      builder: (BuildContext context) => Profile(
                            userinfo: null,
                            companyinfo: value.company,
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
          } else {
            Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(
                    builder: (BuildContext context) => CompanyWelcomeScreen()),
                (r) => false);
          }
        } else if (value.error == true) {
          showMessage(value.message, Colors.red);
        }
      });
    }
  }

  _saveLogindata(
      String userid, String token, String isPremium, String isVerified) async {
    var prefs = await SharedPreferences.getInstance();
    prefs?.setBool("isLoggedIn", true);
    prefs?.setBool("isJobseeker", false);
    prefs.setString('token', token);
    prefs.setString('userid', userid);
    prefs.setString('isPremium', isPremium);
    prefs.setString('isVerified', isVerified);
  }

  void _toggle() {
    setState(() {
      _obscureText = !_obscureText;
    });
  }

  @override
  void initState() {
    super.initState();
    getDeviceinfo();
  }

  void getDeviceinfo() async {
    // androidDeviceInfo = await deviceInfo
    //     .androidInfo; // instantiate Android Device Infoformation
    // setState(() {
    //   androidid = androidDeviceInfo.androidId;
    //   userDetails.userDeviceID = androidid;
    // });
    final FirebaseMessaging _firebaseMessaging = FirebaseMessaging();
    _firebaseMessaging.getToken().then((value) {
      setState(() {
        userDetails.userDeviceID = value;
      });
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
                  "COMPANY LOGIN",
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                SizedBox(height: size.height * 0.03),
                SvgPicture.asset(
                  "assets/icons/login.svg",
                  height: size.height * 0.35,
                ),
                SizedBox(height: size.height * 0.03),
                RoundedInputField(
                  color: kSecondaryLightColor,
                  icon: Icons.person,
                  iconcolor: kSecondaryColor,
                  hintText: "Your Email",
                  onSaved: (String val) {
                    userDetails.email = val;
                  },
                ),
                RoundedPasswordField(
                  obscureText: _obscureText,
                  iconcolor: kSecondaryColor,
                  color: kSecondaryLightColor,
                  onPressed: _toggle,
                  validator: (val) =>
                      val.isEmpty ? 'Password is required' : null,
                  onSaved: (val) => userDetails.password = val,
                ),
                RoundedButton(
                  color: kSecondaryColor,
                  text: "LOGIN",
                  press: _submitForm,
                ),
                SizedBox(height: size.height * 0.02),
                ForgotPasswordCheck(
                  color: kSecondaryColor,
                  press: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) {
                          return SendMailBody(
                            jobseeker: false,
                          );
                        },
                      ),
                    );
                  },
                ),
                SizedBox(height: size.height * 0.03),
                AlreadyHaveAnAccountCheck(
                  color: kSecondaryColor,
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
                OrDivider(
                  color: kSecondaryColor,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    RoundedButton(
                      text: "LOGIN AS JOB SEEKER",
                      press: () {
                        Navigator.pop(context);
                        // Navigator.push(
                        //   context,
                        //   MaterialPageRoute(
                        //     builder: (context) {
                        //       return LoginScreen();
                        //     },
                        //   ),
                        // );
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
