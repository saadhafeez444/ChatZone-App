import 'package:flutter/material.dart';
import '../data/models/user_model.dart';
import '../data/models/conversation_model.dart';
import '../data/models/message_model.dart';
import '../data/repositories/chat_repository.dart';
import '../data/repositories/auth_repository.dart';
import '../data/services/socket_service.dart';

class ChatProvider extends ChangeNotifier {
  final ChatRepository _chatRepository;
  final SocketService _socketService;
  
  List<ConversationModel> _inbox = [];
  List<MessageModel> _messages = [];
  List<UserModel> _searchResults = [];
  bool _isLoading = false;
  bool _isSearching = false;

  ChatProvider(this._chatRepository, this._socketService) {
    _socketService.messages.listen((message) {
      // Avoid duplicate messages if they were added optimistically
      final bool alreadyExists = _messages.any((m) => 
        m.text == message.text && 
        m.sender == message.sender && 
        m.receiver == message.receiver &&
        message.createdAt.difference(m.createdAt).inSeconds.abs() < 5
      );

      if (!alreadyExists) {
        _messages.add(message);
        notifyListeners();
      }
      fetchInbox(silent: true); // Silently refresh inbox to see latest message
    });
  }

  List<ConversationModel> get inbox => _inbox;
  List<MessageModel> get messages => _messages;
  List<UserModel> get searchResults => _searchResults;
  bool get isLoading => _isLoading;
  bool get isSearching => _isSearching;

  Future<void> searchUsers(String query, AuthRepository authRepo) async {
    if (query.isEmpty) {
      _searchResults = [];
      notifyListeners();
      return;
    }
    _isSearching = true;
    notifyListeners();
    try {
      _searchResults = await authRepo.searchUsers(query);
    } finally {
      _isSearching = false;
      notifyListeners();
    }
  }

  void clearSearch() {
    _searchResults = [];
    notifyListeners();
  }

  Future<void> fetchInbox({bool silent = false}) async {
    if (!silent) {
      _isLoading = true;
      notifyListeners();
    }
    try {
      _inbox = await _chatRepository.getInbox();
    } catch (e) {
      print('Fetch inbox error: $e');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> fetchMessages(String otherUserId) async {
    _isLoading = true;
    _messages = [];
    notifyListeners();
    try {
      _messages = await _chatRepository.getMessages(otherUserId);
    } catch (e) {
      print('Fetch messages error: $e');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  void sendMessage(String senderId, String receiverId, String text) {
    _socketService.sendMessage(senderId, receiverId, text);
    // Optimistic update
    final newMessage = MessageModel(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      sender: senderId,
      receiver: receiverId,
      text: text,
      createdAt: DateTime.now(),
    );
    _messages.add(newMessage);
    notifyListeners();
    fetchInbox(silent: true); // Silently refresh inbox to show new contact immediately
  }
  
  void connectSocket(String userId) {
    _socketService.connect(userId);
  }
  
  void disconnectSocket() {
    _socketService.disconnect();
  }
}
