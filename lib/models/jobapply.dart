class JobApply {
  String userid = '';
  String jobid = '';
  String message = '';
  bool error;
  int isApplied;
  String errmsg;

  JobApply({this.userid, this.jobid, this.isApplied});

  factory JobApply.fromJson(Map<String, dynamic> json) {
    return JobApply(
        userid: json['user_id'] as String,
        jobid: json['job_id'] as String,
        isApplied: json['is_applied'] as int);
  }

  Map<String, dynamic> toJson() {
    return {
      "user_id": this.userid,
      "job_id": this.jobid,
      "is_applied": this.isApplied,
    };
  }
}
