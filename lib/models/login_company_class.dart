class Company {
  String userid = '';
  String firstname = '';
  String lastname = '';
  String companyname = '';
  String email = '';
  String phone = '';
  String password = '';
  String logo = '';
  String location = '';
  String about = '';
  String isPremium;
  String isVerified;
  String userDeviceID = '';

  Company(
      {this.userid,
      this.firstname,
      this.lastname,
      this.companyname,
      this.email,
      this.phone,
      this.password,
      this.location,
      this.logo,
      this.isPremium,
      this.isVerified,
      this.userDeviceID});

  factory Company.fromJson(Map<String, dynamic> json) {
    return Company(
        userid: json['user_id'] as String,
        firstname: json['first_name'] as String,
        lastname: json['last_name'] as String,
        email: json['email'] as String,
        phone: json['phone'] as String,
        companyname: json['company_name'] as String,
        logo: json['logo'] as String,
        location: json['location'] as String,
        isPremium: json['is_premium'] as String,
        isVerified: json['is_verified'] as String);
  }

  Map<String, dynamic> toJson() {
    return {
      "user_id": this.userid,
      "first_name": this.firstname,
      "last_name": this.lastname,
      "email": this.email,
      "phone": this.phone,
      "company_name": this.companyname,
      "logo": this.logo,
      "location": this.location
    };
  }
}

class ResMessage {
  bool error;
  String token = '';
  String message = '';
  Company company;
}
