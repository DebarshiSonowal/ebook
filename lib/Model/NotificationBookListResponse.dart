import 'package:ebook/Model/home_banner.dart';

class NotificationBookListResponse {
  bool? success;
  String? message;
  String? title;
  String? headTitle;
  List<Book>? books;
  NotificationBookListResponse.fromJson(Map<String, dynamic> json) {
    success = json['success'] ?? false;
    message = json['message'] ?? "Something went wrong";
    title = json['result']['title'] ?? "N/A";
    headTitle = json['result']['head_title'] ?? "N/A";
    books = (json['result']['book_list'] as List<dynamic>)
        .map((item) => Book.fromJson(item))
        .toList();
  }

  NotificationBookListResponse.withError(String errorMessage) {
    success = false;
    message = errorMessage ?? "Something went wrong";
    books = [];
  }
}
