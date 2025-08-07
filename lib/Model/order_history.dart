import 'dart:convert';

import 'package:ebook/Model/subscriber.dart';
import 'package:ebook/Model/transaction.dart';
import 'package:ebook/Model/home_banner.dart';
import 'package:ebook/Model/invoice.dart';
import 'package:ebook/Model/order.dart';

/// Represents an order history item with all related information
class OrderHistory {
  // Order identifiers and status
  final int id;
  final int subscriberId;
  final int isPaid;
  final int discountId;
  final int status;

  // Financial information
  final double sellingTotal;
  final double baseTotal;
  final double discount;
  final double total;
  final double cgst;
  final double sgst;
  final double igst;
  final double cess;
  final double grandTotal;

  // Order details
  final String voucherNo;
  final String orderDate;
  final String? addresses;
  final String? discountData;
  final String? subscriberPic;
  final String? orderId;

  // Related data
  final List<OrderItem> orderItems;
  final List<Transaction> transactions;
  final List<Invoice> invoices;
  final Subscriber? subscriber;
  final String? subscriberName;

  OrderHistory({
    required this.id,
    required this.subscriberId,
    required this.isPaid,
    required this.discountId,
    required this.status,
    required this.sellingTotal,
    required this.baseTotal,
    required this.discount,
    required this.total,
    required this.cgst,
    required this.sgst,
    required this.igst,
    required this.cess,
    required this.grandTotal,
    required this.voucherNo,
    required this.orderDate,
    this.addresses,
    this.discountData,
    this.subscriberPic,
    this.orderId,
    required this.orderItems,
    required this.transactions,
    required this.invoices,
    this.subscriber,
    this.subscriberName,
  });

  /// Creates an OrderHistory instance from JSON data
  factory OrderHistory.fromJson(Map<String, dynamic> json) {
    return OrderHistory(
      // Parse integers with proper null handling
      id: _parseToInt(json['id']),
      subscriberId: _parseToInt(json['subscriber_id']),
      isPaid: _parseToInt(json['is_paid']),
      discountId: _parseToInt(json['discount_id']),
      status: _parseToInt(json['status']),

      // Parse doubles with proper null handling
      sellingTotal: _parseToDouble(json['selling_total']),
      baseTotal: _parseToDouble(json['base_total']),
      discount: _parseToDouble(json['discount']),
      total: _parseToDouble(json['total']),
      cgst: _parseToDouble(json['cgst']),
      sgst: _parseToDouble(json['sgst']),
      igst: _parseToDouble(json['igst']),
      cess: _parseToDouble(json['cess']),
      grandTotal: _parseToDouble(json['grand_total']),

      // Parse strings with proper null handling
      voucherNo: json['voucher_no']?.toString() ?? '',
      orderDate: json['order_date']?.toString() ?? '',
      addresses: json['addresses']?.toString(),
      discountData: json['discount_data']?.toString(),
      subscriberPic: json['subscriber_pic']?.toString(),
      orderId: json['order_id']?.toString(),
      subscriberName: json['subscriber_name']?.toString(),

      // Parse lists with proper null handling
      orderItems: _parseOrderItems(json['order_list']),
      transactions: _parseTransactions(json['transactions']),
      invoices: _parseInvoices(json['invoices']),

      // Parse subscriber object if available
      subscriber: json['subscriber'] != null
          ? Subscriber.fromJson(json['subscriber'])
          : null,
    );
  }

