class LibraryReviewsResponse {
  final bool success;
  final LibraryReviewsResult result;
  final String message;
  final int code;

  LibraryReviewsResponse({
    required this.success,
    required this.result,
    required this.message,
    required this.code,
  });

  factory LibraryReviewsResponse.fromJson(Map<String, dynamic> json) {
    return LibraryReviewsResponse(
      success: json['success'] ?? false,
      result: LibraryReviewsResult.fromJson(json['result'] ?? {}),
      message: json['message'] ?? '',
      code: json['code'] ?? 0,
    );
  }

  factory LibraryReviewsResponse.withError(String errorMessage) {
    return LibraryReviewsResponse(
      success: false,
      result: LibraryReviewsResult(
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

class LibraryReviewsResult {
  final List<LibraryReview> reviewList;
  final int currentPage;
  final int lastPage;
  final int perPage;
  final int total;

  LibraryReviewsResult({
    required this.reviewList,
    required this.currentPage,
    required this.lastPage,
    required this.perPage,
    required this.total,
  });

  factory LibraryReviewsResult.fromJson(Map<String, dynamic> json) {
    return LibraryReviewsResult(
      reviewList: (json['review_list'] as List<dynamic>? ?? [])
          .map((x) => LibraryReview.fromJson(x))
          .toList(),
      currentPage: json['current_page'] ?? 0,
      lastPage: json['last_page'] ?? 0,
      perPage: json['per_page'] ?? 0,
      total: json['total'] ?? 0,
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

class LibraryReview {
  final int id;
  final int subscriberId;
  final String subscriber;
  final String content;
  final int rating;
  final DateTime createdAt;

  LibraryReview({
    required this.id,
    required this.subscriberId,
    required this.subscriber,
    required this.content,
    required this.rating,
    required this.createdAt,
  });

  factory LibraryReview.fromJson(Map<String, dynamic> json) {
    return LibraryReview(
      id: json['id'] ?? 0,
      subscriberId: json['subscriber_id'] ?? 0,
      subscriber: json['subscriber'] ?? '',
      content: json['content'] ?? '',
      rating: json['rating'] ?? 0,
      createdAt: DateTime.tryParse(json['created_at'] ?? '') ?? DateTime.now(),
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