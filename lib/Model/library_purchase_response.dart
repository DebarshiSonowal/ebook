class LibraryPurchaseResult {
  final Map<String, dynamic> _raw;
  final int libraryApproval;
  final int isRefresh;

  LibraryPurchaseResult({
    required Map<String, dynamic> raw,
    required this.libraryApproval,
    this.isRefresh = 0,
  }) : _raw = raw;

  /// order_id returned directly inside `result`.
  String get orderId => _raw['order_id']?.toString() ?? '';

  /// grand_total returned directly inside `result`.
  double get grandTotal =>
      double.tryParse(_raw['grand_total']?.toString() ?? '0') ?? 0.0;

  /// subscriber_id returned directly inside `result`.
  int get subscriberId =>
      int.tryParse(_raw['subscriber_id']?.toString() ?? '0') ?? 0;

  factory LibraryPurchaseResult.fromJson(Map<String, dynamic> json) {
    return LibraryPurchaseResult(
      raw: json,
      libraryApproval:
          int.tryParse(json['library_approval']?.toString() ?? '0') ?? 0,
      isRefresh:
          int.tryParse(json['is_refresh']?.toString() ?? '0') ?? 0,
    );
  }
}

class LibraryPurchaseResponse {
  final bool success;
  final LibraryPurchaseResult result;
  final String message;
  final int code;

  LibraryPurchaseResponse({
    required this.success,
    required this.result,
    required this.message,
    required this.code,
  });

  factory LibraryPurchaseResponse.fromJson(Map<String, dynamic> json) {
    return LibraryPurchaseResponse(
      success: json['success'] ?? false,
      result: LibraryPurchaseResult.fromJson(
          json['result'] is Map ? Map<String, dynamic>.from(json['result']) : {}),
      message: json['message'] ?? '',
      code: json['code'] ?? 0,
    );
  }

  factory LibraryPurchaseResponse.withError(String message) {
    return LibraryPurchaseResponse(
      success: false,
      result: LibraryPurchaseResult(raw: {}, libraryApproval: 0),
      message: message,
      code: 0,
    );
  }
}
