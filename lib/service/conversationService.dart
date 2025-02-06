import 'dart:async';

import 'package:chat_app/repositories/message_repository.dart';
import 'package:chat_app/models/message.dart';
import 'package:flutter/material.dart';
import 'package:chat_app/repositories/conversation_repo.dart';

class ConversationService extends ChangeNotifier {
  List<Message> _messages = [];
  List<Message> get messages => _messages; // Expose the list as read-only
  String email;
  late ConversationRepository conversationRepository;
// Stream subscription for message updates
  late StreamSubscription<Message> _messageSubscription;
  // Constructor for dependency injection
  ConversationService(this.email) {
    init();
    notifyListeners();
  }
  void init() {
    try {
      conversationRepository = ConversationRepository(email);
      _messageSubscription =
          conversationRepository.MessageStream.listen((message) {
        if (!_messages.contains(message)) {
          _messages.add(message);
          notifyListeners(); 
        }
      });
    } catch (e) {
      throw Exception('Failed to initialize Conversationservice: $e');
    }
  }

  // Send a message and notify listeners
  Future<void> sendMessage(Message message) async {
    conversationRepository.sendMessage(message);
  }

  // Fetch messages for a specific conversation
  Future<void> getMessages(String conversationId) async {
    _messages = [];
    try {
      ConversationRepository(conversationId).MessageStream.listen((message) {
        _messages.insert(_messages.length, message);
        notifyListeners();
      });

      //  _messages = await messageRepository.fetchMessages(conversationId);
      // notifyListeners(); // Notify listeners about the fetched messages
    } catch (e) {
      throw Exception('Failed to fetch messages: $e');
    }
  }

  @override
  void dispose() {
    super.dispose();
  }
}
