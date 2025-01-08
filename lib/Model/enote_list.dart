import 'home_banner.dart';

class EnoteListResponse {
  bool success;
  EnoteResultList result;
  String message;
  int code;

  EnoteListResponse({
    required this.success,
    required this.result,
    required this.message,
    required this.code,
  });

  factory EnoteListResponse.fromJson(Map<String, dynamic> json) {
    return EnoteListResponse(
      success: json['success'],
      result: EnoteResultList.fromJson(json['result']),
      message: json['message'],
      code: json['code'],
    );
  }
  factory EnoteListResponse.withError(String errorMessage) {
    return EnoteListResponse(
      success: false,
      result: EnoteResultList(
        bookList: [],
        currentPage: 0,
        lastPage: 0,
        perPage: 0,
        total: 0,
      ),
      message: errorMessage,
      code: 0,
    );
  }
  // Map<String, dynamic> toJson() {
  //   return {
  //     'success': success,
  //     'result': result.toJson(),
  //     'message': message,
  //     'code': code,
  //   };
  // }
}

class EnoteResultList {
  List<Book> bookList;
  int currentPage;
  int lastPage;
  int perPage;
  int total;

  EnoteResultList({
    required this.bookList,
    required this.currentPage,
    required this.lastPage,
    required this.perPage,
    required this.total,
  });

  factory EnoteResultList.fromJson(Map<String, dynamic> json) {
    return EnoteResultList(
      bookList: List<Book>.from(json['book_list'].map((x) => Book.fromJson(x))),
      currentPage: json['current_page'],
      lastPage: json['last_page'],
      perPage: json['per_page'],
      total: json['total'],
    );
  }

  // Map<String, dynamic> toJson() {
  //   return {
  //     'book_list': List<dynamic>.from(bookList.map((x) => x.toJson())),
  //     'current_page': currentPage,
  //     'last_page': lastPage,
  //     'per_page': perPage,
  //     'total': total,
  //   };
  // }
}

// class Book {
//   int id;
//   String code;
//   String title;
//   int bookCategoryId;
//   int contributorId;
//   String contributor;
//   String bookFormat;
//   String category;
//   int userId;
//   String approvedRejectedBy;
//   String publishDate;
//   int status;
//   int isCompleted;
//   String profilePic;
//   int totalReview;
//   int totalRating;
//   String averageRating;
//   int totalChapters;
//   int languageId;
//   String language;
//   String? length;
//   String? shortDescription;
//   String? description;
//   int isDownloadable;
//   bool isBought;
//   String sellingPrice;
//   bool isFree;
//   String basePrice;
//   String discount;
//   String lekhikaCode;
//
//   Book({
//     required this.id,
//     required this.code,
//     required this.title,
//     required this.bookCategoryId,
//     required this.contributorId,
//     required this.contributor,
//     required this.bookFormat,
//     required this.category,
//     required this.userId,
//     required this.approvedRejectedBy,
//     required this.publishDate,
//     required this.status,
//     required this.isCompleted,
//     required this.profilePic,
//     required this.totalReview,
//     required this.totalRating,
//     required this.averageRating,
//     required this.totalChapters,
//     required this.languageId,
//     required this.language,
//     this.length,
//     this.shortDescription,
//     this.description,
//     required this.isDownloadable,
//     required this.isBought,
//     required this.sellingPrice,
//     required this.isFree,
//     required this.basePrice,
//     required this.discount,
//     required this.lekhikaCode,
//   });
//
//   factory Book.fromJson(Map<String, dynamic> json) {
//     return Book(
//       id: json['id'],
//       code: json['code'],
//       title: json['title'],
//       bookCategoryId: json['book_category_id'],
//       contributorId: json['contributor_id'],
//       contributor: json['contributor'],
//       bookFormat: json['book_format'],
//       category: json['category'],
//       userId: json['user_id'],
//       approvedRejectedBy: json['approved_rejected_by'],
//       publishDate: json['publish_date'],
//       status: json['status'],
//       isCompleted: json['is_completed'],
//       profilePic: json['profile_pic'],
//       totalReview: json['total_review'],
//       totalRating: json['total_rating'],
//       averageRating: json['average_rating'],
//       totalChapters: json['total_chapters'],
//       languageId: json['language_id'],
//       language: json['language'],
//       length: json['length'],
//       shortDescription: json['short_description'],
//       description: json['description'],
//       isDownloadable: json['is_downloadable'],
//       isBought: json['is_bought'],
//       sellingPrice: json['selling_price'],
//       isFree: json['is_free'] == 1,
//       basePrice: json['base_price'],
//       discount: json['discount'],
//       lekhikaCode: json['lekhika_code'],
//     );
//   }
//
//   Map<String, dynamic> toJson() {
//     return {
//       'id': id,
//       'code': code,
//       'title': title,
//       'book_category_id': bookCategoryId,
//       'contributor_id': contributorId,
//       'contributor': contributor,
//       'book_format': bookFormat,
//       'category': category,
//       'user_id': userId,
//       'approved_rejected_by': approvedRejectedBy,
//       'publish_date': publishDate,
//       'status': status,
//       'is_completed': isCompleted,
//       'profile_pic': profilePic,
//       'total_review': totalReview,
//       'total_rating': totalRating,
//       'average_rating': averageRating,
//       'total_chapters': totalChapters,
//       'language_id': languageId,
//       'language': language,
//       'length': length,
//       'short_description': shortDescription,
//       'description': description,
//       'is_downloadable': isDownloadable,
//       'is_bought': isBought,
//       'selling_price': sellingPrice,
//       'is_free': isFree ? 1 : 0,
//       'base_price': basePrice,
//       'discount': discount,
//       'lekhika_code': lekhikaCode,
//     };
//   }
// }
