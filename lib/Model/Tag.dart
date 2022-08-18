class Tag {
  int? id;
  String? name;

  Tag.fromJson(json) {
    id = json['id'] ?? 0;
    name = json['name'] ?? "";
  }
}
