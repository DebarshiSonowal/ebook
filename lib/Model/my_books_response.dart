import 'package:ebook/Model/home_banner.dart';

class MyBooksResponse {
  bool? status;
  String? message;
  List<Book>? books;

  MyBooksResponse.fromJson(json) {
    status = json['success'] ?? false;
    message = json['message'] ?? "Something went wrong";
    books = json['result'] == null
        ? []
        : (json['result'] as List).map((e) => Book.fromJson(e)).toList();
  }

  MyBooksResponse.withError(msg) {
    status = false;
    message = msg ?? "Something went wrong";
  }
}
