class LibraryHomeBanner {
  final int id;
  final String title;
  final String ownerName;
  final int libraryTypeId;
  final String profilePic;
  final String bannerPic;
  final int noOfBooks;
  final int totalMembers;
  final String? membershipAmount;
  final String? about;
  final int status;
  final int isMember;
  final String libraryType;
  final int totalReview;
  final int totalRating;
  final String averageRating;
  final String template;

  LibraryHomeBanner({
    required this.id,
    required this.title,
    required this.ownerName,
    required this.libraryTypeId,
    required this.profilePic,
    required this.bannerPic,
    required this.noOfBooks,
    required this.totalMembers,
    this.membershipAmount,
    this.about,
    required this.status,
    required this.isMember,
    required this.libraryType,
    required this.totalReview,
    required this.totalRating,
    required this.averageRating,
    required this.template,
  });

  factory LibraryHomeBanner.fromJson(Map<String, dynamic> json) {
    return LibraryHomeBanner(
      id: json['id'] ?? 0,
      title: json['title'] ?? '',
      ownerName: json['owner_name'] ?? '',
      libraryTypeId: json['library_type_id'] ?? 0,
      profilePic: json['profile_pic'] ?? '',
      bannerPic: json['banner_pic'] ?? '',
      noOfBooks: json['no_of_books'] ?? 0,
      totalMembers: json['total_members'] ?? 0,
      membershipAmount: json['membership_amount']?.toString(),
      about: json['about'],
      status: json['status'] ?? 0,
      isMember: json['is_member'] ?? 0,
      libraryType: json['library_type'] ?? '',
      totalReview: json['total_review'] ?? 0,
      totalRating: json['total_rating'] ?? 0,
      averageRating: json['average_rating']?.toString() ?? '0.00',
      template: json['template'] ?? 'temp1',
    );
  }
}

class HomeBannerListResponse {
  final bool success;
  final List<LibraryHomeBanner> result;
  final String message;
  final int code;

  HomeBannerListResponse({
    required this.success,
    required this.result,
    required this.message,
    required this.code,
  });

  factory HomeBannerListResponse.fromJson(Map<String, dynamic> json) {
    return HomeBannerListResponse(
      success: json['success'] ?? false,
      result: (json['result'] as List?)
              ?.map((e) => LibraryHomeBanner.fromJson(e))
              .toList() ??
          [],
      message: json['message'] ?? '',
      code: json['code'] ?? 0,
    );
  }

  factory HomeBannerListResponse.withError(String message) {
    return HomeBannerListResponse(
      success: false,
      result: [],
      message: message,
      code: 0,
    );
  }
}

class LibraryHomeSection {
  final String title;
  final List<LibraryHomeBanner> libraries;

  LibraryHomeSection({
    required this.title,
    required this.libraries,
  });

  factory LibraryHomeSection.fromJson(Map<String, dynamic> json) {
    return LibraryHomeSection(
      title: json['title'] ?? '',
      libraries: (json['libraries'] as List?)
              ?.map((e) => LibraryHomeBanner.fromJson(e))
              .toList() ??
          [],
    );
  }
}

class HomeSectionListResponse {
  final bool success;
  final List<LibraryHomeSection> result;
  final String message;
  final int code;

  HomeSectionListResponse({
    required this.success,
    required this.result,
    required this.message,
    required this.code,
  });

  factory HomeSectionListResponse.fromJson(Map<String, dynamic> json) {
    return HomeSectionListResponse(
      success: json['success'] ?? false,
      result: (json['result'] as List?)
              ?.map((e) => LibraryHomeSection.fromJson(e))
              .toList() ??
          [],
      message: json['message'] ?? '',
      code: json['code'] ?? 0,
    );
  }

  factory HomeSectionListResponse.withError(String message) {
    return HomeSectionListResponse(
      success: false,
      result: [],
      message: message,
      code: 0,
    );
  }
}
