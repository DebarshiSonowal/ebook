class Discount {
  int? id, is_percent, discount_type, is_one_time_use, status;
  String? title, coupon, note, valid_from, valid_to;

  Discount.fromJson(json) {
    id = json['id'] ?? 0;
    is_percent = json['is_percent'] == null ? 0 : int.parse(json['is_percent']);
    discount_type =
        json['discount_type'] == null ? 0 : int.parse(json['discount_type']);
    is_one_time_use = json['is_one_time_use'] == null
        ? 0
        : int.parse(json['is_one_time_use']);
    status = json['status'] == null ? 0 : int.parse(json['status']);

    //String
    title = json['title'] ?? "";
    coupon = json['coupon'] ?? "";
    note = json['note'] ?? "";
    valid_from = json['valid_from'] ?? "";
    valid_to = json['valid_to'] ?? "";
  }
}

class DiscountResponse {
  bool? status;
  String? message;
  List<Discount>? cupons;

  DiscountResponse.fromJson(json) {
    status = json['success'] ?? false;
    message = json['message'] ?? "Something went wrong";
    cupons = json['result'] == null
        ? []
        : (json['result'] as List)
            .map((e) => Discount.fromJson(json['result']))
            .toList();
  }

  DiscountResponse.withError(msg) {
    status = false;
    message = msg ?? "Something went wrong";
  }
}
