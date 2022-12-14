import 'Tag.dart';
import 'article.dart';

class HomeBannerResponse {
  bool? status;
  String? message;
  List<Book>? banners;

  HomeBannerResponse.fromJson(json) {
    status = json['success'] ?? false;
    message = json['message'] ?? "Something went wrong";
    banners = json['result'] == null
        ? []
        : (json['result'] as List).map((e) => Book.fromJson(e)).toList();
  }

  HomeBannerResponse.withError(msg) {
    status = false;
    message = msg ?? "Something went wrong";
  }
}

class Book {
  int? id, book_category_id, length, total_rating,contributor_id;
  String? title,
      writer,
      book_format,
      category,
      profile_pic,
      language,
      short_description;
  double? selling_price, base_price, discount, average_rating;
  List<Tag>? tags, awards;
  bool? is_bookmarked;
  List<Article>? articles;

  Book.fromJson(json) {
    id = json['id'] == null ? 0 : int.parse(json['id'].toString());
    book_category_id = json['book_category_id'] == null
        ? 0
        : int.parse(json['book_category_id'].toString());
    contributor_id = json['contributor_id'] == null
        ? 0
        : int.parse(json['contributor_id'].toString());
    length = json['length'] == null ? 0 : int.parse(json['length'].toString());
    total_rating = json['total_rating'] ?? 0;

    title = json['title'] ?? "";
    writer = json['writer'] ?? json['contributor'] ?? "";
    book_format = json['book_format'] ?? "";
    category = json['category'] ?? "";
    profile_pic = json['profile_pic'] ?? "";
    language = json['language'] ?? "";
    short_description = json['short_description'] ?? "";
    is_bookmarked = json['is_bookmarked'] ?? false;

    tags = json['tags'] == null
        ? []
        : (json['tags'] as List).map((e) => Tag.fromJson(e)).toList();
    awards = json['awards'] == null
        ? []
        : (json['awards'] as List).map((e) => Tag.fromJson(e)).toList();

    selling_price = json['selling_price'] == null || json['selling_price'] == ""
        ? 0
        : double.parse(json['selling_price'].toString());
    base_price = json['base_price'] == null || json['base_price'] == ""
        ? 0
        : double.parse(json['base_price'].toString());
    discount = json['discount'] == null || json['discount'] == ""
        ? 0
        : double.parse(json['discount'].toString());
    average_rating =
        json['average_rating'] == null || json['average_rating'] == ""
            ? 0
            : double.parse(json['average_rating'].toString());
    articles = json['article_list'] == null
        ? []
        : (json['article_list'] as List)
        .map((e) => Article.fromJson(e))
        .toList();
  }
}
