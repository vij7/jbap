import 'package:flutter/material.dart';

class UserContainer extends StatelessWidget {
  const UserContainer(
      {Key key,
      @required this.firstname,
      @required this.lastname,
      @required this.email,
      @required this.phone,
      @required this.onTap,
      this.jobtitle,
      this.skills})
      : super(key: key);
  final String firstname, lastname, email, phone, skills, jobtitle;
  final Function onTap;
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 5.0, horizontal: 5.0),
        padding: const EdgeInsets.all(15.0),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(9.0),
          boxShadow: [
            BoxShadow(
                color: Colors.grey[300], blurRadius: 5.0, offset: Offset(0, 3))
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Row(
              children: <Widget>[
                ClipRRect(
                  borderRadius: BorderRadius.circular(15.0),
                  child: Image.asset(
                    'assets/images/user.png',
                    height: 71,
                    width: 71,
                  ),
                ),
                SizedBox(width: 15),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text(
                        "$firstname".toUpperCase() +
                            " " +
                            "$lastname".toUpperCase(),
                        style: Theme.of(context).textTheme.headline6,
                      ),
                      Text(
                        "$email",
                        style: Theme.of(context).textTheme.subtitle2.apply(
                              color: Colors.grey,
                            ),
                      ),
                      Text(
                        "$phone",
                        style: Theme.of(context).textTheme.subtitle2.apply(
                              color: Colors.grey,
                            ),
                      ),
                      Visibility(
                        child: Text("$skills"),
                        visible: false,
                      ),
                      Visibility(
                        child: Text("$jobtitle"),
                        visible: false,
                      )
                    ],
                  ),
                )
              ],
            ),
          ],
        ),
      ),
    );
  }
}
