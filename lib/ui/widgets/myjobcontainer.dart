import 'package:flutter/material.dart';
import 'package:jobapp/constants.dart';

class MyJobContainer extends StatelessWidget {
  const MyJobContainer({
    Key key,
    @required this.iconUrl,
    @required this.title,
    @required this.location,
    @required this.description,
    @required this.salaryFrom,
    this.salaryTo,
    @required this.company,
    @required this.onPressView,
    @required this.onPressDel,
  }) : super(key: key);
  final String iconUrl,
      title,
      location,
      description,
      salaryFrom,
      salaryTo,
      company;
  final Function onPressView;
  final Function onPressDel;
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 15.0, horizontal: 5.0),
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
                child: Image.network(
                  "$iconUrl",
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
                      "$title",
                      style: Theme.of(context).textTheme.headline6,
                    ),
                    Text(
                      "$company" + "," + "$location",
                      style: Theme.of(context).textTheme.subtitle2.apply(
                            color: Colors.grey,
                          ),
                    )
                  ],
                ),
              )
            ],
          ),
          SizedBox(height: 5),
          Text(
            "$description",
            style:
                Theme.of(context).textTheme.bodyText2.apply(color: Colors.grey),
            maxLines: 3,
            overflow: TextOverflow.ellipsis,
          ),
          SizedBox(height: 9),
          Text(
            "\u{20B9}$salaryFrom - \u{20B9}$salaryTo",
            style:
                Theme.of(context).textTheme.subtitle1.apply(fontWeightDelta: 2),
          ),
          // SizedBox(height: 9),
          ButtonBar(
            alignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              FlatButton(
                color: kPrimaryColor,
                child: const Text(
                  'View Applicants',
                  style: TextStyle(fontSize: 10.0),
                ),
                shape: new RoundedRectangleBorder(
                    borderRadius: new BorderRadius.circular(10.0)),
                textColor: Colors.white,
                onPressed: onPressView,
              ),
              FlatButton(
                child: Icon(
                  Icons.delete,
                  color: Colors.white,
                ),
                color: kSecondaryColor,
                shape: CircleBorder(),
                onPressed: onPressDel,
              ),
            ],
          ),
        ],
      ),
    );
  }
}
