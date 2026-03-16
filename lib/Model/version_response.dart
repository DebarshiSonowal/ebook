class VersionResponse {
  final bool success;
  final VersionResult? result;
  final String message;
  final int code;

  VersionResponse({
    required this.success,
    this.result,
    required this.message,
    required this.code,
  });

  factory VersionResponse.fromJson(Map<String, dynamic> json) {
    return VersionResponse(
      success: json['success'] ?? false,
      result: json['result'] != null ? VersionResult.fromJson(json['result']) : null,
      message: json['message'] ?? '',
      code: json['code'] ?? 0,
    );
  }

  factory VersionResponse.withError(String message) {
    return VersionResponse(
      success: false,
      message: message,
      code: 0,
    );
  }
}

class VersionResult {
  final String appVersion;

  VersionResult({required this.appVersion});

  factory VersionResult.fromJson(Map<String, dynamic> json) {
    return VersionResult(
      appVersion: json['app_version']?.toString() ?? '',
    );
  }
}
