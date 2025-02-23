class Subscription {
  String? title;
  int? id;
  double? amount;

  Subscription.fromJson(json) {
    title = json['title'] ?? "";
    id = json['id'] ?? 0;
    amount = json['amount'] == null
        ? double.parse("0")
        : double.parse(json['amount'].toString());
  }
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['title'] = this.title;
    data['id'] = this.id;
    data['amount'] = this.amount;
    return data;
  }
}
