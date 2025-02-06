import 'package:camera/camera.dart';
import 'package:chat_app/models/conversation.dart';
import 'package:chat_app/pages/photoScreen.dart';
import 'package:chat_app/repositories/conversation_repo.dart';
import 'package:chat_app/service/conversationService.dart';
import 'package:chat_app/service/messageService.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cloudinary_flutter/image/cld_image.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import "package:chat_bubbles/chat_bubbles.dart";
import 'package:chat_app/models/message.dart';
import 'package:firebase_auth/firebase_auth.dart';

// class MessageScreen extends StatefulWidget {
//   final String email;
//   const MessageScreen({super.key, this.email = ''});
//   @override
//   State<MessageScreen> createState() {
//     return _MessageScreenState();
//   }
// }

class MessageScreen extends StatelessWidget {
  List<Message> _messages = [];
  final String email;
  MessageScreen({super.key, this.email = ''});
  // @override
  // void initState() {
  //   super.initState();
  //   //_conversationRepository = ConversationRepository(widget.email);
  // }

  //late final ScrollController _scrollController;
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => ConversationService(email),
      builder: (context, child) => Scaffold(
          body: Column(
        children: [
          SizedBox(height: 90),
          Row(
            children: [
              IconButton(
                  onPressed: () {
                    Navigator.pop(
                        context);
                  },
                  icon: const Icon(Icons.arrow_back)),
              CircleAvatar(),
              SizedBox(width: 20),
              Text(email)
            ],
          ),
          Expanded(
            child: Consumer<ConversationService>(
              builder: (context, conversationService, child) {
                var messages = conversationService.messages;
                if (messages.isEmpty) {
                  return const Center(child: Text("No messages found"));
                }
                return Column(
                  children: [
                    Expanded(
                      child: ListView.builder(
                        // will implement at a later time controller: _scrollController,
                        itemCount: messages.length,
                        //controller: _scrollController,
                        reverse: true, // Show latest messages at the bottom
                        itemBuilder: (context, index) {
                          final message = messages[index];
                          final isSender = message.senderId ==
                              FirebaseAuth.instance.currentUser?.email;
                          return message.type == 'img'
                              ? BubbleNormalImage(
                                  id: message.id, image: Image.network(message.content))
                              : BubbleNormal(
                                  text: message.content,
                                  isSender: isSender,
                                  color: isSender
                                      ? const Color(0xFF1B97F3)
                                      : const Color.fromARGB(255, 9, 7, 7),
                                  tail: true,
                                  textStyle: const TextStyle(
                                    fontSize: 16,
                                    color: Colors.white,
                                  ),
                                );
                        },
                      ),
                    ),
                    SizedBox(height: 40),
                    MessageBar(
                      onSend: (_) => _sendMessage(_, conversationService),
                      actions: [
                        InkWell(
                          child: Icon(
                            Icons.add,
                            color: Colors.black,
                            size: 24,
                          ),
                          onTap: () {},
                        ),
                        Padding(
                          padding: EdgeInsets.only(left: 8, right: 8),
                          child: InkWell(
                            child: Icon(
                              Icons.camera_alt,
                              color: Colors.green,
                              size: 24,
                            ),
                            onTap: () async {
                              final cameras = await availableCameras();

                              // Get a specific camera from the list of available cameras.
                              final firstCamera = cameras.first;
                              var result = await Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => TakePictureScreen(
                                          camera: firstCamera)));
                              print(result);
                              _sendMessage(result, conversationService, "img");
                            },
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 20),
                  ],
                );
              },
            ),
          )
        ],
      )),
    );
  }

  Future<void> _sendMessage(
      String content, ConversationService conversationService,
      [String? type]) async {
    final newMessage = Message(
        id: 'unique_message_id',
        content: content,
        senderId: FirebaseAuth.instance.currentUser?.email ?? '',
        receiverId: email,
        timestamp: Timestamp.now(),
        type: type ?? 'message');
    try {
      await conversationService.sendMessage(newMessage);
    } catch (e) {}
  }
  // @override
  // void dispose() {
  //   super.dispose();
  // }
}
