import 'package:empty_widget/empty_widget.dart';
import 'package:flutter/material.dart';
import 'package:jobapp/ui/components/rounded_button.dart';
import 'package:jobapp/ui/screens/Login/login_screen.dart';
import 'package:jobapp/ui/screens/Welcome/components/background.dart';
import 'package:jobapp/ui/widgets/emptyresult.dart';

class CompanyMessageBody extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    // This size provide us total height and width of our screen
    return Background(
      child: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              "WELCOME TO JOB PORTAL",
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            SizedBox(height: size.height * 0.05),
            Center(
              child: EmptyResultWidget(
                  image: PackageImage.Image_1,
                  title: 'Registration Completed.',
                  subtitle: 'After the admin verification you can login.'),
            ),
            SizedBox(height: size.height * 0.05),
            RoundedButton(
              text: "BACK TO LOGIN",
              press: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) {
                      return LoginScreen();
                    },
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
