import 'package:chat_app/models/conversation.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:chat_app/models/message.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:chat_app/service/app_state.dart';
import 'package:flutter/material.dart';
import 'dart:async';

class ConversationRepository extends ChangeNotifier {
  String email;
  late String _conversationId;
  final StreamController<Message> _messageStreamController =
      StreamController<Message>.broadcast();
  Stream<Message> get MessageStream => _messageStreamController.stream;
  List<QueryDocumentSnapshot<Map<String, dynamic>>> listMessages = [];
  ConversationRepository(this.email) {
    init();
  }
  init() async {
    await _setConversationId(email);
    await getMessages();
  }

  Future<void> _setConversationId(email) async {
    String? currentUser = getUserEmail;
    //check if conversationExists
    var doc = await FirebaseFirestore.instance
        .collection('users/$currentUser/conversations')
        .doc(email)
        .get();
    if (doc.exists) {
      _conversationId = doc.data()?["conversationId"];
    } else {
      createConversation();
    }
  }

  /*
    sets a conversationId and email referencing it in each of two users and starts a collection (of messages)
    in the conversations collection id being the conversationId
  */
  void createConversation() {
    String currentUser = getUserEmail ?? "";
    _conversationId = email + currentUser;
    FirebaseFirestore.instance
        .collection('users/$currentUser/conversations')
        .doc(email)
        .set({
      "conversationId": _conversationId,
      "lastChange": DateTime.now().toIso8601String(),
    });
    //correct practice would be if allowed to message other user (blocked/exits) at this point I will keep it simple and not implement
    FirebaseFirestore.instance
        .collection('users/$email/conversations')
        .doc(currentUser)
        .set({
      "conversationId": _conversationId,
      "lastChange": DateTime.now().toIso8601String()
    });
    //add conversation to conversations
    FirebaseFirestore.instance
        .collection('conversations/regular/$_conversationId')
        .doc()
        .set({
      "content": "You started a conversation",
      "receiverId": email,
      "senderId": currentUser,
      "timestamp": Timestamp.now(),
      "type": "starter"
    });
  }

  String? get getUserEmail => FirebaseAuth.instance.currentUser?.email;

  Future<void> getMessages() async {
    Timestamp timestamp = Timestamp.fromMicrosecondsSinceEpoch(0);
    try {
      // Listen to the Firestore collection for real-time updates
      FirebaseFirestore.instance
          .collection('conversations/regular/$_conversationId')
          .orderBy('timestamp', descending: true)
          .endBefore([timestamp])
          .snapshots()
          .listen((snapshot) {
            for (var doc in snapshot.docs) {
              // Convert Firestore document to a Message object
              if (!listMessages.any((a) => a.id == doc.id)) {
                listMessages.add(doc);
                final message = Message.fromFirestore(doc);
                _messageStreamController
                    .add(message); 
                timestamp = message.timestamp;
              }
            }
          });
    } catch (e) {
      print("Error fetching messages: $e");
      _messageStreamController.addError(e);
    }
  }

  Future<void> sendMessage(Message message) async {
    try {
      FirebaseFirestore.instance
          .collection('conversations/regular/$_conversationId')
          .add(message.toMap());
      
    } catch (e) {
      print("Error fetching messages: $e");
      // Optionally add an error to the stream
      _messageStreamController.addError(e);
    }
  }

  @override
  void dispose() {
    super.dispose();
    _messageStreamController.close();
  }
}
