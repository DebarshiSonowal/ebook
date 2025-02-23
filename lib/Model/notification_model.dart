class NotificationResponseModel {
  bool? success;
  String? message;
  List<NotificationItem>? result;

  NotificationResponseModel.fromJson(Map<String, dynamic> json) {
    success = json['success'] ?? false;
    message = json['message'] ?? "";
    if (json['result'] != null) {
      result = <NotificationItem>[];
      json['result'].forEach((v) {
        result!.add(NotificationItem.fromJson(v));
      });
    }
  }

  NotificationResponseModel.withError(String msg) {
    success = false;
    message = msg;
    result = [];
  }
}

class NotificationItem {
  String? id;
  String? type;
  String? notifiableType;
  int? notifiableId;
  NotificationData? data;
  String? readAt;
  String? createdAt;
  String? updatedAt;

  NotificationItem.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    type = json['type'];
    notifiableType = json['notifiable_type'];
    notifiableId = json['notifiable_id'];
    data =
        json['data'] != null ? NotificationData.fromJson(json['data']) : null;
    readAt = json['read_at'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
  }
}

class NotificationData {
  String? title;
  String? type;
  int? id;
  String? bookFormat;
  String? headTitle;
  String? profilePic;
  String? contributorName;
  String? flipBookUrl;
  String? releasedDate;
  String? time;

  NotificationData.fromJson(Map<String, dynamic> json) {
    title = json['title'];
    type = json['type'];
    id = json['id'];
    bookFormat = json['book_format'];
    headTitle = json['head_title'];
    profilePic = json['profile_pic'];
    contributorName = json['contributor_name'];
    flipBookUrl = json['flip_book_url'];
    releasedDate = json['released_date'];
    time = json['time'];
  }
}
