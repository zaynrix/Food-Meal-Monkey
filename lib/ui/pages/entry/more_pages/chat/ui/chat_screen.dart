import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:food_delivery_app/core/controllers/auth_controller/auth_controller.dart';
import 'package:food_delivery_app/resources/styles.dart';
import 'package:food_delivery_app/ui/pages/entry/more_pages/chat/chat_controllers/chat_controller.dart';
import 'package:food_delivery_app/utils/extension/time_extension.dart';
import 'package:provider/provider.dart';

class ChatPage extends StatefulWidget {
  final String userId;
  final String recipientId;
  final String recipientName;

  ChatPage({
    this.userId = "",
    this.recipientId = "",
    required this.recipientName,
  });

  @override
  _ChatPageState createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  TextEditingController _messageController = TextEditingController();
  Timer? _typingTimer; // Declare a Timer variable

  @override
  void dispose() {
    _typingTimer
        ?.cancel(); // Cancel the typing timer when the widget is disposed
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(widget.recipientName)),
      body: Consumer<ChatController>(
        builder: (context, chatController, child) => Column(
          children: [
            Expanded(
              child: StreamBuilder<QuerySnapshot>(
                stream: FirebaseFirestore.instance
                    .collection('chats')
                    .doc(getChatId(widget.userId, widget.recipientId))
                    .collection('messages')
                    .orderBy('timestamp', descending: true)
                    .snapshots(),
                builder: (context, snapshot) {
                  if (!snapshot.hasData) {
                    return Center(child: CircularProgressIndicator());
                  }

                  final messages = snapshot.data!.docs;

                  return ListView.builder(
                    reverse: true,
                    itemCount: messages.length,
                    itemBuilder: (context, index) {
                      final message = messages[index];
                      final isSender = message['senderId'] == widget.userId;
                      chatController.setMessageSender(message['senderId']);
                      Timestamp valueTime =
                          message['timestamp'] ?? Timestamp.now();
                      return Row(
                        mainAxisAlignment: !isSender
                            ? MainAxisAlignment.start
                            : MainAxisAlignment.end,
                        children: [
                          !isSender
                              ? messages[index] != 0
                                  ? CircleAvatar(
                                      backgroundImage:
                                          AssetImage(ImageAssets.app_icon),
                                      backgroundColor: Colors.transparent,
                                    )
                                  : SizedBox.shrink()
                              : SizedBox(),
                          Container(
                            margin: EdgeInsets.symmetric(
                                vertical: 8, horizontal: 16),
                            alignment: isSender
                                ? Alignment.centerRight
                                : Alignment.centerLeft,
                            child: Container(
                              padding: EdgeInsets.all(12),
                              decoration: BoxDecoration(
                                color: isSender
                                    ? Colors.deepOrange
                                    : Colors.grey[300],
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Column(
                                crossAxisAlignment: isSender
                                    ? CrossAxisAlignment.end
                                    : CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    message["text"],
                                    style: TextStyle(
                                        fontSize: 16,
                                        color: isSender
                                            ? Colors.white
                                            : Colors.black),
                                    overflow: TextOverflow.visible,
                                  ),
                                  SizedBox(height: 4),
                                  Text(
                                    valueTime.toFormattedString(),
                                    style: TextStyle(
                                        fontSize: 12,
                                        color: isSender
                                            ? Colors.white
                                            : Colors.black),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      );
                    },
                  );
                },
              ),
            ),
            _buildTypingIndicator(chatController.senderString),
            _buildMessageInputField(
                chatController.senderString, widget.recipientId),
          ],
        ),
      ),
    );
  }

  Widget _buildTypingIndicator(String sender) {
    return StreamBuilder<DocumentSnapshot>(
      stream: FirebaseFirestore.instance
          .collection('chats')
          .doc(getChatId(widget.recipientId, widget.userId))
          .snapshots(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return SizedBox();
        }

        bool isRecipientTyping = snapshot.data!['userId1_isTyping'] ?? false;
        bool isSenderTyping = snapshot.data!['userId2_isTyping'] ?? false;
        print(
            "This first conditions ${widget.userId != sender && isRecipientTyping}");

        print(
            "This Seconnd conditions ${widget.userId != sender && isSenderTyping}");
        if (widget.userId == sender && isSenderTyping) {
          print(
              "This Seconnd conditions ${widget.userId != sender && isSenderTyping}");

          return Padding(
            padding: EdgeInsets.all(8.0),
            child: Text(
              'Typing... ',
              style: TextStyle(color: Colors.red),
            ),
          );
        }
        if (widget.userId != sender && isRecipientTyping) {
          print(
              "This first conditions ${widget.userId != sender && isRecipientTyping}");
          return Padding(
            padding: EdgeInsets.all(8.0),
            child: Text(
              'Typing... ',
              style: TextStyle(color: Colors.red),
            ),
          );
        } else {
          return SizedBox();
        }
      },
    );
  }

  Widget _buildMessageInputField(String sender, String revicer) {
    String authID = Provider.of<AuthController>(context, listen: false)
        .auth
        .currentUser!
        .uid;
    return Container(
      padding: EdgeInsets.all(8.0),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              style:
                  TextStyle(color: Colors.black, fontWeight: FontWeight.normal),
              controller: _messageController,
              onChanged: (value) {
                print("This changeting $value");
                setState(() {
                  if (sender == authID) {
                    _updateTypingStatusReciver(true);
                  }
                  if (sender != authID) {
                    _updateTypingStatusSender(true);
                  }

                  if (_typingTimer != null && _typingTimer!.isActive) {
                    _typingTimer!.cancel(); // Cancel the previous timer
                  }

                  // Set a new timer to update typing status after delay
                  _typingTimer = Timer(Duration(seconds: 2), () {
                    _updateTypingStatusSender(false);
                    _updateTypingStatusReciver(false);
                  });
                });
              },
              decoration: InputDecoration(
                hintStyle: TextStyle(
                    color: Colors.grey, fontWeight: FontWeight.normal),
                hintText: 'Type your message...',
              ),
            ),
          ),
          IconButton(
            icon: Icon(Icons.send),
            onPressed: () {
              if (_messageController.text.isNotEmpty) {
                _sendMessage(_messageController.text);
                _messageController.clear();
              }
            },
          ),
        ],
      ),
    );
  }

  void _updateTypingStatus(bool typing) {
    FirebaseFirestore.instance
        .collection('chats')
        .doc(getChatId(widget.userId, widget.recipientId))
        .update({
      'isTyping': typing,
    });
  }

  void _updateTypingStatusSender(bool typing) {
    FirebaseFirestore.instance
        .collection('chats')
        .doc(getChatId(widget.userId, widget.recipientId))
        .update({
      'userId2_isTyping': typing,
    });
  }

  void _updateTypingStatusReciver(bool typing) {
    FirebaseFirestore.instance
        .collection('chats')
        .doc(getChatId(widget.userId, widget.recipientId))
        .update({
      'userId1_isTyping': typing,
    });
  }

  void _sendMessage(String messageText) {
    FirebaseFirestore.instance
        .collection('chats')
        .doc(getChatId(widget.userId, widget.recipientId))
        .collection('messages')
        .add({
      'senderId': widget.userId,
      'text': messageText,
      'timestamp': FieldValue.serverTimestamp(),
    });

    // Clear the input field after sending the message
    _messageController.clear();
  }

  String getChatId(String userId1, String userId2) {
    if (userId1.hashCode <= userId2.hashCode) {
      return '$userId1-$userId2';
    } else {
      return '$userId2-$userId1';
    }
  }
}
