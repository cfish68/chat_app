import 'package:cloud_firestore/cloud_firestore.dart';


class Conversation{
  final String? conversationId;
  final String? email;

  Conversation({
    this.conversationId,
    this.email,
  }
  );


  factory Conversation.fromFirestore(
    DocumentSnapshot<Map<String, dynamic>> snapshot,
  ) {
    final data = snapshot.data();
    return Conversation(conversationId: data?['conversationId'], email: data?['email']);
  }

  Map<String, dynamic> toFirestore(){
    return {"conversationId": conversationId, "email": email};
  }
}