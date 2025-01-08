class EnoteBannerResponse {
  final bool success;
  final List<EnoteBanner> result;
  final String message;
  final int code;

  EnoteBannerResponse({
    required this.success,
    required this.result,
    required this.message,
    required this.code,
  });

  factory EnoteBannerResponse.fromJson(Map<String, dynamic> json) {
    return EnoteBannerResponse(
      success: json['success'],
      result: List<EnoteBanner>.from(
          json['result'].map((x) => EnoteBanner.fromJson(x))),
      message: json['message'],
      code: json['code'],
    );
  }
  factory EnoteBannerResponse.withError(String message) {
    return EnoteBannerResponse(
      success: false,
      result: [],
      message: message,
      code: 0,
    );
  }
  Map<String, dynamic> toJson() => {
        'success': success,
        'result': result.map((x) => x.toJson()).toList(),
        'message': message,
        'code': code,
      };
}

class EnoteBanner {
  final int id;
  final String title;
  final int bookCategoryId;
  final int contributorId;
  final int magazineId;
  final String contributor;
  final String bookFormat;
  final String category;
  final String profilePic;
  final String sellingPrice;
  final String basePrice;
  final String discount;
  final int totalRating;
  final String averageRating;
  final int totalChapters;
  final int languageId;
  final String language;
  final String description;
  final String shortDescription;
  final String length;
  final int status;
  final bool isBookmarked;
  final bool isBought;
  final String lengtha;
  final int noOfArticles;
  final List<Tag> tags;
  final List<Award> awards;
  final List<Subscription> subscriptions;

  EnoteBanner({
    required this.id,
    required this.title,
    required this.bookCategoryId,
    required this.contributorId,
    required this.magazineId,
    required this.contributor,
    required this.bookFormat,
    required this.category,
    required this.profilePic,
    required this.sellingPrice,
    required this.basePrice,
    required this.discount,
    required this.totalRating,
    required this.averageRating,
    required this.totalChapters,
    required this.languageId,
    required this.language,
    required this.description,
    required this.shortDescription,
    required this.length,
    required this.status,
    required this.isBookmarked,
    required this.isBought,
    required this.lengtha,
    required this.noOfArticles,
    required this.tags,
    required this.awards,
    required this.subscriptions,
  });

  factory EnoteBanner.fromJson(Map<String, dynamic> json) {
    return EnoteBanner(
      id: json['id'],
      title: json['title'],
      bookCategoryId: json['book_category_id'],
      contributorId: json['contributor_id'],
      magazineId: json['magazine_id'],
      contributor: json['contributor'],
      bookFormat: json['book_format'],
      category: json['category'],
      profilePic: json['profile_pic'],
      sellingPrice: json['selling_price'],
      basePrice: json['base_price'],
      discount: json['discount'],
      totalRating: json['total_rating'],
      averageRating: json['average_rating'],
      totalChapters: json['total_chapters'],
      languageId: json['language_id'],
      language: json['language'],
      description: json['description'],
      shortDescription: json['short_description'],
      length: json['length'],
      status: json['status'],
      isBookmarked: json['is_bookmarked'],
      isBought: json['is_bought'],
      lengtha: json['lengtha'],
      noOfArticles: json['no_of_articles'],
      tags: List<Tag>.from(json['tags'].map((x) => Tag.fromJson(x))),
      awards: List<Award>.from(json['awards'].map((x) => Award.fromJson(x))),
      subscriptions: List<Subscription>.from(
          json['subscriptions'].map((x) => Subscription.fromJson(x))),
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'title': title,
        'book_category_id': bookCategoryId,
        'contributor_id': contributorId,
        'magazine_id': magazineId,
        'contributor': contributor,
        'book_format': bookFormat,
        'category': category,
        'profile_pic': profilePic,
        'selling_price': sellingPrice,
        'base_price': basePrice,
        'discount': discount,
        'total_rating': totalRating,
        'average_rating': averageRating,
        'total_chapters': totalChapters,
        'language_id': languageId,
        'language': language,
        'description': description,
        'short_description': shortDescription,
        'length': length,
        'status': status,
        'is_bookmarked': isBookmarked,
        'is_bought': isBought,
        'lengtha': lengtha,
        'no_of_articles': noOfArticles,
        'tags': tags.map((x) => x.toJson()).toList(),
        'awards': awards.map((x) => x.toJson()).toList(),
        'subscriptions': subscriptions.map((x) => x.toJson()).toList(),
      };
}

class Tag {
  final int id;
  final String name;

  Tag({
    required this.id,
    required this.name,
  });

  factory Tag.fromJson(Map<String, dynamic> json) {
    return Tag(
      id: json['id'],
      name: json['name'],
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
      };
}

class Award {
  final int id;
  final String name;

  Award({
    required this.id,
    required this.name,
  });

  factory Award.fromJson(Map<String, dynamic> json) {
    return Award(
      id: json['id'],
      name: json['name'],
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
      };
}

class Subscription {
  Subscription();

  factory Subscription.fromJson(Map<String, dynamic> json) {
    return Subscription();
  }

  Map<String, dynamic> toJson() => {};
}
