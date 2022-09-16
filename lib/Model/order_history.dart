import 'package:ebook/Model/subscriber.dart';
import 'package:ebook/Model/transaction.dart';

import 'invoice.dart';
import 'order.dart';

class OrderHistory{

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
  List<Transaction> transactions=[];
  List<Invoice> invoices=[];
  Subscriber? subscriber;

  OrderHistory.fromJson(json){
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
    transactions = json['transactions']==null?[]:(json['transactions'] as List).map((e) => Transaction.fromJson(e)).toList();
    invoices = json['invoices']==null?[]:(json['invoices'] as List).map((e) => Invoice.fromJson(e)).toList();
    //
    subscriber = Subscriber.fromJson(json['subscriber']!);
  }
}

class OrderHistoryResponse{
  bool? status;
  String? message;
  List<OrderHistory> orders=[];

  OrderHistoryResponse.fromJson(json) {
    status = json['success'] ?? false;
    message = json['message'] ?? "Something went wrong";
    orders = json['result']==null?[]:(json['result'] as List).map((e) => OrderHistory.fromJson(e)).toList();
  }

  OrderHistoryResponse.withError(msg) {
    status = false;
    message = msg ?? "Something went wrong";
  }
}