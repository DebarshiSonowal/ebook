class RazorpayKey {


  String? active_mode, api_key, secret_key;
  int? is_active;

  RazorpayKey.fromJson(json) {
    is_active =
        json['is_active'] == null ? 1 : int.parse(json['is_active'].toString());

    //String
    active_mode = json['active_mode'] ?? "";
    api_key = json['api_key'] ?? "";
    secret_key = json['secret_key'] ?? "";
  }
}

class RazorpayResponse{
  bool? status;
  String? message;
  RazorpayKey? razorpay;

  RazorpayResponse.fromJson(json) {
    status = json['success'] ?? false;
    message = json['message'] ?? "Something went wrong";
    razorpay = RazorpayKey.fromJson(json['result']);
  }

  RazorpayResponse.withError(msg) {
    status = false;
    message = msg ?? "Something went wrong";
  }
}
