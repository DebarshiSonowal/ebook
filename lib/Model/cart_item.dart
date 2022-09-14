class CartItem {
  int? item_id, in_stock, item_quantity;
  String? item_code, name, item_image;
  double? item_unit_cost, price_total;

  CartItem.fromJson(json) {
    //int
    item_id = json['item_id'] ?? 0;
    in_stock = json['in_stock'] ?? 0;
    item_quantity = json['item_quantity'] == null
        ? 0
        : int.parse(json['item_quantity'].toString());

    //String
    item_code = json['item_code'] ?? "";
    name = json['name'] ?? "";
    item_image = json['item_image'] ?? "";

    //double
    item_unit_cost = json['item_unit_cost'] == null
        ? 0
        : double.parse(json['item_unit_cost'].toString());
    price_total = json['price_total'] == null
        ? 0
        : double.parse(json['price_total'].toString());
  }
}

class Cart {
  int? count;
  double? final_amount;
  String? total_price;
  bool? has_change_exist;
  List<CartItem> items = [];

  Cart.fromJson(json) {
    count = json['count'] ?? 0;

    //double
    total_price =
        json['total_price'] == null ? '0' : json['total_price'].toString();
    final_amount = json['final_amount'] == null
        ? 0
        : double.parse(json['final_amount'].toString());
    //bool
    has_change_exist = json['has_change_exist'] ?? false;

    //list
    print(json['items']);
    items = json['items'] == null
        ? []
        : (json['items'] as List).map((e) => CartItem.fromJson(e)).toList();
  }
}

class CartResponse {
  bool? status;
  String? message;
  Cart? cart;

  CartResponse.fromJson(json) {
    status = json['success'] ?? false;
    message = json['message'] ?? "Something went wrong";
    cart = Cart.fromJson(json['result']);
  }

  CartResponse.withError(msg) {
    status = false;
    message = msg ?? "Something went wrong";
  }
}
