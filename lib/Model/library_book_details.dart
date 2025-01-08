import 'Tag.dart';
import 'article.dart';

class LibraryBookDetailsResponse {
  bool? status;
  String? message;
  List<LibraryBookDetailsModel>? details;

  LibraryBookDetailsResponse.fromJson(json) {
    status = json['success'] ?? false;
    message = json['message'] ?? "Something went wrong";
    details = (json['result'] as List)
        .map((e) => LibraryBookDetailsModel.fromJson(e))
        .toList();
  }

  LibraryBookDetailsResponse.withError(msg) {
    status = false;
    message = msg ?? "Something went wrong";
  }
}

class LibraryBookDetailsModel {
  // "language": "English",
  // "category": "Story",
  // "writer": "Mr Sandeep Baruah",
  // "publisher": "Sanjay Das",
  int? id,
      product_type_id,
      writer_id,
      book_category_id,
      language_id,
      publisher_id,
      user_id,
      contributor_id,
      status,
      total_chapters,
      length;

  String? title,
      code,
      book_format,
      description,
      profile_pic,
      rejected_reason,
      publisher,
      writer,
      category,
      language,
      released_date,
      contributor,
      publication_name;
  double? average_rating,
      total_rating,
      base_price,
      discount,
      commission_percent,
      commission,
      writer_amount,
      selling_price;
  bool? is_free, is_bought;

  List<Tag>? tags, awards;
  List<Article>? articles;

  LibraryBookDetailsModel.fromJson(json) {
    id = json['id'] ?? 0;
    length =
        json['length'] == null ? 0 : (int.parse(json['length'].toString()));
    product_type_id = json['product_type_id'] ?? 0;
    writer_id = json['writer_id'] ?? 0;
    book_category_id = json['book_category_id'] ?? 0;
    language_id = json['language_id'] ?? 0;
    publisher_id = json['publisher_id'] ?? 0;
    user_id = json['user_id'] ?? 0;
    contributor_id = json['contributor_id'] ?? 0;
    status = json['status'] ?? 0;
    total_chapters = json['total_chapters'] ?? 0;

    //String
    title = json['title'] ?? "";
    code = json['code'] ?? "";
    book_format = json['book_format'] ?? "";
    description = json['description'] ?? "";
    profile_pic = json['profile_pic'] ?? "";
    rejected_reason = json['rejected_reason'] ?? "";
    publisher = json['publisher'] ?? "";
    contributor = json['contributor'] ?? "";
    writer = json['writer'] ?? "";
    category = json['category'] ?? "";
    language = json['language'] ?? "";
    released_date = json['released_date'] ?? "";
    publication_name = json['publication_name'] ?? "";

    //List
    tags = json['tags'] == null
        ? []
        : (json['tags'] as List).map((e) => Tag.fromJson(e)).toList();
    awards = json['awards'] == null
        ? []
        : (json['awards'] as List).map((e) => Tag.fromJson(e)).toList();
    articles = json['article_list'] == null
        ? []
        : (json['article_list'] as List)
            .map((e) => Article.fromJson(e))
            .toList();

    //double
    average_rating = json['average_rating'] == null
        ? 0
        : double.parse(json['average_rating']);
    total_rating = json['total_rating'] == null
        ? 0
        : double.parse(json['total_rating'].toString());
    base_price = json['selling_price'] == null
        ? 0
        : double.parse(json['selling_price'].toString());
    discount = json['discount'] == null
        ? 0
        : double.parse(json['discount'].toString());
    commission_percent = json['commission_percent'] == null
        ? 0
        : double.parse(json['commission_percent']);
    commission =
        json['commission'] == null ? 0 : double.parse(json['commission']);
    writer_amount =
        json['writer_amount'] == null ? 0 : double.parse(json['writer_amount']);
    selling_price =
        json['selling_price'] == null ? 0 : double.parse(json['selling_price']);

    //bool
    is_free = json['is_free'] == null
        ? false
        : json['is_free'] == 0
            ? true
            : false;
    is_bought = json['is_bought'] == null
        ? false
        : json['is_bought'] == 0
            ? true
            : false;
  }
}
