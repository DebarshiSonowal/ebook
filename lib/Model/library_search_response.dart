class LibrarySearchResponse {
  final bool success;
  final LibrarySearchResult result;
  final String message;
  final int code;

  LibrarySearchResponse({
    required this.success,
    required this.result,
    required this.message,
    required this.code,
  });

  factory LibrarySearchResponse.fromJson(Map<String, dynamic> json) {
    return LibrarySearchResponse(
      success: json['success'] as bool,
      result:
          LibrarySearchResult.fromJson(json['result'] as Map<String, dynamic>),
      message: json['message'] as String,
      code: json['code'] as int,
    );
  }

  factory LibrarySearchResponse.fromError(String message) {
    return LibrarySearchResponse(
      success: false,
      result: LibrarySearchResult(
        bookList: [],
        currentPage: 1,
        lastPage: 1,
        perPage: 0,
        total: 0,
      ),
      message: message,
      code: 0,
    );
  }
}

class LibrarySearchResult {
  final List<LibrarySearchItem> bookList;
  final int currentPage;
  final int lastPage;
  final int perPage;
  final int total;

  LibrarySearchResult({
    required this.bookList,
    required this.currentPage,
    required this.lastPage,
    required this.perPage,
    required this.total,
  });

  factory LibrarySearchResult.fromJson(Map<String, dynamic> json) {
    return LibrarySearchResult(
      bookList: (json['book_list'] as List)
          .map((item) =>
              LibrarySearchItem.fromJson(item as Map<String, dynamic>))
          .toList(),
      currentPage: json['current_page'] as int,
      lastPage: json['last_page'] as int,
      perPage: json['per_page'] as int,
      total: json['total'] as int,
    );
  }
}

class LibrarySearchItem {
  final int id;
  final String code;
  final String title;
  final String ownerName;
  final int libraryTypeId;
  final String contactName;
  final String mobile;
  final String? altMobile;
  final String? whatsappNo;
  final String email;
  final String? address;
  final int cityId;
  final int districtId;
  final int stateId;
  final String? pinCode;
  final String? profilePicFile; // Made nullable
  final String profilePic;
  final int noOfBooks;
  final int isFree;
  final String membershipAmount;
  final String? about;
  final int status;
  final String memberRequestUrl;
  final String bookPublishRequestUrl;
  final int isMember;
  final String libraryType;

  LibrarySearchItem({
    required this.id,
    required this.code,
    required this.title,
    required this.ownerName,
    required this.libraryTypeId,
    required this.contactName,
    required this.mobile,
    this.altMobile,
    this.whatsappNo,
    required this.email,
    this.address,
    required this.cityId,
    required this.districtId,
    required this.stateId,
    this.pinCode,
    this.profilePicFile, // Made nullable
    required this.profilePic,
    required this.noOfBooks,
    required this.isFree,
    required this.membershipAmount,
    this.about,
    required this.status,
    required this.memberRequestUrl,
    required this.bookPublishRequestUrl,
    required this.isMember,
    required this.libraryType,
  });

  factory LibrarySearchItem.fromJson(Map<String, dynamic> json) {
    return LibrarySearchItem(
      id: json['id'] as int,
      code: json['code'] as String,
      title: json['title'] as String,
      ownerName: json['owner_name'] as String,
      libraryTypeId: json['library_type_id'] as int,
      contactName: json['contact_name'] as String,
      mobile: json['mobile'] as String,
      altMobile: json['alt_mobile'] as String?,
      whatsappNo: json['whatsapp_no'] as String?,
      email: json['email'] as String,
      address: json['address'] as String?,
      cityId: json['city_id'] as int,
      districtId: json['district_id'] as int,
      stateId: json['state_id'] as int,
      pinCode: json['pin_code'] as String?,
      profilePicFile: json['profile_pic_file'] as String?,
      // Made nullable
      profilePic: json['profile_pic'] as String,
      noOfBooks: json['no_of_books'] as int,
      isFree: json['is_free'] as int,
      membershipAmount: json['membership_amount'] as String,
      about: json['about'] as String?,
      status: json['status'] as int,
      memberRequestUrl: json['member_request_url'] as String,
      bookPublishRequestUrl: json['book_publish_request_url'] as String,
      isMember: json['is_member'] as int,
      libraryType: json['library_type'] as String,
    );
  }
}
