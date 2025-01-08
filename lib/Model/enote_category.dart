class CategoryResponse {
  final bool success;
  final List<EnotesCategory> result;
  final String message;
  final int code;

  CategoryResponse({
    required this.success,
    required this.result,
    required this.message,
    required this.code,
  });

  factory CategoryResponse.fromJson(Map<String, dynamic> json) {
    return CategoryResponse(
      success: json['success'] as bool,
      result: (json['result'] as List)
          .map((item) => EnotesCategory.fromJson(item))
          .toList(),
      message: json['message'] as String,
      code: json['code'] as int,
    );
  }

  /// Creates a CategoryResponse with error details
  factory CategoryResponse.withError(String message) {
    return CategoryResponse(
      success: false,
      result: [],
      message: message,
      code: 0,
    );
  }
  Map<String, dynamic> toJson() {
    return {
      'success': success,
      'result': result.map((category) => category.toJson()).toList(),
      'message': message,
      'code': code,
    };
  }
}

class EnotesCategory {
  final int id;
  final String title;

  EnotesCategory({
    required this.id,
    required this.title,
  });

  factory EnotesCategory.fromJson(Map<String, dynamic> json) {
    return EnotesCategory(
      id: json['id'] as int,
      title: json['title'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
    };
  }
}
