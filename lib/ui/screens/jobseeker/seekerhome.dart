import 'package:flutter/material.dart';
import 'package:jobapp/models/job.dart';
import 'package:jobapp/ui/screens/jobseeker/screens.dart';
import 'package:jobapp/ui/widgets/widgets.dart';

class SeekerHomeScreen extends StatelessWidget {
  final List<JobModel> joblist;
  SeekerHomeScreen({Key key, @required this.joblist}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: joblist.length,
      itemBuilder: (ctx, i) {
        return JobContainer(
          description: joblist[i].description,
          iconUrl: joblist[i].iconUrl,
          location: joblist[i].location,
          title: joblist[i].title,
          company: joblist[i].companyname,
          salaryFrom: joblist[i].salaryFrom,
          salaryTo: joblist[i].salaryTo,
          onTap: () => Navigator.push(
            context,
            MaterialPageRoute(
              builder: (ctx) => DetailsScreen(joblist: joblist[i]),
            ),
          ),
        );
      },
    );
  }
}
