import 'dart:async';
import 'package:socket_io_client/socket_io_client.dart' as io;
import '../models/message_model.dart';

class SocketService {
  io.Socket? _socket;
  final _messageController = StreamController<MessageModel>.broadcast();

  Stream<MessageModel> get messages => _messageController.stream;

  void connect(String userId) {
    _socket = io.io('https://live-chating-apis.onrender.com', 
      io.OptionBuilder()
        .setTransports(['websocket'])
        .enableAutoConnect()
        .build()
    );

    _socket!.onConnect((_) {
      _socket!.emit('join_room', userId);
    });

    _socket!.on('receive_message', (data) {
      final message = MessageModel.fromJson(data);
      _messageController.add(message);
    });

    _socket!.onConnectError((err) => print('Connect Error: $err'));
    _socket!.onError((err) => print('Error: $err'));
  }

  void sendMessage(String senderId, String receiverId, String text) {
    if (_socket != null && _socket!.connected) {
      _socket!.emit('send_message', {
        'sender': senderId,
        'receiver': receiverId,
        'text': text,
      });
    }
  }

  void disconnect() {
    _socket?.disconnect();
    _socket?.dispose();
    _socket = null;
  }
}
