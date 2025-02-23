class Tag {
  int? id;
  String? name;

  Tag.fromJson(json) {
    id = json['id'] ?? 0;
    name = json['name'] ?? "";
  }
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
    };
  }
}
