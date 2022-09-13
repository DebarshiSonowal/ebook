class BookmarkItem {
  int? id,
      book_category_id,
      user_id,
      status,
      total_chapters,
      language_id,
      length,
      is_downloadable;
  String? code,
      title,
      contributor,
      book_format,
      category,
      approved_rejected_by,
      profile_pic,
      language,
      short_description,
      description;
  double? total_rating, average_rating;

  BookmarkItem.fromJson(json) {
    id = json['id'] ?? 0;
    book_category_id = json['book_category_id'] ?? 0;
    length = json['length'] == null ? 0 : int.parse(json['length'].toString());
    user_id =
        json['user_id'] == null ? 0 : int.parse(json['user_id'].toString());
    status = json['status'] == null ? 0 : int.parse(json['status'].toString());
    total_chapters = json['total_chapters'] == null
        ? 0
        : int.parse(json['total_chapters'].toString());
    language_id = json['language_id'] == null
        ? 0
        : int.parse(json['language_id'].toString());
    is_downloadable = json['is_downloadable'] == null
        ? 0
        : int.parse(json['is_downloadable'].toString());

    title = json['title'] ?? "";
    code = json['code'] ?? "";
    contributor = json['contributor'] ?? "";
    book_format = json['book_format'] ?? "";
    approved_rejected_by = json['approved_rejected_by'] ?? "";
    category = json['category'] ?? "";
    profile_pic = json['profile_pic'] ?? "";
    language = json['language'] ?? "";
    short_description = json['short_description'] ?? "";
    description = json['description'] ?? "";

    total_rating = json['total_rating'] == null
        ? 0
        : double.parse(json['total_rating'].toString());
    average_rating = json['average_rating'] == null
        ? 0
        : double.parse(json['average_rating'].toString());
  }
}

class BookmarkResponse {
  bool? status;
  String? message;
  List<BookmarkItem>? items;

  BookmarkResponse.fromJson(json) {
    status = json['success'] ?? false;
    message = json['message'] ?? "Something went wrong";
    items = json['result'] == null
        ? []
        : (json['result'] as List)
            .map((e) => BookmarkItem.fromJson(e))
            .toList();
  }

  BookmarkResponse.withError(msg) {
    status = false;
    message = msg ?? "Something went wrong";
  }
}
