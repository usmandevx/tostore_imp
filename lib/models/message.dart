class Message {
  final String id;
  final String sender;
  final String text;
  final DateTime createdAt;

  Message({
    required this.id,
    required this.sender,
    required this.text,
    required this.createdAt,
  });

  Map<String, dynamic> toJson() => {
    'id': id,
    'sender': sender,
    'text': text,
    'createdAt': createdAt.toIso8601String(),
  };

  factory Message.fromJson(Map<String, dynamic> json) => Message(
    id: json['id'] as String? ?? '',
    sender: json['sender'] as String? ?? 'anonymous',
    text: json['text'] as String? ?? '',
    createdAt: json['createdAt'] != null
        ? DateTime.parse(json['createdAt'] as String)
        : DateTime.now(),
  );
}
