class ProfileResponse {
  bool? status;
  Profile? profile;

  ProfileResponse.fromJson(json) {
    status = true;
    profile = Profile.fromJson(json['result']['data']);
  }

  ProfileResponse.withError() {
    status = false;
  }
}

class Profile {
  int? id, status;
  String? code, f_name, l_name, mobile, email, date_of_birth, profile_pic;

  Profile.fromJson(json) {
    id = json['id'] ?? 0;
    status = int.parse((json['status'] ?? 0).toString());
    code = (json['code'] ?? "").toString();
    f_name = json['f_name'] ?? "";
    l_name = json['l_name'] ?? "";
    mobile = json['mobile'] ?? "";
    email = json['email'] ?? "";
    date_of_birth = json['date_of_birth'] ?? "";
    profile_pic = json['profile_pic'] ?? "";
  }
}
