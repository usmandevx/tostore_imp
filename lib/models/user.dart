class User {
  final String id;
  final String name;

  User({required this.id, required this.name});

  Map<String, dynamic> toJson() => {'id': id, 'name': name};

  factory User.fromJson(Map<String, dynamic> json) =>
      User(id: json['id'].toString(), name: json['name'] as String? ?? 'User');
}
