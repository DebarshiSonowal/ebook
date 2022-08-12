class BookCategoryResponse {
  bool? status;
  String? message;
  List<BookCategory>? categories;

  BookCategoryResponse.fromJson(json) {
    status = json['success'] ?? false;
    message = json['message'] ?? "Something went wrong";
    categories = json['result'] == null || json['result'] == []
        ? []
        : (json['result'] as List)
            .map((e) => BookCategory.fromJson(e))
            .toList();
  }

  BookCategoryResponse.withError(msg) {
    status = false;
    message = msg ?? "Something went wrong";
  }
}

class BookCategory {
  int? id;
  String? title;

  BookCategory.fromJson(json) {
    id = json['id'] ?? 0;
    title = json['title'] ?? "";
  }
}
