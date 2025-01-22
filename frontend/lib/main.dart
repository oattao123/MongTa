import 'package:flutter/material.dart';
import 'dart:io';
import './pages/image_upload.dart';
import './pages/socket_serecive.dart';
import 'package:firebase_core/firebase_core.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Socket.IO & Firebase Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const ChatPage(),
    );
  }
}

class ChatPage extends StatefulWidget {
  const ChatPage({super.key});

  @override
  State<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  final ImageUploader _imageUploader = ImageUploader();
  final SocketService _socketService = SocketService();
  final TextEditingController _messageController = TextEditingController();
  final List<Map<String, dynamic>> _messages = []; // Marked as final
  File? _selectedImage;

  @override
  void initState() {
    super.initState();
    _socketService.initializeSocket();

    // Join a specific room
    _socketService.joinRoom('room1', 'user123');

    // Listen for new messages
    _socketService.onNewMessage((messageData) {
      setState(() {
        _messages.add(messageData);
      });
    });
  }

  @override
  void dispose() {
    _socketService.dispose();
    super.dispose();
  }

  Future<void> _pickImage() async {
    File? image = await _imageUploader.pickImage();
    setState(() {
      _selectedImage = image;
    });
  }

  Future<void> _uploadAndSendImage() async {
    if (_selectedImage == null) return;

    // Show loading indicator
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return const Center(child: CircularProgressIndicator());
      },
    );

    try {
      String? downloadUrl = await _imageUploader.uploadImage(_selectedImage!);
      Navigator.pop(context); // Close loading dialog

      if (downloadUrl != null) {
        // Send the image URL as a message
        _socketService.sendMessage(
          'room1',
          'user123',
          'Image uploaded: $downloadUrl',
        );
        setState(() {
          _selectedImage = null;
        });
      } else {
        throw Exception('Error uploading image.');
      }
    } catch (e) {
      Navigator.pop(context); // Close loading dialog
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: $e')),
      );
    }
  }

  void _sendTextMessage() {
    if (_messageController.text.isNotEmpty) {
      _socketService.sendMessage(
        'room1',
        'user123',
        _messageController.text,
      );
      _messageController.clear();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: const Text('Chat with Socket.IO & Firebase'),
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              itemCount: _messages.length,
              itemBuilder: (context, index) {
                final message = _messages[index];
                return ListTile(
                  leading: message['senderId'] == 'user123'
                      ? const Icon(Icons.person, color: Colors.blue)
                      : const Icon(Icons.person, color: Colors.green),
                  title: Text(message['message']),
                );
              },
            ),
          ),
          if (_selectedImage != null)
            Image.file(
              _selectedImage!,
              height: 150,
            ),
          Row(
            children: [
              Expanded(
                child: TextField(
                  controller: _messageController,
                  decoration: const InputDecoration(
                    labelText: 'Type a message',
                  ),
                ),
              ),
              IconButton(
                icon: const Icon(Icons.send),
                onPressed: _sendTextMessage,
              ),
              IconButton(
                icon: const Icon(Icons.image),
                onPressed: _pickImage,
              ),
              IconButton(
                icon: const Icon(Icons.upload),
                onPressed: _uploadAndSendImage,
              ),
            ],
          ),
        ],
      ),
    );
  }
}
