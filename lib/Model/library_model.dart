class LibraryModel {
  final bool success;
  final LibraryResult result;
  final String message;
  final int code;

  LibraryModel({
    required this.success,
    required this.result,
    required this.message,
    required this.code,
  });

  factory LibraryModel.fromJson(Map<String, dynamic> json) {
    return LibraryModel(
      success: json['success'] ?? false,
      result: LibraryResult.fromJson(json['result']),
      message: json['message'] ?? '',
      code: json['code'] ?? 0,
    );
  }
  factory LibraryModel.fromError(String message) {
    return LibraryModel(
      success: false,
      result: LibraryResult.fromJson({}),
      message: message,
      code: 0,
    );
  }
}

class LibraryResult {
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
  final int is_member;
  final int districtId;
  final int stateId;
  final String? pinCode;
  final String? profilePicFile;
  final String profilePic;
  final String? about;
  final int status;
  final String libraryType;
  final String memberRequestUrl;
  final String bookPublishRequestUrl;

  LibraryResult({
    required this.id,
    required this.is_member,
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
    this.about,
    required this.status,
    required this.libraryType,
    required this.memberRequestUrl,
    required this.bookPublishRequestUrl,
  });

  factory LibraryResult.fromJson(Map<String, dynamic> json) {
    return LibraryResult(
      id: json['id'] ?? 0,
      is_member: json['is_member'] ?? 0,
      code: json['code'] ?? '',
      title: json['title'] ?? '',
      ownerName: json['owner_name'] ?? '',
      libraryTypeId: json['library_type_id'] ?? 0,
      contactName: json['contact_name'] ?? '',
      mobile: json['mobile'] ?? '',
      altMobile: json['alt_mobile'],
      whatsappNo: json['whatsapp_no'],
      email: json['email'] ?? '',
      address: json['address'] ?? '',
      cityId: json['city_id'] ?? 0,
      districtId: json['district_id'] ?? 0,
      stateId: json['state_id'] ?? 0,
      pinCode: json['pin_code'],
      profilePicFile: json['profile_pic_file'],
      profilePic: json['profile_pic'] ?? '',
      about: json['about'],
      status: json['status'] ?? 0,
      libraryType: json['library_type'] ?? '',
      memberRequestUrl: json['member_request_url'] ?? 'https://tratri.in/',
      bookPublishRequestUrl:
          json['book_publish_request_url'] ?? 'https://tratri.in/',
    );
  }
}
