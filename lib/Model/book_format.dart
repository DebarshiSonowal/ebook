class BookFormatResponse {
  bool? status;
  String? message;
  List<BookFormat>? bookFormats;

  BookFormatResponse.fromJson(json) {
    status = json['success'] ?? false;
    message = json['message'] ?? "Something went wrong";
    bookFormats = json['result'] == null
        ? []
        : (json['result'] as List).map((e) => BookFormat.fromJson(e)).toList();
  }

  BookFormatResponse.withError(msg) {
    status = false;
    message = msg ?? "Something went wrong";
  }
}

class BookFormat {
  int? id;
  String? name, productFormat;

  BookFormat.fromJson(json) {
    id = json['id'] ?? 0;
    name = json['name'] ?? "";
    productFormat = json['product_format'] ?? "";
  }
}
