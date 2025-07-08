import 'Tag.dart';
import 'article.dart';
import 'subscription.dart';

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
  int? id,
      book_category_id,
      length,
      total_rating,
      contributor_id,
      no_of_articles,
      total_chapters,
      magazine_id,
      status;
  String? title,
      writer,
      book_format,
      category,
      profile_pic,
      language,
      short_description,
      description,
      contributor,
      publication_name,
      publisher,
      released_date,
      review_url,
      flip_book_url;
  double? selling_price, base_price, discount, average_rating;
  List<Tag>? tags, awards;
  bool? is_bookmarked, is_bought;
  List<Article>? articles;
  List<Subscription> subscriptions = [];

  Book.fromJson(json) {
    id = json['id'] == null ? 0 : int.parse(json['id'].toString());
    no_of_articles = json['no_of_articles'] == null
        ? 0
        : int.parse(json['no_of_articles'].toString());
    book_category_id = json['book_category_id'] == null
        ? 0
        : int.parse(json['book_category_id'].toString());
    magazine_id = json['magazine_id'] == null
        ? 0
        : int.parse(json['magazine_id'].toString());
    contributor_id = json['contributor_id'] == null
        ? 0
        : int.parse(json['contributor_id'].toString());
    length = json['length'] == null ? 0 : int.parse(json['length'].toString());
    total_rating = json['total_rating'] ?? 0;
    total_chapters = json['total_chapters'] ?? 0;
    status = json['status'] ?? 0;

    title = json['title'] ?? "";
    writer = json['writer'] ?? json['contributor'] ?? "";
    book_format = json['book_format'] ?? "";
    category = json['category'] ?? "";
    profile_pic = json['profile_pic'] ?? "";
    language = json['language'] ?? "";
    short_description = json['short_description'] ?? "";
    description = json['description'] ?? "";
    is_bookmarked = json['is_bookmarked'] ?? false;
    is_bought = json['is_bought'] ?? false;
    contributor = json['contributor'] ?? "";
    publication_name = json['publication_name'] ?? "";
    released_date = json['released_date'] ?? "";
    publisher = json['publisher'] ?? "";
    review_url = json['review_url'] ?? "";
    flip_book_url = json['flip_book_url'] ?? "";

    tags = json['tags'] == null
        ? []
        : (json['tags'] as List).map((e) => Tag.fromJson(e)).toList();
    subscriptions = json['subscriptions'] == null
        ? []
        : (json['subscriptions'] as List)
            .map((e) => Subscription.fromJson(e))
            .toList();
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
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'book_category_id': book_category_id,
      'length': length,
      'total_rating': total_rating,
      'contributor_id': contributor_id,
      'no_of_articles': no_of_articles,
      'total_chapters': total_chapters,
      'magazine_id': magazine_id,
      'status': status,
      'title': title,
      'writer': writer,
      'book_format': book_format,
      'category': category,
      'profile_pic': profile_pic,
      'language': language,
      'short_description': short_description,
      'description': description,
      'contributor': contributor,
      'publication_name': publication_name,
      'publisher': publisher,
      'released_date': released_date,
      'review_url': review_url,
      'flip_book_url': flip_book_url,
      'selling_price': selling_price,
      'base_price': base_price,
      'discount': discount,
      'average_rating': average_rating,
      'tags': tags?.map((e) => e.toJson()).toList(),
      'awards': awards?.map((e) => e.toJson()).toList(),
      'is_bookmarked': is_bookmarked,
      'is_bought': is_bought,
      'articles': articles?.map((e) => e.toJson()).toList(),
      'subscriptions': subscriptions.map((e) => e.toJson()).toList(),
    };
  }
}
