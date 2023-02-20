import 'dart:convert';

import 'package:ebook/Model/Tag.dart';
import 'package:ebook/Model/home_banner.dart';

class writer {
  int? id, contributor_type, grade_id, status, agent_id;
  String? code,
      contributor_name,
      salutation,
      name,
      mobile,
      email,
      profile_pic,
      about,title;
  List<Book> books = [];
  List<Tag> tags = [], awards = [];

  writer.fromJson(json) {
    id = json['id'] ?? 0;
    contributor_type = json['contributor_type'] == null
        ? 0
        : int.parse(json['contributor_type'].toString());
    grade_id =
        json['grade_id'] == null ? 0 : int.parse(json['grade_id'].toString());
    status = json['status'] == null ? 0 : int.parse(json['status'].toString());
    agent_id =
        json['agent_id'] == null ? 0 : int.parse(json['agent_id'].toString());

    code = json['code'] ?? "";
    about = json['about'] ?? "";
    title = json['title'] ?? "";
    contributor_name = json['contributor_name'] ?? "";
    salutation = json['salutation'] ?? "";
    name = "${json['f_name'] ?? ""} ${json['l_name'] ?? ""}";
    mobile = json['mobile'] ?? "";
    email = json['email'] ?? "";
    profile_pic = json['profile_pic'] ?? "";

    books = json['books'] == null
        ? []
        : (json['books'] as List).map((e) => Book.fromJson(e)).toList();

    tags = json['tags'] == null
        ? []
        : (json['tags'] as List).map((e) => Tag.fromJson(e)).toList();
    awards = json['awards'] == null
        ? []
        : (json['awards'] as List).map((e) => Tag.fromJson(e)).toList();

  }
}

class WriterResponse {
  bool? success;
  String? msg;
  writer? writer_details;

  WriterResponse.fromJson(json) {
    success = json['success'] ?? false;
    msg = json['message'] ?? "";
    writer_details = writer.fromJson(json['result']);
  }

  WriterResponse.withError(msg) {
    success = false;
    this.msg = msg ?? "Something went wrong";
  }
}
