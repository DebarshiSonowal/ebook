class OrderItem {
  int? id, order_id, book_id, qty, tax_id, status;
  double? base_unit_price,
      base_selling_unit_price,
      discount,
      unit_price,
      selling_unit_price,
      base_total,
      base_selling_total,
      total,
      cgst,
      sgst,
      igst,
      cess,
      subtotal;
  String? book_format, product_data, created_at;

  OrderItem.fromJson(json) {
    id = json['id'] ?? 0;
    order_id =
        json['order_id'] == null ? 0 : int.parse(json['order_id'].toString());
    book_id =
        json['book_id'] == null ? 0 : int.parse(json['book_id'].toString());
    qty = json['qty'] == null ? 0 : int.parse(json['qty'].toString());
    tax_id = json['tax_id'] == null ? 0 : int.parse(json['tax_id'].toString());
    status = json['status'] == null ? 0 : int.parse(json['status'].toString());

    //double
    base_unit_price = json['base_unit_price'] == null
        ? 0
        : double.parse(json['base_unit_price'].toString());
    base_selling_unit_price = json['base_selling_unit_price'] == null
        ? 0
        : double.parse(json['base_selling_unit_price'].toString());
    discount = json['discount'] == null
        ? 0
        : double.parse(json['discount'].toString());
    unit_price = json['unit_price'] == null
        ? 0
        : double.parse(json['unit_price'].toString());
    selling_unit_price = json['selling_unit_price'] == null
        ? 0
        : double.parse(json['selling_unit_price'].toString());
    base_total = json['base_total'] == null
        ? 0
        : double.parse(json['base_total'].toString());
    base_selling_total = json['base_selling_total'] == null
        ? 0
        : double.parse(json['base_selling_total'].toString());
    total = json['total'] == null ? 0 : double.parse(json['total'].toString());
    cgst = json['cgst'] == null ? 0 : double.parse(json['cgst'].toString());
    sgst = json['sgst'] == null ? 0 : double.parse(json['sgst'].toString());
    igst = json['igst'] == null ? 0 : double.parse(json['igst'].toString());
    cess = json['cess'] == null ? 0 : double.parse(json['cess'].toString());
    subtotal = json['subtotal'] == null
        ? 0
        : double.parse(json['subtotal'].toString());

    //string
    book_format = json['book_format'] ?? "";
    product_data = json['product_data'] ?? "";
    created_at = json['created_at'] ?? "";
  }
}

class Order {

  int? id, subscriber_id, is_paid, discount_id, status;
  double? selling_total,
      base_total,
      discount,
      total,
      cgst,
      sgst,
      igst,
      cess,
      grand_total;
  String? voucher_no,order_date,addresses,discount_data,subscriber_pic,order_id;
  List<OrderItem> orderItems=[];

  Order.fromJson(json){
    id = json['id']??0;
    subscriber_id = json['subscriber_id']==null?0:int.parse(json['subscriber_id'].toString());
    is_paid = json['is_paid']==null?0:int.parse(json['is_paid'].toString());
    discount_id = json['discount_id']==null?0:int.parse(json['discount_id'].toString());
    status = json['status']==null?0:int.parse(json['status'].toString());

    //double
    selling_total = json['selling_total']==null?0:double.parse(json['selling_total'].toString());
    base_total = json['base_total']==null?0:double.parse(json['base_total'].toString());
    discount = json['discount']==null?0:double.parse(json['discount'].toString());
    total = json['total']==null?0:double.parse(json['total'].toString());
    cgst = json['cgst']==null?0:double.parse(json['cgst'].toString());
    sgst = json['sgst']==null?0:double.parse(json['sgst'].toString());
    igst = json['igst']==null?0:double.parse(json['igst'].toString());
    cess = json['cess']==null?0:double.parse(json['cess'].toString());
    grand_total = json['grand_total']==null?0:double.parse(json['grand_total'].toString());


    //string
    voucher_no = json['voucher_no']??"";
    order_date = json['order_date']??"";
    addresses = json['addresses']??"";
    discount_data = json['discount_data']??"";
    subscriber_pic = json['subscriber_pic']??"";
    order_id = json['order_id']??"";

    //list
    orderItems = json['order_list']==null?[]:(json['order_list'] as List).map((e) => OrderItem.fromJson(e)).toList();
  }
}
class OrderResponse{
  bool? status;
  String? message;
  Order? order;

  OrderResponse.fromJson(json) {
    status = json['success'] ?? false;
    message = json['message'] ?? "Something went wrong";
    order = Order.fromJson(json['result']);
  }

  OrderResponse.withError(msg) {
    status = false;
    message = msg ?? "Something went wrong";
  }
}
