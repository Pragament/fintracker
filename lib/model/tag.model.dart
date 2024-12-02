class Tag {
  int? id;
  String name;

  Tag({this.id, required this.name});

  factory Tag.fromJson(Map<String, dynamic> data) {
    return Tag(
      id: data['id'],
      name: data['name'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      if (id != null) 'id': id,
      'name': name,
    };
  }
}
