class Transaction {
  int? id, order_id;
  String? transaction_id, mode, date;
  double? amount;

  Transaction.fromJson(json) {
    id = json['id'] ?? 0;
    order_id =
        json['order_id'] == null ? 0 : int.parse(json['order_id'].toString());

    transaction_id = json['transaction_id'] ?? "";
    mode = json['mode'] ?? "";
    date = json['date'] ?? "";

    amount =
        json['amount'] == null ? 0 : double.parse(json['amount'].toString());
  }
}
