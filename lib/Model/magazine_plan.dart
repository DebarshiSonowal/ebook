class MagazinePlan {
  int? id, contributor_id, no_of_issues, is_percent, status;
  String? title, note;
  double? unit_price, discount, total_discounted_price;

  MagazinePlan.fromJson(json) {
    id = json['id'] ?? 0;
    contributor_id = json['contributor_id'] == null
        ? 0
        : int.parse(json['contributor_id'].toString());
    no_of_issues = json['no_of_issues'] == null
        ? 0
        : int.parse(json['no_of_issues'].toString());
    is_percent = json['is_percent'] == null
        ? 0
        : int.parse(json['is_percent'].toString());
    status = json['status'] == null ? 0 : int.parse(json['status'].toString());

    //String

    title = json['title'] ?? "";
    note = json['note'] ?? "";

    //double
    unit_price = json['unit_price'] == null
        ? 0
        : double.parse(json['unit_price'].toString());
    discount = json['discount'] == null
        ? 0
        : double.parse(json['discount'].toString());
    total_discounted_price = json['total_discounted_price'] == null
        ? 0
        : double.parse(json['total_discounted_price'].toString());
  }
}

class MagazinePlanResponse {
  bool? status;
  String? message;
  List<MagazinePlan>? chapters;

  MagazinePlanResponse.fromJson(json) {
    status = json['success'] ?? false;
    message = json['message'] ?? "Something went wrong";
    chapters = json['result'] == null
        ? []
        : (json['result'] as List)
            .map((e) => MagazinePlan.fromJson(e))
            .toList();
  }

  MagazinePlanResponse.withError(msg) {
    status = false;
    message = msg ?? "Something went wrong";
  }
}
