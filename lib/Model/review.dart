class ReviewResponse {
  bool? status;
  int? current_page, last_page, per_page, total;
  List<Review>? reviews;

  ReviewResponse.fromJson(json) {
    status = true;
    current_page = json['current_page'] ?? 0;
    last_page = json['last_page'] ?? 0;
    per_page = json['per_page'] ?? 0;
    total = json['total'] ?? 0;
    reviews = json['result']['review_list'] == null
        ? []
        : (json['result']['review_list'] as List).map((e) => Review.fromJson(e)).toList();
  }
  ReviewResponse.withError(){
    status=false;
  }
}

class Review {
  int? id, subscriber_id;
  String? subscriber, content;
  double? rating;

  Review.fromJson(json) {
    id = json['id'] ?? 0;
    subscriber_id = json['subscriber_id'] ?? 0;
    subscriber = json['subscriber'] ?? "";
    content = json['content'] ?? "";
    rating = double.parse(json['rating'].toString());
  }
}
