class Invoice {
  int? id, order_id;
  double? amount;
  String? voucher_no, invoice_date;

  Invoice.fromJson(json) {
    id = json['id'] ?? 0;
    order_id =
        json['order_id'] == null ? 0 : int.parse(json['order_id'].toString());

    voucher_no = json['voucher_no'] ?? "";
    invoice_date = json['invoice_date'] ?? "";

    amount =
        json['amount'] == null ? 0 : double.parse(json['amount'].toString());
  }
}
