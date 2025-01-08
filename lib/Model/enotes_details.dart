import 'enote_banner.dart';

class ENotesDetailsResponse {
  bool success;
  EnotesDetails result;
  String message;
  int code;

  ENotesDetailsResponse({
    required this.success,
    required this.result,
    required this.message,
    required this.code,
  });

  factory ENotesDetailsResponse.fromJson(Map<String, dynamic> json) {
    return ENotesDetailsResponse(
      success: json['success'],
      result: EnotesDetails.fromJson(json['result']),
      message: json['message'],
      code: json['code'],
    );
  }
  factory ENotesDetailsResponse.withError(String message) {
    return ENotesDetailsResponse(
      success: false,
      result: EnotesDetails(
        id: 0,
        code: '',
        title: '',
        bookCategoryId: 0,
        bookFormat: '',
        sellingPrice: '',
        status: 0,
        totalReview: 0,
        totalRating: 0,
        averageRating: '',
        totalChapters: 0,
        languageId: 0,
        length: '',
        shortDescription: null,
        description: '',
        language: '',
        category: '',
        contributorId: 0,
        magazineId: 0,
        contributor: '',
        publisher: '',
        publicationName: '',
        releasedDate: '',
        isBookmarked: false,
        isBought: false,
        articleList: [],
        reviewUrl: '',
        profilePic: '',
        subscriptions: [],
        tags: [],
        awards: [],
      ),
      message: message,
      code: 0,
    );
  }

  Map<String, dynamic> toJson() => {
        'success': success,
        'result': result.toJson(),
        'message': message,
        'code': code,
      };
}

class EnotesDetails {
  int id;
  String code;
  String title;
  int bookCategoryId;
  String bookFormat;
  String sellingPrice;
  int status;
  int totalReview;
  int totalRating;
  String averageRating;
  int totalChapters;
  int languageId;
  String length;
  String? shortDescription;
  String description;
  String language;
  String category;
  int contributorId;
  int magazineId;
  String contributor;
  String publisher;
  String publicationName;
  String releasedDate;
  bool isBookmarked;
  bool isBought;
  List<dynamic> articleList;
  String reviewUrl;
  String profilePic;
  List<dynamic> subscriptions;
  List<Tag> tags;
  List<Award> awards;

  EnotesDetails({
    required this.id,
    required this.code,
    required this.title,
    required this.bookCategoryId,
    required this.bookFormat,
    required this.sellingPrice,
    required this.status,
    required this.totalReview,
    required this.totalRating,
    required this.averageRating,
    required this.totalChapters,
    required this.languageId,
    required this.length,
    this.shortDescription,
    required this.description,
    required this.language,
    required this.category,
    required this.contributorId,
    required this.magazineId,
    required this.contributor,
    required this.publisher,
    required this.publicationName,
    required this.releasedDate,
    required this.isBookmarked,
    required this.isBought,
    required this.articleList,
    required this.reviewUrl,
    required this.profilePic,
    required this.subscriptions,
    required this.tags,
    required this.awards,
  });

  factory EnotesDetails.fromJson(Map<String, dynamic> json) {
    return EnotesDetails(
      id: json['id'],
      code: json['code'],
      title: json['title'],
      bookCategoryId: json['book_category_id'],
      bookFormat: json['book_format'],
      sellingPrice: json['selling_price'],
      status: json['status'],
      totalReview: json['total_review'],
      totalRating: json['total_rating'],
      averageRating: json['average_rating'],
      totalChapters: json['total_chapters'],
      languageId: json['language_id'],
      length: json['length'],
      shortDescription: json['short_description'],
      description: json['description'],
      language: json['language'],
      category: json['category'],
      contributorId: json['contributor_id'],
      magazineId: json['magazine_id'],
      contributor: json['contributor'],
      publisher: json['publisher'],
      publicationName: json['publication_name'],
      releasedDate: json['released_date'],
      isBookmarked: json['is_bookmarked'],
      isBought: json['is_bought'],
      articleList: List<dynamic>.from(json['article_list']),
      reviewUrl: json['review_url'],
      profilePic: json['profile_pic'],
      subscriptions: List<dynamic>.from(json['subscriptions']),
      tags: List<Tag>.from(json['tags'].map((x) => Tag.fromJson(x))),
      awards: List<Award>.from(json['awards'].map((x) => Award.fromJson(x))),
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'code': code,
        'title': title,
        'book_category_id': bookCategoryId,
        'book_format': bookFormat,
        'selling_price': sellingPrice,
        'status': status,
        'total_review': totalReview,
        'total_rating': totalRating,
        'average_rating': averageRating,
        'total_chapters': totalChapters,
        'language_id': languageId,
        'length': length,
        'short_description': shortDescription,
        'description': description,
        'language': language,
        'category': category,
        'contributor_id': contributorId,
        'magazine_id': magazineId,
        'contributor': contributor,
        'publisher': publisher,
        'publication_name': publicationName,
        'released_date': releasedDate,
        'is_bookmarked': isBookmarked,
        'is_bought': isBought,
        'article_list': List<dynamic>.from(articleList),
        'review_url': reviewUrl,
        'profile_pic': profilePic,
        'subscriptions': List<dynamic>.from(subscriptions),
        'tags': List<dynamic>.from(tags.map((x) => x.toJson())),
        'awards': List<dynamic>.from(awards.map((x) => x.toJson())),
      };
}
