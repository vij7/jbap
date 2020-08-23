class JobModel {
  String id,
      companyid,
      companyname,
      description,
      iconUrl,
      location,
      title,
      salaryFrom,
      salaryTo,
      message,
      category = '';
  bool error;
  // final List<String> photos;

  JobModel(
      {this.id,
      this.companyname,
      this.description,
      this.iconUrl,
      this.location,
      this.title,
      this.salaryFrom,
      this.salaryTo,
      this.companyid,
      this.message,
      this.category,
      this.error});

  factory JobModel.fromJson(Map<String, dynamic> json) {
    return JobModel(
        id: json['id'] as String,
        title: json['title'] as String,
        description: json['description'] as String,
        companyname: json['company_name'] as String,
        iconUrl: json['logo'] as String,
        location: json['location'] as String,
        salaryFrom: json['from_salary'] as String,
        salaryTo: json['to_salary'] as String);
  }
}
