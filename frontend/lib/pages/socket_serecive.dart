import 'package:socket_io_client/socket_io_client.dart' as socket;

class SocketService {
  late socket.Socket _socket;

  void initializeSocket() {
    _socket = socket.io(
      'http://localhost:3000', // Replace with your backend URL
      socket.OptionBuilder()
          .setTransports(['websocket'])
          .enableAutoConnect()
          .build(),
    );

    _socket.onConnect((_) {
      print('Connected to Socket.IO server');
    });

    _socket.onDisconnect((_) {
      print('Disconnected from Socket.IO server');
    });
  }

  void joinRoom(String roomId, String userId) {
    _socket.emit('join', {'conversationid': roomId, 'userid': userId});
  }

  void sendMessage(String roomId, String senderId, String message) {
    _socket.emit('sendMessage', {
      'conversationid': roomId,
      'messageData': {'senderId': senderId, 'message': message}
    });
  }

  void onNewMessage(Function(Map<String, dynamic>) callback) {
    _socket.on('newMessage', (data) {
      callback(Map<String, dynamic>.from(data));
    });
  }

  void dispose() {
    _socket.dispose();
  }
}
