import 'package:chat_app/pages/messageScreen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:chat_app/service/messageService.dart';
import 'package:chat_app/models/message.dart';

class chatScreen extends StatefulWidget {
  @override
  _chatScreenState createState() => _chatScreenState();
}

class _chatScreenState extends State<chatScreen> {
  TextEditingController _controller = TextEditingController();
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        floatingActionButton: FloatingActionButton(
            onPressed: () {
              openDialogue();
            },
            child: const Icon(Icons.add)),
        appBar: AppBar(title: Text('Chats')),
        body: Consumer<MessageService>(
          builder: (context, messageService, child) {
            final messages = messageService.Lastmessages;
            if (messages.isEmpty) {
              return const Center(child: Text("No messages found"));
            }
            DateTime now = DateTime.now();
            DateTime today = DateTime(now.year, now.month, now.day, 0, 0, 0);
            final listMessages = messages.entries.toList();
            listMessages.sort((b,a) => a.value.timestamp.compareTo(b.value.timestamp));
            return ListView.builder(itemCount: messages.length,
            reverse: false,
            
            itemBuilder: (context, index) {
              final message = listMessages[index];
              return ListTile(
                    onTap: () {
                      Navigator.push(context,
                      MaterialPageRoute(builder: (context) => MessageScreen(email: message.key)));
                      
                    },
                    leading: CircleAvatar(),
                    title: Text('${message.key}'),
                    subtitle: Text(message.value.content.length > 26? '${message.value.content.substring(0, 23)}...': message.value.content),

                    trailing: Text(message.value.timestamp.toDate().isAfter(today)? '${message.value.timestamp.toDate().hour}:${message.value.timestamp.toDate().minute} ': '${message.value.timestamp.toDate().month}/${message.value.timestamp.toDate().day}/${message.value.timestamp.toDate().year}'),//).message.timestamp.toString().substring(0,19)),
                  );
            },
            );
          },
        )
        // body: FutureBuilder<List<Message>>(
        //   future: Provider.of<MessageService>(context).getLastMessages(),
        //   builder: (context, snapshot) {
        //     if (snapshot.connectionState == ConnectionState.waiting) {
        //       return Center(child: CircularProgressIndicator());
        //     }

        //     if (snapshot.hasError) {
        //       return Center(child: Text('Error: ${snapshot.error}'));
        //     }

        //     if (snapshot.hasData && snapshot.data!.isNotEmpty) {
        //       final messages = snapshot.data!;
        //       return ListView.builder(
        //         itemCount: messages.length,
        //         itemBuilder: (context, index) {
        //           final message = messages[index];
        //           return ListTile(
        //             onTap: () => {
        //               Navigator.push(context,
        //               MaterialPageRoute(builder: (context) => MessageScreen(email: message.senderId)))//toDo: deal with cases where it needs to be receiver also a fewe lines below

        //             },
        //             leading: CircleAvatar(),
        //             title: Text('${message.senderId == 'myEmail' ? message.receiverId : message.senderId}'),
        //             subtitle: Text(message.content),
        //             trailing: Text(message.timestamp.toString().substring(0,19)),
        //           );
        //         },
        //       );
        //     } else {
        //       return Center(child: Text('No messages found'));
        //     }
        //   },
        // ),
        );
  }

  Future openDialogue() => showDialog(
        context: context,
        builder: (context) => AlertDialog(
            title: Text("Start New Conversation"),
            content: TextField(
                decoration: InputDecoration(hintText: 'Enter email'),
                controller: _controller),
            actions: [TextButton(child: Text('Enter'), onPressed: () {
              final email = _controller.text;
              Navigator.of(context).pop();
              _controller.clear();
              Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => MessageScreen(email: email)));
            })]),
      );
  
}
