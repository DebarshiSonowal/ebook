class Subscriber {

  int? id, status;
  String? code, f_name, l_name, mobile, email, date_of_birth, profile_pic;

  Subscriber.fromJson(json) {
    //int
    id = json['id'] ?? 0;
    status = json['status'] ?? 0;

    //String
    code = json['code'] ?? "";
    f_name = json['f_name'] ?? "";
    l_name = json['l_name'] ?? "";
    mobile = json['mobile'] ?? "";
    email = json['email'] ?? "";
    date_of_birth = json['date_of_birth'] ?? "";
    profile_pic = json['profile_pic'] ?? "";
  }
}
