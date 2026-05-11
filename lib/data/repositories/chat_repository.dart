import '../models/conversation_model.dart';
import '../models/message_model.dart';
import '../services/api_service.dart';

class ChatRepository {
  final ApiService _apiService;

  ChatRepository(this._apiService);

  Future<List<ConversationModel>> getInbox() async {
    try {
      final response = await _apiService.dio.get('/chat/inbox');
      if (response.statusCode == 200) {
        return (response.data as List)
            .map((json) => ConversationModel.fromJson(json))
            .toList();
      }
    } catch (e) {
      rethrow;
    }
    return [];
  }

  Future<List<MessageModel>> getMessages(String otherUserId) async {
    try {
      final response = await _apiService.dio.get('/chat/messages/$otherUserId');
      if (response.statusCode == 200) {
        return (response.data as List)
            .map((json) => MessageModel.fromJson(json))
            .toList();
      }
    } catch (e) {
      rethrow;
    }
    return [];
  }
}
