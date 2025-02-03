import 'dart:async';

import 'package:chat_app/repositories/message_repository.dart';
import 'package:chat_app/models/message.dart';
import 'package:flutter/material.dart';
import 'package:chat_app/repositories/conversation_repo.dart';

class MessageService extends ChangeNotifier {
  List<Message> _Lastmessages = [];
  List<Message> get Lastmessages =>
      _Lastmessages; // Expose the list as read-only
  final MessageRepository messageRepository;
  late StreamSubscription<Message> _messageSubscription;
  // Constructor for dependency injection
  MessageService({required this.messageRepository});
  Future<void> init() async {
    try {
      _messageSubscription = messageRepository.MessageStream.listen((message) {
        if (!_Lastmessages.contains(message)) {
          _Lastmessages.add(message); // Add new message to the list
          notifyListeners(); // Notify listeners to rebuild UI
        }
      });
      //_Lastmessages = await messageRepository.getLastMessages();
      //notifyListeners(); // Notify consumers of the updated messages
    } catch (e) {
      throw Exception('Failed to initialize MessageService: $e');
    }
  }

  Future<void> getLastMessages() async {
    try {
      //_Lastmessages = await messageRepository.getLastMessages();
      notifyListeners();
    } catch (e) {
      throw Exception('Failed to get the last messages: $e');
    }
  }
}
