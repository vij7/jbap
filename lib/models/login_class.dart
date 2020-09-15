class User {
  String userid = '';
  String firstname = '';
  String lastname = '';
  String email = '';
  String phone = '';
  String password = '';
  String address = '';
  String city = '';
  String state = '';
  String postcode;
  String jobtitle = '';
  String keywords = '';
  String skills = '';
  String qualification = '';
  String experience = '';
  String ctc = '';
  String salaryrange = '';
  String about = '';
  String resumeUrl = '';
  String category = '';
  String resumeName = '';
  String userDeviceID = '';

  User(
      {this.userid,
      this.firstname,
      this.lastname,
      this.email,
      this.phone,
      this.password,
      this.address,
      this.city,
      this.state,
      this.postcode,
      this.jobtitle,
      this.keywords,
      this.skills,
      this.qualification,
      this.experience,
      this.ctc,
      this.salaryrange,
      this.about,
      this.resumeUrl,
      this.category,
      this.resumeName,
      this.userDeviceID});

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
        userid: json['user_id'] as String,
        firstname: json['first_name'] as String,
        lastname: json['last_name'] as String,
        email: json['email'] as String,
        phone: json['phone'] as String,
        password: json['password'] as String,
        address: json['address'] as String,
        city: json['city'] as String,
        state: json['state'] as String,
        postcode: json['postcode'] as String,
        jobtitle: json['job_title'] as String,
        keywords: json['keywords'] as String,
        skills: json['skills'] as String,
        qualification: json['qualification'] as String,
        experience: json['experience'] as String,
        ctc: json['ctc'] as String,
        salaryrange: json['salary_range'] as String,
        about: json['about'] as String,
        category: json['category'] as String,
        resumeUrl: json['resume'] as String,
        resumeName: json['resume_name'] as String);
  }

  Map<String, dynamic> toJson() {
    return {
      "user_id": this.userid,
      "first_name": this.firstname,
      "last_name": this.lastname,
      "email": this.email,
      "phone": this.phone,
      "password": this.password,
      "address": this.address,
      "city": this.city,
      "state": this.state,
      "postcode": this.postcode,
      "job_title": this.jobtitle,
      "keywords": this.keywords,
      "skills": this.skills,
      "qualification": this.qualification,
      "experience": this.experience,
      "ctc": this.ctc,
      "salary_range": this.salaryrange,
      "about": this.about,
      "resume": this.resumeUrl,
      "category": this.category,
      "resume_name": this.resumeName
    };
  }
}

class ResMessage {
  bool error;
  String token = '';
  String message = '';
  User user;
}
