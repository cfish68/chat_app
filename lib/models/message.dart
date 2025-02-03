import 'package:cloud_firestore/cloud_firestore.dart';

class Message {
  final String id;
  final String content;
  final String senderId;
  final String receiverId;
  final Timestamp timestamp;
  final String type;

  Message({
    required this.id,
    required this.content,
    required this.senderId,
    required this.receiverId,
    required this.timestamp,
    required this.type
  });

  // Convert a Message to a Map for storage (e.g., Firestore or local database)
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'content': content,
      'senderId': senderId,
      'receiverId': receiverId,
      'timestamp': timestamp,
      'type': type
    };
  }

  // Create a Message object from a Map (e.g., fetching from storage)
  factory Message.fromMap(Map<String, dynamic> map) {
    return Message(
      id: map['id'] ?? '',
      content: map['content'] ?? '',
      senderId: map['senderId'] ?? '',
      receiverId: map['receiverId'] ?? '',
      timestamp: Timestamp.fromDate(DateTime.parse(map['timestamp'] ?? '')),
      type: map['type'],
    );
  }
  // Convert a Firestore document to a Message object
  factory Message.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    
    return Message(
      id: doc.id, // The ID of the Firestore document
      content: data['content'] ?? '', // Ensure safe access to data
      senderId: data['senderId'] ?? '',
      receiverId: data['receiverId'] ?? '',
      timestamp: data['timestamp'].runtimeType == Timestamp ? data['timestamp']: Timestamp.now(), // Convert Timestamp to DateTime
      type: data['type'] ?? '',
      //conversationId: data['conversationId'] ?? '', // Add other necessary fields
    );
  }
}
