class LibraryList {
  final bool success;
  final List<Library> result;
  final String message;
  final int code;

  LibraryList({
    required this.success,
    required this.result,
    required this.message,
    required this.code,
  });

  factory LibraryList.fromJson(Map<String, dynamic> json) {
    return LibraryList(
      success: json['success'] as bool,
      result: (json['result'] as List)
          .map((item) => Library.fromJson(item as Map<String, dynamic>))
          .toList(),
      message: json['message'] as String,
      code: json['code'] as int,
    );
  }

  factory LibraryList.fromError(String message) {
    return LibraryList(
      success: false,
      result: [],
      message: message,
      code: 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'success': success,
      'result': result.map((library) => library.toJson()).toList(),
      'message': message,
      'code': code,
    };
  }
}

class Library {
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
  final String? profilePicFile;
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

  Library({
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
    this.profilePicFile,
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

  factory Library.fromJson(Map<String, dynamic> json) {
    return Library(
      id: json['id'],
      code: json['code'],
      title: json['title'],
      ownerName: json['owner_name'],
      libraryTypeId: json['library_type_id'],
      contactName: json['contact_name'],
      mobile: json['mobile'],
      altMobile: json['alt_mobile'],
      whatsappNo: json['whatsapp_no'],
      email: json['email'],
      address: json['address'],
      cityId: json['city_id'],
      districtId: json['district_id'],
      stateId: json['state_id'],
      pinCode: json['pin_code'],
      profilePicFile: json['profile_pic_file'],
      profilePic: json['profile_pic'],
      noOfBooks: json['no_of_books'],
      isFree: json['is_free'],
      membershipAmount: json['membership_amount'],
      about: json['about'],
      status: json['status'],
      memberRequestUrl: json['member_request_url'],
      bookPublishRequestUrl: json['book_publish_request_url'],
      isMember: json['is_member'],
      libraryType: json['library_type'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'code': code,
      'title': title,
      'owner_name': ownerName,
      'library_type_id': libraryTypeId,
      'contact_name': contactName,
      'mobile': mobile,
      'alt_mobile': altMobile,
      'whatsapp_no': whatsappNo,
      'email': email,
      'address': address,
      'city_id': cityId,
      'district_id': districtId,
      'state_id': stateId,
      'pin_code': pinCode,
      'profile_pic_file': profilePicFile,
      'profile_pic': profilePic,
      'no_of_books': noOfBooks,
      'is_free': isFree,
      'membership_amount': membershipAmount,
      'about': about,
      'status': status,
      'member_request_url': memberRequestUrl,
      'book_publish_request_url': bookPublishRequestUrl,
      'is_member': isMember,
      'library_type': libraryType,
    };
  }
}
