class GenericResponse {
  bool? status;
  String? message;
  int? code;

  GenericResponse.fromJson(json) {
    status = json['success'] ?? false;
    message = json['message'] ?? "Something went wrong";
    code = json['code'];
  }

  GenericResponse.withError(msg) {
    status = false;
    message = msg ?? "Something went wrong";
    code = 0;
  }
}
