import 'discount.dart';

class ApplyCupon {
  bool? success;
  String? message;
  Discount? cupon;
  double? amount;

  ApplyCupon.fromJson(json) {
    success = json['success'] ?? false;

    message = json['message'] ?? "";

    cupon = Discount.fromJson(json['result']['data']);

    amount = double.parse(json['amount_after_discount'].toString());
  }

  ApplyCupon.withError(msg){
    success = false;
    message = msg;
  }
}
