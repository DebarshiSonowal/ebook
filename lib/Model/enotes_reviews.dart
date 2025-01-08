class EnotesReviewsResponse {
  final bool success;
  final Result result;
  final String message;
  final int code;

  EnotesReviewsResponse({
    required this.success,
    required this.result,
    required this.message,
    required this.code,
  });

  factory EnotesReviewsResponse.fromJson(Map<String, dynamic> json) {
    return EnotesReviewsResponse(
      success: json['success'],
      result: Result.fromJson(json['result']),
      message: json['message'],
      code: json['code'],
    );
  }
  factory EnotesReviewsResponse.withError(String errorMessage) {
    return EnotesReviewsResponse(
      success: false,
      result: Result(
        reviewList: [],
        currentPage: 0,
        lastPage: 0,
        perPage: 0,
        total: 0,
      ),
      message: errorMessage,
      code: 0,
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
  final List<Review> reviewList;
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
    return Result(
      reviewList:
          List<Review>.from(json['review_list'].map((x) => Review.fromJson(x))),
      currentPage: json['current_page'],
      lastPage: json['last_page'],
      perPage: json['per_page'],
      total: json['total'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'review_list': List<dynamic>.from(reviewList.map((x) => x.toJson())),
      'current_page': currentPage,
      'last_page': lastPage,
      'per_page': perPage,
      'total': total,
    };
  }
}

class Review {
  final int id;
  final int subscriberId;
  final String subscriber;
  final String content;
  final int rating;
  final DateTime createdAt;

  Review({
    required this.id,
    required this.subscriberId,
    required this.subscriber,
    required this.content,
    required this.rating,
    required this.createdAt,
  });

  factory Review.fromJson(Map<String, dynamic> json) {
    return Review(
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
