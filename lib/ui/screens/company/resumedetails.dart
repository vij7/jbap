import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:jobapp/models/login_class.dart';
import 'package:ext_storage/ext_storage.dart';
import 'package:dio/dio.dart';
import 'package:permission_handler/permission_handler.dart';

class DetailsScreen extends StatefulWidget {
  final User emplist;
  DetailsScreen({Key key, @required this.emplist}) : super(key: key);

  @override
  _DetailsScreenState createState() => _DetailsScreenState();
}

class _DetailsScreenState extends State<DetailsScreen> {
  var dio = Dio();
  String resumeUrl;
  bool downloading = false;
  var progress = "";
  var path = "No Data";
  var platformVersion = "Unknown";
  Permission permission1 = Permission.storage;
  Directory externalDir;
  String fullPath;
  String name;
  String email,
      phone,
      city,
      state,
      jobtitle,
      skills,
      education,
      experience,
      ctc,
      about,
      resumename;

  @override
  void initState() {
    super.initState();
    setState(() {
      resumeUrl = widget.emplist.resumeUrl;
      if (widget.emplist.about != null) {
        about = widget.emplist.about;
      } else {
        about = '';
      }
      if (widget.emplist.city != null) {
        city = widget.emplist.city;
      } else {
        city = '';
      }
      if (widget.emplist.state != null) {
        state = widget.emplist.state;
      } else {
        state = '';
      }
      if (widget.emplist.jobtitle != null) {
        jobtitle = widget.emplist.jobtitle;
      } else {
        jobtitle = '';
      }
      if (widget.emplist.skills != null) {
        skills = widget.emplist.skills;
      } else {
        skills = 'No details updated.';
      }
      if (widget.emplist.experience != null) {
        experience = widget.emplist.experience;
      } else {
        experience = 'No details updated.';
      }
      if (widget.emplist.qualification != null) {
        education = widget.emplist.qualification;
      } else {
        education = 'No details updated.';
      }
      if (widget.emplist.ctc != null) {
        ctc = widget.emplist.ctc;
      } else {
        ctc = 'No details updated.';
      }
      if (widget.emplist.resumeName != null) {
        resumename = widget.emplist.resumeName;
      } else {
        resumename = '';
      }
    });
  }

  Future<String> getFilePath(uniqueFileName) async {
    String path = '';

    String dir = await ExtStorage.getExternalStoragePublicDirectory(
        ExtStorage.DIRECTORY_DOWNLOADS);

    print(dir);

    path = '$dir/$uniqueFileName.pdf';

    print(path);

    return path;
  }

  Future<void> downloadFile() async {
    Dio dio = Dio();
    bool checkPermission1 = await Permission.storage.isGranted;
    // print(checkPermission1);
    if (checkPermission1 == false) {
      await Permission.storage.request();
      checkPermission1 = await Permission.storage.isGranted;
    }
    if (checkPermission1 == true) {
      String pathnew = await ExtStorage.getExternalStoragePublicDirectory(
          ExtStorage.DIRECTORY_DOWNLOADS);
      name = widget.emplist.firstname + "_" + widget.emplist.lastname;
      fullPath = "$pathnew/$name.pdf";

      try {
        Response response = await dio.get(
          resumeUrl,
          onReceiveProgress: showDownloadProgress,
          //Received data with List<int>
          options: Options(
              responseType: ResponseType.bytes,
              followRedirects: false,
              validateStatus: (status) {
                return status < 500;
              }),
        );
        print(response.headers);
        File file = File(fullPath);
        var raf = file.openSync(mode: FileMode.write);
        raf.writeFromSync(response.data);
        await raf.close();
        downloadStatus(context);
      } catch (e) {
        print(e);
      }

      setState(() {
        downloading = false;
      });
    } else {
      setState(() {
        progress = "Permission Denied!";
      });
    }
  }

  void showDownloadProgress(received, total) {
    if (total != -1) {
      setState(() {
        downloading = true;
      });
      progress = ((received / total * 100).toStringAsFixed(0) + "%");
    }
  }

