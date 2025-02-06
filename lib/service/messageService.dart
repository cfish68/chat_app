import 'dart:async';

import 'package:chat_app/repositories/message_repository.dart';
import 'package:chat_app/models/message.dart';
import 'package:flutter/material.dart';
import 'package:chat_app/repositories/conversation_repo.dart';

class MessageService extends ChangeNotifier {
  Map<String, Message> _Lastmessages = {};
  Map<String, Message> get Lastmessages =>
      _Lastmessages; // Expose the list as read-only
  final MessageRepository messageRepository;
  late StreamSubscription<Map<String, Message>> _messageSubscription;
  // Constructor for dependency injection
  MessageService({required this.messageRepository}){
    init();
  }
  Future<void> init() async {
    try {
      _messageSubscription = messageRepository.MessageStream.listen((message){ 
          _Lastmessages[message.keys.first] = message.values.first; // Add new message to the list
          notifyListeners(); // Notify listeners to rebuild UI
      }
      );
      //_Lastmessages = await messageRepository.getLastMessages();
      //notifyListeners(); // Notify consumers of the updated messages
    } catch (e) {
      throw Exception('Failed to initialize MessageService: $e');
    }
  }

  @override
  void dispose(){
    super.dispose();
  }
}
