import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flash_chat/constants.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

final _firestore = FirebaseFirestore.instance;
User? loggedInUser;

class ChatScreen extends StatefulWidget {
  static String id = "chat_screen";

  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final _auth = FirebaseAuth.instance;
  final messageTextController = TextEditingController();
  String messageText = "";

  User? getCurrentUser() {
    final user = _auth.currentUser;
    print("Email: ${user?.email}");
    return user;
  }

  void messagesStream() async {
    await for (var snapshot in _firestore.collection('messages').snapshots()) {
      for (var document in snapshot.docs) {
        print(document.data());
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    loggedInUser = getCurrentUser();

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        leading: null,
        actions: <Widget>[
          IconButton(
              icon: Icon(Icons.close),
              onPressed: () {
                // messagesStream();
                // _auth.signOut();
                // Navigator.pop(context);
              }),
        ],
        title: Text('⚡️Chat'),
        backgroundColor: Colors.lightBlueAccent,
      ),
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            MessagesStream(),
            Container(
              decoration: kMessageContainerDecoration,
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Expanded(
                    child: TextField(
                      controller: messageTextController,
                      onChanged: (value) {
                        messageText = value;
                      },
                      style: TextStyle(color: Colors.black),
                      decoration: kMessageTextFieldDecoration,
                    ),
                  ),
                  TextButton(
                    onPressed: () {
                      // messageText + loggedInUser.email
                      _firestore.collection('messages').add({
                        'text': messageText,
                        'sender': loggedInUser?.email,
                        'timestamp': Timestamp.now(),
                      });
                      messageTextController.clear();
                    },
                    child: Text(
                      'Send',
                      style: kSendButtonTextStyle,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class MessagesStream extends StatelessWidget {
  const MessagesStream({super.key});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: _firestore.collection("messages").orderBy('timestamp', descending: false).snapshots(),
      builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
        if (!snapshot.hasData) {
          return Center(
              child: CircularProgressIndicator(
            backgroundColor: Colors.lightBlueAccent,
          ));
        }
        List<MessageBubble> messageWidgets = [];
        final List<DocumentSnapshot> messages = snapshot.data!.docs;
        for (var message in messages) {
          final msgData = message.data() as Map;
          final String messageText = msgData["text"];
          final String messageSender = msgData["sender"];

          final currentUser = loggedInUser?.email;
          final messageBubble = MessageBubble(
            sender: messageSender,
            text: messageText,
            isMe: messageSender == currentUser,
          );

          messageWidgets.add(messageBubble);
        }
        return Expanded(child: ListView(children: messageWidgets));
      },
    );
  }
}

class MessageBubble extends StatelessWidget {
  const MessageBubble(
      {required this.sender, required this.text, required this.isMe});

  final String text;
  final String sender;
  final bool isMe;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(10.0),
      child: Column(crossAxisAlignment: (isMe ? CrossAxisAlignment.start : CrossAxisAlignment.end), children: [
        Text(
          '$sender',
          style: TextStyle(fontSize: 12.0, color: Colors.black54),
        ),
        Material(
            elevation: 1,
            borderRadius: (isMe ? BorderRadius.only(
                topRight: Radius.circular(30.0),
                bottomRight: Radius.circular(30.0),
              bottomLeft: Radius.circular(30.0)
            ) : BorderRadius.only(
                topLeft: Radius.circular(30.0),
                bottomLeft: Radius.circular(30.0),
                bottomRight: Radius.circular(30.0)
            )),
            color: isMe ? Colors.white : Colors.lightBlueAccent,
            shadowColor: Colors.grey,
            child: Padding(
              padding: EdgeInsets.symmetric(vertical: 10.0, horizontal: 20.0),
              child: Text(
                '$text from $sender',
                style: TextStyle(color: (isMe ? Colors.black : Colors.white), fontSize: 15.0),
              ),
            )),
      ]),
    );
  }
}
