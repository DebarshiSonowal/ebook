class CheckValidResponse {
  bool? success;
  Result? result;
  String? message;
  int? code;

  CheckValidResponse({this.success, this.result, this.message, this.code});

  CheckValidResponse.fromJson(Map<String, dynamic> json) {
    success = json['success'];
    result =
    json['result'] != null ? new Result.fromJson(json['result']) : null;
    message = json['message'];
    code = json['code'];
  }
  CheckValidResponse.withError(msg) {
    success = false;
    message = msg;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['success'] = this.success;
    if (this.result != null) {
      data['result'] = this.result!.toJson();
    }
    data['message'] = this.message;
    data['code'] = this.code;
    return data;
  }
}

class Result {
  int? id;
  String? voucherNo;
  String? orderDate;
  int? subscriberId;
  int? orderableId;
  String? orderableType;
  String? sellingTotal;
  String? baseTotal;
  String? discount;
  String? total;
  String? cgst;
  String? sgst;
  String? igst;
  String? cess;
  String? grandTotal;
  int? isPaid;
  Null? addresses;
  int? discountId;
  Null? discountData;
  int? status;
  int? directBuyId;
  String? createdAt;
  String? updatedAt;
  String? subscriberPic;
  // Orderable? orderable;
  List<Null>? invoices;
  // List<OrderList>? orderList;
  List<Null>? transactions;

  Result(
      {this.id,
        this.voucherNo,
        this.orderDate,
        this.subscriberId,
        this.orderableId,
        this.orderableType,
        this.sellingTotal,
        this.baseTotal,
        this.discount,
        this.total,
        this.cgst,
        this.sgst,
        this.igst,
        this.cess,
        this.grandTotal,
        this.isPaid,
        this.addresses,
        this.discountId,
        this.discountData,
        this.status,
        this.directBuyId,
        this.createdAt,
        this.updatedAt,
        this.subscriberPic,
        // this.orderable,
        this.invoices,
        // this.orderList,
        this.transactions});

  Result.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    voucherNo = json['voucher_no'];
    orderDate = json['order_date'];
    subscriberId = json['subscriber_id'];
    orderableId = json['orderable_id'];
    orderableType = json['orderable_type'];
    sellingTotal = json['selling_total'];
    baseTotal = json['base_total'];
    discount = json['discount'];
    total = json['total'];
    cgst = json['cgst'];
    sgst = json['sgst'];
    igst = json['igst'];
    cess = json['cess'];
    grandTotal = json['grand_total'];
    isPaid = json['is_paid'];
    addresses = json['addresses'];
    discountId = json['discount_id'];
    discountData = json['discount_data'];
    status = json['status'];
    directBuyId = json['direct_buy_id'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    subscriberPic = json['subscriber_pic'];
    // orderable = json['orderable'] != null
    //     ? new Orderable.fromJson(json['orderable'])
    //     : null;
    // if (json['invoices'] != null) {
    //   invoices = <Null>[];
    //   json['invoices'].forEach((v) {
    //     invoices!.add(new Null.fromJson(v));
    //   });
    // }
    // if (json['order_list'] != null) {
    //   orderList = <OrderList>[];
    //   json['order_list'].forEach((v) {
    //     orderList!.add(new OrderList.fromJson(v));
    //   });
    // }
    // if (json['transactions'] != null) {
    //   transactions = <Null>[];
    //   json['transactions'].forEach((v) {
    //     transactions!.add(new Null.fromJson(v));
    //   });
    // }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['voucher_no'] = this.voucherNo;
    data['order_date'] = this.orderDate;
    data['subscriber_id'] = this.subscriberId;
    data['orderable_id'] = this.orderableId;
    data['orderable_type'] = this.orderableType;
    data['selling_total'] = this.sellingTotal;
    data['base_total'] = this.baseTotal;
    data['discount'] = this.discount;
    data['total'] = this.total;
    data['cgst'] = this.cgst;
    data['sgst'] = this.sgst;
    data['igst'] = this.igst;
    data['cess'] = this.cess;
    data['grand_total'] = this.grandTotal;
    data['is_paid'] = this.isPaid;
    data['addresses'] = this.addresses;
    data['discount_id'] = this.discountId;
    data['discount_data'] = this.discountData;
    data['status'] = this.status;
    data['direct_buy_id'] = this.directBuyId;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    data['subscriber_pic'] = this.subscriberPic;
    // if (this.orderable != null) {
    //   data['orderable'] = this.orderable!.toJson();
    // }
    // if (this.invoices != null) {
    //   data['invoices'] = this.invoices!.map((v) => v.toJson()).toList();
    // }
    // if (this.orderList != null) {
    //   data['order_list'] = this.orderList!.map((v) => v.toJson()).toList();
    // }
    // if (this.transactions != null) {
    //   data['transactions'] = this.transactions!.map((v) => v.toJson()).toList();
    // }
    return data;
  }
}
