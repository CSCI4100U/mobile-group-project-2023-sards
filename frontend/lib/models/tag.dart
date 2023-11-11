class Tag {
  String id;
  String name;

  Tag({required this.id, required this.name});

  Tag.fromMap(Map<String, dynamic> tagMap)
      : id = tagMap['id'],
        name = tagMap['name'];

  Map<String, dynamic> toMap() {
    return {'id': id, 'name': name};
  }
}
