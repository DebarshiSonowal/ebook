class EnoteReviewListResponse {
  final bool success;
  final Result result;
  final String message;
  final int code;

  EnoteReviewListResponse({
    required this.success,
    required this.result,
    required this.message,
    required this.code,
  });

  factory EnoteReviewListResponse.fromJson(Map<String, dynamic> json) {
    return EnoteReviewListResponse(
      success: json['success'],
      result: Result.fromJson(json['result']),
      message: json['message'],
      code: json['code'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'success': success,
      'result': result.toJson(),
      'message': message,
      'code': code,
    };
  }
}

class Result {
  final List<EnoteReview> reviewList;
  final int currentPage;
  final int lastPage;
  final int perPage;
  final int total;

  Result({
    required this.reviewList,
    required this.currentPage,
    required this.lastPage,
    required this.perPage,
    required this.total,
  });

  factory Result.fromJson(Map<String, dynamic> json) {
    var list = json['review_list'] as List;
    List<EnoteReview> reviewList =
        list.map((i) => EnoteReview.fromJson(i)).toList();

    return Result(
      reviewList: reviewList,
      currentPage: json['current_page'],
      lastPage: json['last_page'],
      perPage: json['per_page'],
      total: json['total'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'review_list': reviewList.map((review) => review.toJson()).toList(),
      'current_page': currentPage,
      'last_page': lastPage,
      'per_page': perPage,
      'total': total,
    };
  }
}

class EnoteReview {
  final int id;
  final int subscriberId;
  final String subscriber;
  final String content;
  final int rating;
  final DateTime createdAt;

  EnoteReview({
    required this.id,
    required this.subscriberId,
    required this.subscriber,
    required this.content,
    required this.rating,
    required this.createdAt,
  });

  factory EnoteReview.fromJson(Map<String, dynamic> json) {
    return EnoteReview(
      id: json['id'],
      subscriberId: json['subscriber_id'],
      subscriber: json['subscriber'],
      content: json['content'],
      rating: json['rating'],
      createdAt: DateTime.parse(json['created_at']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'subscriber_id': subscriberId,
      'subscriber': subscriber,
      'content': content,
      'rating': rating,
      'created_at': createdAt.toIso8601String(),
    };
  }
}
