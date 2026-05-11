class MessageModel {
  final String id;
  final String sender;
  final String receiver;
  final String text;
  final DateTime createdAt;

  MessageModel({
    required this.id,
    required this.sender,
    required this.receiver,
    required this.text,
    required this.createdAt,
  });

  factory MessageModel.fromJson(Map<String, dynamic> json) {
    return MessageModel(
      id: json['_id'] ?? '',
      sender: json['sender'] ?? '',
      receiver: json['receiver'] ?? '',
      text: json['text'] ?? '',
      createdAt: DateTime.parse(json['createdAt'] ?? json['timestamp'] ?? DateTime.now().toIso8601String()),
    );
  }
}
