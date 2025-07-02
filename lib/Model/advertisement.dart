class AdvertisementResponse {
  bool? success;
  String? message;
  int? code;
  AdvertisementResult? result;

  AdvertisementResponse.fromJson(json) {
    success = json['success'] ?? false;
    message = json['message'] ?? "Something went wrong";
    code = json['code'] ?? 0;
    result = json['result'] != null
        ? AdvertisementResult.fromJson(json['result'])
        : null;
  }

  AdvertisementResponse.withError(msg) {
    success = false;
    message = msg ?? "Something went wrong";
    code = 0;
  }
}

class AdvertisementResult {
  int? adCount;
  List<Advertisement>? data;

  AdvertisementResult.fromJson(json) {
    adCount = json['ad_count'] ?? 0;
    data = json['data'] == null
        ? []
        : (json['data'] as List).map((e) => Advertisement.fromJson(e)).toList();
  }
}

class Advertisement {
  int? id;
  int? adId;
  bool? isInteractive;
  String? adType;
  String? content;
  String? redirectLink;

  Advertisement.fromJson(json) {
    id = json['id'] ?? 0;
    adId = json['ad_id'] ?? 0;
    isInteractive = json['is_interactive'] ?? false;
    adType = json['ad_type'] ?? "";
    content = json['content'] ?? "";
    redirectLink = json['redirect_link'] ?? "";
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'ad_id': adId,
      'is_interactive': isInteractive,
      'ad_type': adType,
      'content': content,
      'redirect_link': redirectLink,
    };
  }
}

class AdvertisementBannersResponse {
  bool? success;
  String? message;
  int? code;
  List<AdvertisementBanner>? result;

  AdvertisementBannersResponse.fromJson(json) {
    success = json['success'] ?? false;
    message = json['message'] ?? "Something went wrong";
    code = json['code'] ?? 0;
    result = json['result'] == null
        ? []
        : (json['result'] as List)
            .map((e) => AdvertisementBanner.fromJson(e))
            .toList();
  }

  AdvertisementBannersResponse.withError(msg) {
    success = false;
    message = msg ?? "Something went wrong";
    code = 0;
    result = [];
  }
}

class AdvertisementBanner {
  int? id;
  int? relatedId;
  String? adCategory;
  String? adType;
  String? content;
  String? redirectLink;

  AdvertisementBanner.fromJson(json) {
    id = json['id'] ?? 0;
    relatedId = json['related_id'] ?? 0;
    adCategory = json['ad_category'] ?? "";
    adType = json['ad_type'] ?? "";
    content = json['content'] ?? "";
    redirectLink = json['redirect_link'] ?? "";
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'related_id': relatedId,
      'ad_category': adCategory,
      'ad_type': adType,
      'content': content,
      'redirect_link': redirectLink,
    };
  }
}
