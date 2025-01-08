//
import 'home_banner.dart';

class EnoteSectionResponse {
  bool success;
  List<EnotesSection> result;
  String message;
  int code;

  EnoteSectionResponse({
    required this.success,
    required this.result,
    required this.message,
    required this.code,
  });

  factory EnoteSectionResponse.fromJson(Map<String, dynamic> json) {
    return EnoteSectionResponse(
      success: json['success'],
      result: (json['result'] as List)
          .map((e) => EnotesSection.fromJson(e))
          .toList(),
      message: json['message'],
      code: json['code'],
    );
  }
  factory EnoteSectionResponse.withError(String message) {
    return EnoteSectionResponse(
      success: false,
      result: [],
      message: message,
      code: 0,
    );
  }

  // Map<String, dynamic> toJson() {
  //   return {
  //     'success': success,
  //     'result': result.map((e) => e.toJson()).toList(),
  //     'message': message,
  //     'code': code,
  //   };
  // }
}

class EnotesSection {
  String title;
  List<Book> books;

  EnotesSection({
    required this.title,
    required this.books,
  });

  factory EnotesSection.fromJson(Map<String, dynamic> json) {
    return EnotesSection(
      title: json['title'],
      books: (json['books'] as List).map((e) => Book.fromJson(e)).toList(),
    );
  }

  // Map<String, dynamic> toJson() {
  //   return {
  //     'title': title,
  //     'books': books.map((e) => e.toJson()).toList(),
  //   };
  // }
}

// class Book {
//   int id;
//   String title;
//   int bookCategoryId;
//   int contributorId;
//   int magazineId;
//   String contributor;
//   String bookFormat;
//   String category;
//   String profilePic;
//   String sellingPrice;
//   String basePrice;
//   String discount;
//   int totalRating;
//   String averageRating;
//   int totalChapters;
//   int languageId;
//   String language;
//   String description;
//   String shortDescription;
//   String length;
//   int status;
//   bool isBookmarked;
//   bool isBought;
//   String lengtha;
//   int noOfArticles;
//   List<Tag> tags;
//   List<Award> awards;
//   List<dynamic> subscriptions;
//
//   Book({
//     required this.id,
//     required this.title,
//     required this.bookCategoryId,
//     required this.contributorId,
//     required this.magazineId,
//     required this.contributor,
//     required this.bookFormat,
//     required this.category,
//     required this.profilePic,
//     required this.sellingPrice,
//     required this.basePrice,
//     required this.discount,
//     required this.totalRating,
//     required this.averageRating,
//     required this.totalChapters,
//     required this.languageId,
//     required this.language,
//     required this.description,
//     required this.shortDescription,
//     required this.length,
//     required this.status,
//     required this.isBookmarked,
//     required this.isBought,
//     required this.lengtha,
//     required this.noOfArticles,
//     required this.tags,
//     required this.awards,
//     required this.subscriptions,
//   });
//
//   factory Book.fromJson(Map<String, dynamic> json) {
//     return Book(
//       id: json['id'],
//       title: json['title'],
//       bookCategoryId: json['book_category_id'],
//       contributorId: json['contributor_id'],
//       magazineId: json['magazine_id'],
//       contributor: json['contributor'],
//       bookFormat: json['book_format'],
//       category: json['category'],
//       profilePic: json['profile_pic'],
//       sellingPrice: json['selling_price'],
//       basePrice: json['base_price'],
//       discount: json['discount'],
//       totalRating: json['total_rating'],
//       averageRating: json['average_rating'],
//       totalChapters: json['total_chapters'],
//       languageId: json['language_id'],
//       language: json['language'],
//       description: json['description'],
//       shortDescription: json['short_description'],
//       length: json['length'],
//       status: json['status'],
//       isBookmarked: json['is_bookmarked'],
//       isBought: json['is_bought'],
//       lengtha: json['lengtha'],
//       noOfArticles: json['no_of_articles'],
//       tags: (json['tags'] as List).map((e) => Tag.fromJson(e)).toList(),
//       awards: (json['awards'] as List).map((e) => Award.fromJson(e)).toList(),
//       subscriptions: json['subscriptions'],
//     );
//   }
//
//   Map<String, dynamic> toJson() {
//     return {
//       'id': id,
//       'title': title,
//       'book_category_id': bookCategoryId,
//       'contributor_id': contributorId,
//       'magazine_id': magazineId,
//       'contributor': contributor,
//       'book_format': bookFormat,
//       'category': category,
//       'profile_pic': profilePic,
//       'selling_price': sellingPrice,
//       'base_price': basePrice,
//       'discount': discount,
//       'total_rating': totalRating,
//       'average_rating': averageRating,
//       'total_chapters': totalChapters,
//       'language_id': languageId,
//       'language': language,
//       'description': description,
//       'short_description': shortDescription,
//       'length': length,
//       'status': status,
//       'is_bookmarked': isBookmarked,
//       'is_bought': isBought,
//       'lengtha': lengtha,
//       'no_of_articles': noOfArticles,
//       'tags': tags.map((e) => e.toJson()).toList(),
//       'awards': awards.map((e) => e.toJson()).toList(),
//       'subscriptions': subscriptions,
//     };
//   }
// }

// class Tag {
//   int id;
//   String name;
//
//   Tag({
//     required this.id,
//     required this.name,
//   });
//
//   factory Tag.fromJson(Map<String, dynamic> json) {
//     return Tag(
//       id: json['id'],
//       name: json['name'],
//     );
//   }
//
//   Map<String, dynamic> toJson() {
//     return {
//       'id': id,
//       'name': name,
//     };
//   }
// }
//
// class Award {
//   int id;
//   String name;
//
//   Award({
//     required this.id,
//     required this.name,
//   });
//
//   factory Award.fromJson(Map<String, dynamic> json) {
//     return Award(
//       id: json['id'],
//       name: json['name'],
//     );
//   }
//
//   Map<String, dynamic> toJson() {
//     return {
//       'id': id,
//       'name': name,
//     };
//   }
// }