  downloadStatus(BuildContext context) {
    return showDialog(
        context: context,
        barrierDismissible: true,
        builder: (context) {
          return AlertDialog(
            title: Text("Download Completed"),
            content: Text("Find $name.pdf in downloads"),
            actions: [
              FlatButton(
                child: Text("OK"),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              )
            ],
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: Icon(
            Icons.chevron_left,
            color: Colors.black54,
          ),
          onPressed: () => Navigator.pop(context),
        ),
        // automaticallyImplyLeading: false,
        actions: <Widget>[
          downloading
              ? Text(
                  '$progress',
                  style: TextStyle(color: Colors.black54),
                )
              : Text('Resume'),
          resumename.isNotEmpty
              ? IconButton(
                  icon: Icon(
                    Icons.file_download,
                    color: Colors.black54,
                  ),
                  onPressed: () {
                    downloadFile();
                  },
                )
              : Icon(
                  Icons.file_download,
                  color: Colors.white,
                )
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            _buildHeader(),
            Container(
              margin: const EdgeInsets.all(16.0),
              padding: const EdgeInsets.all(16.0),
              decoration: BoxDecoration(color: Colors.grey.shade200),
              child: Text(about),
            ),
            _buildTitle("Skills"),
            SizedBox(height: 10.0),
            _buildSkillRow(skills, 0.75),
            SizedBox(height: 30.0),
            _buildTitle("Experience"),
            _buildExperienceRow(
                company: experience, position: "", duration: ""),
            SizedBox(height: 20.0),
            _buildTitle("Education"),
            SizedBox(height: 5.0),
            _buildExperienceRow(company: education, position: "", duration: ""),
            SizedBox(height: 20.0),
            _buildTitle("CTC"),
            SizedBox(height: 5.0),
            _buildExperienceRow(company: ctc, position: "", duration: ""),
            _buildTitle("Contact"),
            SizedBox(height: 5.0),
            Row(
              children: <Widget>[
                SizedBox(width: 30.0),
                Icon(
                  Icons.mail,
                  color: Colors.black54,
                ),
                SizedBox(width: 10.0),
                Text(
                  widget.emplist.email,
                  style: TextStyle(fontSize: 16.0),
                ),
              ],
            ),
            SizedBox(height: 10.0),
            Row(
              children: <Widget>[
                SizedBox(width: 30.0),
                Icon(
                  Icons.phone,
                  color: Colors.black54,
                ),
                SizedBox(width: 10.0),
                Text(
                  widget.emplist.phone,
                  style: TextStyle(fontSize: 16.0),
                ),
              ],
            ),
            SizedBox(height: 20.0),
          ],
        ),
      ),
    );
  }

  ListTile _buildExperienceRow(
      {String company, String position, String duration}) {
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
        company,
        style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
      ),
      subtitle: Text("$position"),
    );
  }

  Row _buildSkillRow(String skill, double level) {
    return Row(
      children: <Widget>[
        SizedBox(width: 16.0),
        Expanded(
            flex: 2,
            child: Text(
              skill.toUpperCase(),
              textAlign: TextAlign.left,
            )),
        SizedBox(width: 10.0),
        // Expanded(
        //   flex: 5,
        //   child: LinearProgressIndicator(
        //     value: level,
        //   ),
        // ),
        SizedBox(width: 16.0),
      ],
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

  Row _buildHeader() {
    return Row(
      children: <Widget>[
        SizedBox(width: 20.0),
        Container(
            width: 80.0,
            height: 80.0,
            child: Image.asset(
              'assets/images/user.png',
            )),
        SizedBox(width: 20.0),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(
              widget.emplist.firstname + " " + widget.emplist.lastname,
              style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 10.0),
            Text(jobtitle),
            SizedBox(height: 5.0),
            Row(
              children: <Widget>[
                Icon(
                  FontAwesomeIcons.map,
                  size: 12.0,
                  color: Colors.black54,
                ),
                SizedBox(width: 10.0),
                Text(
                  city + "," + state,
                  style: TextStyle(color: Colors.black54),
                ),
              ],
            ),
          ],
        )
      ],
    );
  }
}
