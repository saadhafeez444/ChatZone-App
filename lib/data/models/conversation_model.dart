import 'user_model.dart';

class ConversationModel {
  final String id;
  final String lastMessage;
  final DateTime timestamp;
  final UserModel contactDetails;

  ConversationModel({
    required this.id,
    required this.lastMessage,
    required this.timestamp,
    required this.contactDetails,
  });

  factory ConversationModel.fromJson(Map<String, dynamic> json) {
    return ConversationModel(
      id: json['_id'] ?? '',
      lastMessage: json['lastMessage'] ?? '',
      timestamp: DateTime.parse(json['timestamp'] ?? DateTime.now().toIso8601String()),
      contactDetails: UserModel.fromJson(json['contactDetails']),
    );
  }
}
