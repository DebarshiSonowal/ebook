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
  // final String code;
  final String title;
  // final String contactName;
  // final String mobile;
  // final String altMobile;
  // final String whatsappNo;
  // final String email;
  // final String password;
  // final String? rememberToken;
  // final String address;
  // final int cityId;
  // final int districtId;
  // final int stateId;
  // final String pinCode;
  // final int status;
  // final DateTime createdAt;
  // final DateTime updatedAt;

  Library({
    required this.id,
    // required this.code,
    required this.title,
    // required this.contactName,
    // required this.mobile,
    // required this.altMobile,
    // required this.whatsappNo,
    // required this.email,
    // required this.password,
    // this.rememberToken,
    // required this.address,
    // required this.cityId,
    // required this.districtId,
    // required this.stateId,
    // required this.pinCode,
    // required this.status,
    // required this.createdAt,
    // required this.updatedAt,
  });

  factory Library.fromJson(Map<String, dynamic> json) {
    return Library(
      id: json['id'],
      // code: json['code'],
      title: json['title'],
      // contactName: json['contact_name'],
      // mobile: json['mobile'],
      // altMobile: json['alt_mobile'],
      // whatsappNo: json['whatsapp_no'],
      // email: json['email'],
      // password: json['password'],
      // rememberToken: json['remember_token'],
      // address: json['address'],
      // cityId: json['city_id'],
      // districtId: json['district_id'],
      // stateId: json['state_id'],
      // pinCode: json['pin_code'],
      // status: json['status'],
      // createdAt: DateTime.parse(json['created_at']),
      // updatedAt: DateTime.parse(json['updated_at']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      // 'code': code,
      'title': title,
      // 'contact_name': contactName,
      // 'mobile': mobile,
      // 'alt_mobile': altMobile,
      // 'whatsapp_no': whatsappNo,
      // 'email': email,
      // 'password': password,
      // 'remember_token': rememberToken,
      // 'address': address,
      // 'city_id': cityId,
      // 'district_id': districtId,
      // 'state_id': stateId,
      // 'pin_code': pinCode,
      // 'status': status,
      // 'created_at': createdAt.toIso8601String(),
      // 'updated_at': updatedAt.toIso8601String(),
    };
  }
}
