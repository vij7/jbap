import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:jobapp/constants.dart';

class EmployeePremium extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: kPrimaryColor,
        title: Text('Become a Premium Member'),
        leading: IconButton(
          icon: Icon(
            Icons.chevron_left,
            color: Colors.white,
          ),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            SizedBox(height: 16.0),
            _buildTitle('PREMIUM MEMBER (500 + gst = 590)'),
            SizedBox(height: 5.0),
            _buildRow('Exclusive job assistance for free.'),
            _buildRow(
                'Resume editing and interview trainings based on each interview scheduled by us.'),
            _buildRow(
                'Free-lance opportunity with Starwing HR Consultancy Pvt Ltd in recruitment, training, marketing and course design from anywhere in India.'),
            _buildRow(
                'Monthly 3 free training programs/webinars on different topics.'),
            _buildRow(
                'Develop your HR, marketing, digital marketing, sales, recruitment skills with 30% direct discount from any where in India.'),
            _buildRow(
                'Special refunds on training programs conducted by our partner companies (15-20%),'),
            SizedBox(height: 16.0),
            _buildTitle('CONTACT DETAILS'),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  ListTile(
                    leading: Padding(
                      padding: const EdgeInsets.only(top: 8.0, left: 20.0),
                      child: Icon(
                        FontAwesomeIcons.phone,
                        size: 12.0,
                        color: Colors.black54,
                      ),
                    ),
                    title: Text(
                      '7902699406, 6235 723 406',
                      style: TextStyle(
                          fontSize: 15.0, fontWeight: FontWeight.bold),
                    ),
                  ),
                  SizedBox(height: 5.0),
                  ListTile(
                    leading: Padding(
                      padding: const EdgeInsets.only(top: 8.0, left: 20.0),
                      child: Icon(
                        Icons.mail_outline,
                        size: 12.0,
                        color: Colors.black54,
                      ),
                    ),
                    title: Text(
                      'info@starwinghr.com',
                      style: TextStyle(
                          fontSize: 15.0, fontWeight: FontWeight.bold),
                    ),
                  ),
                  SizedBox(height: 5.0),
                  Text(
                    'Account Number: 0464073000000225',
                    style:
                        TextStyle(fontSize: 15.0, fontWeight: FontWeight.bold),
                  ),
                  Text(
                    'User name: Starwing HR Consultancy PVT LTD',
                    style:
                        TextStyle(fontSize: 15.0, fontWeight: FontWeight.bold),
                  ),
                  Text(
                    'IFSC Code: SIBL0000464',
                    style:
                        TextStyle(fontSize: 15.0, fontWeight: FontWeight.bold),
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }

  ListTile _buildRow(String content) {
    return ListTile(
      leading: Padding(
        padding: const EdgeInsets.only(top: 8.0, left: 20.0),
        child: Icon(
          FontAwesomeIcons.solidCircle,
          size: 12.0,
          color: Colors.black54,
        ),
      ),
      title: Text(
        content,
        style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
      ),
    );
  }

  Widget _buildTitle(String title) {
    return Padding(
      padding: const EdgeInsets.only(left: 16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            title.toUpperCase(),
            style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),
          ),
          Divider(
            color: Colors.black54,
          ),
        ],
      ),
    );
  }
}