  /// Converts OrderHistory instance to JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'subscriber_id': subscriberId,
      'is_paid': isPaid,
      'discount_id': discountId,
      'status': status,
      'selling_total': sellingTotal,
      'base_total': baseTotal,
      'discount': discount,
      'total': total,
      'cgst': cgst,
      'sgst': sgst,
      'igst': igst,
      'cess': cess,
      'grand_total': grandTotal,
      'voucher_no': voucherNo,
      'order_date': orderDate,
      'addresses': addresses,
      'discount_data': discountData,
      'subscriber_pic': subscriberPic,
      'order_id': orderId,
      'subscriber_name': subscriberName,
      'order_list': orderItems.length.toString(),
      'transactions': transactions.length.toString(),
      'invoices': invoices.length.toString(),
      'subscriber': subscriber != null ? 'Present' : null,
    };
  }

  // Helper methods for parsing
  static int _parseToInt(dynamic value) {
    if (value == null) return 0;
    if (value is int) return value;
    return int.tryParse(value.toString()) ?? 0;
  }

  static double _parseToDouble(dynamic value) {
    if (value == null) return 0.0;
    if (value is double) return value;
    if (value is int) return value.toDouble();
    return double.tryParse(value.toString()) ?? 0.0;
  }

  static List<OrderItem> _parseOrderItems(dynamic value) {
    if (value == null || value is! List) return [];
    return value.map<OrderItem>((item) => OrderItem.fromJson(item)).toList();
  }

  static List<Transaction> _parseTransactions(dynamic value) {
    if (value == null || value is! List) return [];
    return value
        .map<Transaction>((item) => Transaction.fromJson(item))
        .toList();
  }

  static List<Invoice> _parseInvoices(dynamic value) {
    if (value == null || value is! List) return [];
    return value.map<Invoice>((item) => Invoice.fromJson(item)).toList();
  }

  /// Returns a formatted display name for the subscriber
  String get displayName {
    if (subscriberName?.isNotEmpty == true) {
      return subscriberName!;
    }
    if (subscriber != null) {
      final firstName = subscriber!.f_name ?? '';
      final lastName = subscriber!.l_name ?? '';
      if (firstName.isNotEmpty || lastName.isNotEmpty) {
        return '$firstName $lastName'.trim();
      }
    }
    return 'Unknown Subscriber';
  }

  /// Returns formatted order date
  String get formattedOrderDate {
    try {
      final date = DateTime.parse(orderDate);
      return '${date.day}/${date.month}/${date.year}';
    } catch (e) {
      return orderDate;
    }
  }

  /// Returns payment status as a readable string
  String get paymentStatus {
    return isPaid == 1 ? 'Paid' : 'Unpaid';
  }

  /// Returns order status as a readable string
  String get orderStatus {
    switch (status) {
      case 0:
        return 'Pending';
      case 1:
        return 'Confirmed';
      case 2:
        return 'Delivered';
      case 3:
        return 'Cancelled';
      default:
        return 'Unknown';
    }
  }
}

/// Response wrapper for order history API calls
class OrderHistoryResponse {
  final bool status;
  final String message;
  final List<OrderHistory> orders;

  const OrderHistoryResponse({
    required this.status,
    required this.message,
    required this.orders,
  });

  /// Creates an OrderHistoryResponse from JSON data
  factory OrderHistoryResponse.fromJson(Map<String, dynamic> json) {
    return OrderHistoryResponse(
      status: json['success'] ?? false,
      message: json['message']?.toString() ?? 'Something went wrong',
      orders: _parseOrders(json['result']),
    );
  }

  /// Creates an error response
  factory OrderHistoryResponse.withError(String? message) {
    return OrderHistoryResponse(
      status: false,
      message: message ?? 'Something went wrong',
      orders: const [],
    );
  }

  /// Converts response to JSON
  Map<String, dynamic> toJson() {
    return {
      'success': status,
      'message': message,
      'result': orders.map((order) => order.toJson()).toList(),
    };
  }

  static List<OrderHistory> _parseOrders(dynamic value) {
    if (value == null || value is! List) return [];
    return value
        .map<OrderHistory>((item) => OrderHistory.fromJson(item))
        .toList();
  }

  /// Returns true if the response contains orders
  bool get hasOrders => orders.isNotEmpty;

  /// Returns the total number of orders
  int get orderCount => orders.length;

  /// Returns orders filtered by payment status
  List<OrderHistory> getOrdersByPaymentStatus(bool isPaid) {
    return orders.where((order) => (order.isPaid == 1) == isPaid).toList();
  }

  /// Returns orders filtered by status
  List<OrderHistory> getOrdersByStatus(int status) {
    return orders.where((order) => order.status == status).toList();
  }
}
