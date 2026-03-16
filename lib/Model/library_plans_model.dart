class LibraryPlansResponse {
  final bool success;
  final LibraryPlansResult result;
  final String message;
  final int code;

  LibraryPlansResponse({
    required this.success,
    required this.result,
    required this.message,
    required this.code,
  });

  factory LibraryPlansResponse.fromJson(Map<String, dynamic> json) {
    return LibraryPlansResponse(
      success: json['success'] ?? false,
      result: LibraryPlansResult.fromJson(json['result'] ?? {}),
      message: json['message'] ?? '',
      code: json['code'] ?? 0,
    );
  }

  factory LibraryPlansResponse.withError(String message) {
    return LibraryPlansResponse(
      success: false,
      result: LibraryPlansResult.fromJson({}),
      message: message,
      code: 0,
    );
  }
}

class LibraryPlansResult {
  final List<LibraryPlan> planList;
  final int membershipApproveType;
  final String? restrictedMsg;

  LibraryPlansResult({
    required this.planList,
    required this.membershipApproveType,
    this.restrictedMsg,
  });

  factory LibraryPlansResult.fromJson(Map<String, dynamic> json) {
    return LibraryPlansResult(
      planList: (json['plan_list'] as List<dynamic>? ?? [])
          .map((e) => LibraryPlan.fromJson(e as Map<String, dynamic>))
          .toList(),
      membershipApproveType: json['membership_approve_type'] ?? 0,
      restrictedMsg: json['restricted_msg']?.toString(),
    );
  }
}

class LibraryPlan {
  final int id;
  final String title;
  final double discount;
  final double basePrice;
  final double totalPrice;
  final String planType;
  final int isDefault;
  final String? duration;
  final int isFree;
  final int isPercent;
  final double discountValue;

  LibraryPlan({
    required this.id,
    required this.title,
    required this.discount,
    required this.basePrice,
    required this.totalPrice,
    required this.planType,
    required this.isDefault,
    this.duration,
    this.isFree = 0,
    this.isPercent = 0,
    this.discountValue = 0.0,
  });

  factory LibraryPlan.fromJson(Map<String, dynamic> json) {
    return LibraryPlan(
      id: json['id'] ?? 0,
      title: json['title'] ?? '',
      discount: double.tryParse(json['discount']?.toString() ?? '0') ?? 0.0,
      basePrice: double.tryParse(json['base_price']?.toString() ?? '0') ?? 0.0,
      totalPrice:
          double.tryParse(json['total_price']?.toString() ?? '0') ?? 0.0,
      planType: json['plan_type'] ?? '',
      isDefault: json['is_default'] ?? 0,
      duration: json['duration']?.toString(),
      isFree: int.tryParse(json['is_free']?.toString() ?? '0') ?? 0,
      isPercent: int.tryParse(json['is_percent']?.toString() ?? '0') ?? 0,
      discountValue:
          double.tryParse(json['discount_value']?.toString() ?? '0') ?? 0.0,
    );
  }
}
