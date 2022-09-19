class MyLang {
  int? id, status, created_by;
  String? name;

  MyLang.fromJson(json) {
    id = json['id'] ?? 0;
    status = json['status'] ?? 0;
    created_by = json['created_by'] ?? 0;
    name = json['name'] ?? "";
  }
}

class MyLangResponse {
  bool? status;
  String? message;
  List<MyLang>? languages;

  MyLangResponse.fromJson(json) {
    status = json['success'] ?? false;
    message = json['message'] ?? "Something went wrong";
    languages = json['result'] == null
        ? []
        : (json['result'] as List).map((e) => MyLang.fromJson(e)).toList();
  }

  MyLangResponse.withError(msg) {
    status = false;
    message = msg ?? "Something went wrong";
  }
}
