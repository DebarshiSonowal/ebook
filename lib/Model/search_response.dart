import 'home_banner.dart';

class SearchResponse {
  bool? success;
  String? message;
  int? current_page, last_page, per_page, total;
  List<Book> books = [];

  SearchResponse.fromJson(json) {
    success = json['success'] ?? false;
    message = json['message'] ?? "Something went wrong";
    books = json['result']['book_list'] == null
        ? []
        : (json['result']['book_list'] as List)
            .map((e) => Book.fromJson(e))
            .toList();
    current_page = json['result']['current_page'] ?? 0;
    last_page = json['result']['last_page'] ?? 0;
    per_page = json['result']['per_page'] ?? 0;
    total = json['result']['total'] ?? 0;
  }

  SearchResponse.withError(msg) {
    success = false;
    message = msg ?? "Something went wrong";
  }
}
