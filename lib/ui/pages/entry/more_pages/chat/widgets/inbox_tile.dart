import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:food_delivery_app/resources/styles.dart';
import 'package:food_delivery_app/ui/pages/entry/more_pages/chat/ui/chat_screen.dart';
import 'package:food_delivery_app/utils/extension/responsive_extension.dart';
import 'package:food_delivery_app/utils/extension/time_extension.dart';

@immutable
class InboxTile extends StatelessWidget {
  InboxTile({
    required this.chatDoc,
    Key? key,
  }) : super(key: key);

  final DocumentSnapshot chatDoc;

  Future<String> fetchParticipantName(
      String participantUid, String currentUserUid) async {
    try {
      if (participantUid != currentUserUid) {
        final userDoc = await FirebaseFirestore.instance
            .collection('users')
            .doc(participantUid)
            .get();
        if (userDoc.exists) {
          final userData = userDoc.data() as Map<String, dynamic>;
          final userName = userData['name'] as String;
          return userName;
        }
      }

      return '';
    } catch (error) {
      throw error;
    }
  }

  final FirebaseAuth _auth = FirebaseAuth.instance;
  late String reciver = "";

  @override
  Widget build(BuildContext context) {
    final chatData = chatDoc.data() as Map<String, dynamic>;
    final participantUid = chatData['participants'] as String;

    final user = _auth.currentUser;

    return StreamBuilder(
      stream: chatDoc.reference
          .collection('messages')
          .orderBy('timestamp', descending: true)
          .limit(1)
          .snapshots(),
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return Text('Error: ${snapshot.error}');
        }

        if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
          return Text('No messages');
        }

        final messageData = snapshot.data!.docs.first.data();
        final lastMessage = messageData['content'] ?? "";
        final Timestamp lastMessageDate = messageData['timestamp'];
        return GestureDetector(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => ChatPage(
                  recipientName: reciver,
                  // chatDoc: chatDoc,
                  userId: user.uid,
                  recipientId: participantUid,
                ),
              ),
            );
          },
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    CircleAvatar(
                      radius: 24,
                      backgroundColor: Colors.white,
                      backgroundImage: AssetImage(ImageAssets
                          .app_icon), // Replace with your actual asset path
                    ),
                    SizedBox(width: 12),
                    FutureBuilder<String>(
                      future: fetchParticipantName(participantUid, user!.uid),
                      builder: (context, snapshot) {
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return CircularProgressIndicator();
                        } else if (snapshot.hasError) {
                          return Text('Error: ${snapshot.error}');
                        }

                        final participantName = snapshot.data ?? '';
                        reciver = snapshot.data ?? '';
                        return Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              participantName,
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            10.addVerticalSpace,
                            Text(
                              lastMessage,
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(fontSize: 14),
                            ),
                          ],
                        );
                      },
                    ),
                    Spacer(),
                    Text(
                      lastMessageDate.toFormattedString(),
                      style: TextStyle(color: Colors.grey),
                    ),
                  ],
                ),
                SizedBox(height: 8),
              ],
            ),
          ),
        );
      },
    );
  }
}
