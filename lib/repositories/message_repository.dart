import 'package:chat_app/models/conversation.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:chat_app/models/message.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:chat_app/service/app_state.dart';
import 'package:flutter/material.dart';
import 'dart:async';

class MessageRepository extends ChangeNotifier {
  final FirebaseFirestore _firebaseFirestore;
  final UserState authService;
  // Constructor for dependency injection
  MessageRepository(
      {FirebaseFirestore? firebaseFirestore, required this.authService})
      : _firebaseFirestore = firebaseFirestore ?? FirebaseFirestore.instance{
        getLastMessages();
      }

  final StreamController<Map<String,Message>> _messageStreamController =
      StreamController<Map<String,Message>>.broadcast();
  Stream<Map<String,Message>> get MessageStream => _messageStreamController.stream;   

  // Function to get the last message for each person involved in the conversations
  Future<void> getLastMessages() async {
    try {
      List<QueryDocumentSnapshot<Map<String, dynamic>>> result = [];

      String db =
          'users/${FirebaseAuth.instance.currentUser?.email}/conversations';
      final snapshot =
          await FirebaseFirestore.instance.collection(db).snapshots().listen(
        (snapshot) {
          for (var doc in snapshot.docs) {
            if (!result.any((a) => a.id == doc.id)) {
              result.add(doc);
              String converstaionId = doc['conversationId'];
              var docMessage = FirebaseFirestore.instance
                  .collection('conversations/regular/$converstaionId')
                  .orderBy('timestamp')
                  .limitToLast(1)
                  .snapshots().listen((snapshot) {
                    for(var doc in snapshot.docs) {
                      final message = Message.fromFirestore(doc);
                     _messageStreamController.add({((message.senderId != FirebaseAuth.instance.currentUser?.email)? message.senderId : message.receiverId): message});
                    }
                  }
                  );
            }
          }
        },
      );
      // for (var doc in snapshot.docs) {
      //   String converstaionId = doc['conversationId'];
      //   var docMessage = FirebaseFirestore.instance
      //       .collection('conversations/regular/$converstaionId')
      //       .orderBy('timestamp')
      //       .limitToLast(1)
      //       .get()
      //       .then((QuerySnapshot) {
      //     if (QuerySnapshot.size == 1)
      //       result.add(Message.fromFirestore(QuerySnapshot.docs.first));
      //   });
      // }
    } catch (e) {
      print('Error fetching last messages: $e');
    }
  }

  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  StreamSubscription? _messagesSubscription;
  void startListening(String userId) {
    _messagesSubscription = _firestore
        .collection('messages')
        .where('participants', arrayContains: userId)
        .orderBy('timestamp', descending: true)
        .snapshots()
        .listen((QuerySnapshot snapshot) {
      List<Map<String, dynamic>> _messages = snapshot.docs
          .map((doc) => doc.data() as Map<String, dynamic>)
          .toList();
      //_updateLastMessages(userId); // Update the last message for all contacts
      notifyListeners(); // Notify listeners about the updated data
    });
  }

  @override
  void dispose() {
    super.dispose();
    _messageStreamController.close();
  }
}
