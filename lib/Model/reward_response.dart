class RewardResponse {
  bool? success;
  RewardResult? result;
  String? message;
  int? code;

  RewardResponse({this.success, this.result, this.message, this.code});

  RewardResponse.withError(String message) {
    this.success = false;
    this.message = message;
    this.code = 0;
  }

  RewardResponse.fromJson(Map<String, dynamic> json) {
    success = json['success'];
    result = json['result'] != null
        ? new RewardResult.fromJson(json['result'])
        : null;
    message = json['message'];
    code = json['code'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['success'] = this.success;
    if (this.result != null) {
      data['result'] = this.result!.toJson();
    }
    data['message'] = this.message;
    data['code'] = this.code;
    return data;
  }
}

class RewardResult {
  List<RewardList>? rewardList;
  List<String>? rules;
  int? totalPoints;
  bool? eligibleForTfr;

  RewardResult(
      {this.rewardList, this.rules, this.totalPoints, this.eligibleForTfr});

  RewardResult.fromJson(Map<String, dynamic> json) {
    if (json['reward_list'] != null) {
      rewardList = <RewardList>[];
      json['reward_list'].forEach((v) {
        rewardList!.add(new RewardList.fromJson(v));
      });
    }
    rules = json['rules'].cast<String>();
    totalPoints = json['total_points'];
    eligibleForTfr = json['eligible_for_tfr'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.rewardList != null) {
      data['reward_list'] = this.rewardList!.map((v) => v.toJson()).toList();
    }
    data['rules'] = this.rules;
    data['total_points'] = this.totalPoints;
    data['eligible_for_tfr'] = this.eligibleForTfr;
    return data;
  }
}

class RewardList {
  int? id;
  String? code;
  String? title;
  int? bookCategoryId;
  int? contributorId;
  String? contributor;
  String? bookFormat;
  String? category;
  int? userId;
  String? approvedRejectedBy;
  String? publishDate;
  int? status;
  int? isCompleted;
  String? profilePic;
  int? totalReview;
  int? totalRating;
  String? averageRating;
  int? totalChapters;
  int? languageId;
  String? language;
  String? length;
  String? shortDescription;
  String? description;
  int? isDownloadable;
  bool? isBought;
  String? sellingPrice;
  String? is_reward_in;
  int? isFree;
  String? basePrice;
  String? discount;
  String? flipBookUrl;
  String? lekhikaCode;
  String? chapterUpdatedAt;
  int? rewardPoint;

  RewardList({
    this.id,
    this.code,
    this.title,
    this.bookCategoryId,
    this.contributorId,
    this.contributor,
    this.bookFormat,
    this.category,
    this.userId,
    this.approvedRejectedBy,
    this.publishDate,
    this.status,
    this.isCompleted,
    this.profilePic,
    this.totalReview,
    this.totalRating,
    this.averageRating,
    this.totalChapters,
    this.languageId,
    this.language,
    this.length,
    this.shortDescription,
    this.description,
    this.isDownloadable,
    this.isBought,
    this.sellingPrice,
    this.isFree,
    this.basePrice,
    this.discount,
    this.flipBookUrl,
    this.lekhikaCode,
    this.chapterUpdatedAt,
    this.rewardPoint,
    this.is_reward_in,
  });

  RewardList.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    code = json['code'];
    title = json['title'];
    bookCategoryId = json['book_category_id'];
    contributorId = json['contributor_id'];
    contributor = json['contributor'];
    bookFormat = json['book_format'];
    category = json['category'];
    userId = json['user_id'];
    approvedRejectedBy = json['approved_rejected_by'];
    publishDate = json['publish_date'];
    status = json['status'];
    isCompleted = json['is_completed'];
    profilePic = json['profile_pic'];
    totalReview = json['total_review'];
    totalRating = json['total_rating'];
    averageRating = json['average_rating'];
    totalChapters = json['total_chapters'];
    languageId = json['language_id'];
    language = json['language'];
    length = json['length'];
    shortDescription = json['short_description'];
    description = json['description'];
    isDownloadable = json['is_downloadable'];
    isBought = json['is_bought'];
    sellingPrice = json['selling_price'];
    isFree = json['is_free'];
    basePrice = json['base_price'];
    discount = json['discount'];
    flipBookUrl = json['flip_book_url'];
    lekhikaCode = json['lekhika_code'];
    chapterUpdatedAt = json['chapter_updated_at'];
    rewardPoint = json['reward_point'];
    is_reward_in = json['is_reward_in'] ?? "out";
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['code'] = this.code;
    data['title'] = this.title;
    data['book_category_id'] = this.bookCategoryId;
    data['contributor_id'] = this.contributorId;
    data['contributor'] = this.contributor;
    data['book_format'] = this.bookFormat;
    data['category'] = this.category;
    data['user_id'] = this.userId;
    data['approved_rejected_by'] = this.approvedRejectedBy;
    data['publish_date'] = this.publishDate;
    data['status'] = this.status;
    data['is_completed'] = this.isCompleted;
    data['profile_pic'] = this.profilePic;
    data['total_review'] = this.totalReview;
    data['total_rating'] = this.totalRating;
    data['average_rating'] = this.averageRating;
    data['total_chapters'] = this.totalChapters;
    data['language_id'] = this.languageId;
    data['language'] = this.language;
    data['length'] = this.length;
    data['short_description'] = this.shortDescription;
    data['description'] = this.description;
    data['is_downloadable'] = this.isDownloadable;
    data['is_bought'] = this.isBought;
    data['selling_price'] = this.sellingPrice;
    data['is_free'] = this.isFree;
    data['base_price'] = this.basePrice;
    data['discount'] = this.discount;
    data['flip_book_url'] = this.flipBookUrl;
    data['lekhika_code'] = this.lekhikaCode;
    data['chapter_updated_at'] = this.chapterUpdatedAt;
    data['reward_point'] = this.rewardPoint;
    data['is_reward_in'] = this.is_reward_in;
    return data;
  }
}
