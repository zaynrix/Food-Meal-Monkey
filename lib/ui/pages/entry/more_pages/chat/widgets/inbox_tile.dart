import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:food_delivery_app/core/controllers/auth_controller/auth_controller.dart';
import 'package:food_delivery_app/routing/navigations.dart';
import 'package:food_delivery_app/routing/router.dart';
import 'package:food_delivery_app/ui/pages/entry/more_pages/chat/models/chat_user.dart';
import 'package:food_delivery_app/ui/pages/entry/more_pages/chat/ui/chat_screen.dart';
import 'package:food_delivery_app/utils/keyboard_utils.dart';
import 'package:provider/provider.dart';

// class InboxTile extends StatefulWidget {
//   InboxTile({
//     required this.chatDoc,
//     Key? key,
//   }) : super(key: key);
//
//   final DocumentSnapshot chatDoc;
//
//   @override
//   State<InboxTile> createState() => _InboxTileState();
// }
//
// class _InboxTileState extends State<InboxTile> {
//   final FirebaseAuth _auth = FirebaseAuth.instance;
//
//   late String reciver = "";
//
//   @override
//   Widget build(BuildContext context) {
//     final chatData = widget.chatDoc.data() as Map<String, dynamic>;
//     final participantUid = chatData['participants'] as String;
//
//     final user = _auth.currentUser;
//
//     return StreamBuilder(
//       stream: widget.chatDoc.reference
//           .collection('messages')
//           .orderBy('timestamp', descending: true)
//           .limit(1)
//           .snapshots(),
//       builder: (context, snapshot) {
//         if (snapshot.hasError) {
//           return Text('Error: ${snapshot.error}');
//         }
//
//         if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
//           return Text('No messages');
//         }
//
//         final messageData = snapshot.data!.docs.first.data();
//         final lastMessage = messageData['content'] ?? "";
//         final Timestamp lastMessageDate = messageData['timestamp'];
//         return GestureDetector(
//           onTap: () {
//             // Navigator.push(
//             //   context,
//             //   MaterialPageRoute(
//             //     builder: (context) => ChatPage(
//             //       recipientName: reciver,
//             //       // chatDoc: chatDoc,
//             //       userId: user.uid,
//             //       recipientId: participantUid,
//             //     ),
//             //   ),
//             // );
//           },
//           child: Container(
//             padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 Row(
//                   children: [
//                     CircleAvatar(
//                       radius: 24,
//                       backgroundColor: Colors.white,
//                       backgroundImage: AssetImage(ImageAssets
//                           .app_icon), // Replace with your actual asset path
//                     ),
//                     SizedBox(width: 12),
//                     FutureBuilder<String>(
//                       future: fetchParticipantName(participantUid, user!.uid),
//                       builder: (context, snapshot) {
//                         if (snapshot.connectionState ==
//                             ConnectionState.waiting) {
//                           return CircularProgressIndicator();
//                         } else if (snapshot.hasError) {
//                           return Text('Error: ${snapshot.error}');
//                         }
//
//                         final participantName = snapshot.data ?? '';
//                         reciver = snapshot.data ?? '';
//                         return Column(
//                           crossAxisAlignment: CrossAxisAlignment.start,
//                           children: [
//                             Text(
//                               participantName,
//                               style: TextStyle(
//                                 fontSize: 16,
//                                 fontWeight: FontWeight.bold,
//                               ),
//                             ),
//                             10.addVerticalSpace,
//                             Text(
//                               lastMessage,
//                               maxLines: 2,
//                               overflow: TextOverflow.ellipsis,
//                               style: TextStyle(fontSize: 14),
//                             ),
//                           ],
//                         );
//                       },
//                     ),
//                     Spacer(),
//                     Text(
//                       lastMessageDate.toFormattedString(),
//                       style: TextStyle(color: Colors.grey),
//                     ),
//                   ],
//                 ),
//                 SizedBox(height: 8),
//               ],
//             ),
//           ),
//         );
//       },
//     );
//   }
// }

class ChatItem extends StatefulWidget {
  final DocumentSnapshot? documentSnapshot;

  const ChatItem(this.documentSnapshot) : super();

  @override
  State<ChatItem> createState() => _ChatItemState();
}

class _ChatItemState extends State<ChatItem> {
  User? authUser;
  // @override
  // void didChangeDependencies() {
  //   authUser =
  //       Provider.of<AuthController>(context, listen: false).auth.currentUser;
  //   // TODO: implement didChangeDependencies
  //   super.didChangeDependencies();
  // }

  @override
  void initState() {
    authUser =
        Provider.of<AuthController>(context, listen: false).auth.currentUser;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    if (widget.documentSnapshot != null) {
      ChatUser userChat = ChatUser.fromDocument(widget.documentSnapshot!);
      if (userChat.id == authUser!.uid) {
        return const SizedBox.shrink();
      } else {
        return TextButton(
          onPressed: () {
            if (KeyboardUtils.isKeyboardShowing()) {
              KeyboardUtils.closeKeyboard(context);
            }
            print("This props ${userChat.props}");
            ChatArgument chatArgument = ChatArgument(
              peerId: userChat.id,
              peerAvatar: userChat.photoUrl,
              peerNickname: userChat.displayName,
              userAvatar: authUser!.photoURL ?? "",
            );
            ServiceNavigation.serviceNavi
                .pushNamedWidget(RouteGenerator.chatPage, args: chatArgument);
          },
          child: ListTile(
            leading: userChat.photoUrl.isNotEmpty
                ? ClipRRect(
                    borderRadius: BorderRadius.circular(20),
                    child: Image.network(
                      userChat.photoUrl,
                      fit: BoxFit.cover,
                      width: 50,
                      height: 50,
                      loadingBuilder: (BuildContext ctx, Widget child,
                          ImageChunkEvent? loadingProgress) {
                        if (loadingProgress == null) {
                          return child;
                        } else {
                          return SizedBox(
                            width: 50,
                            height: 50,
                            child: CircularProgressIndicator(
                                color: Colors.grey,
                                value: loadingProgress.expectedTotalBytes !=
                                        null
                                    ? loadingProgress.cumulativeBytesLoaded /
                                        loadingProgress.expectedTotalBytes!
                                    : null),
                          );
                        }
                      },
                      errorBuilder: (context, object, stackTrace) {
                        return const Icon(Icons.account_circle, size: 50);
                      },
                    ),
                  )
                : const Icon(
                    Icons.account_circle,
                    size: 50,
                  ),
            title: Text(
              "${userChat.displayName}",
              style: const TextStyle(color: Colors.black),
            ),
          ),
        );
      }
    } else {
      return const SizedBox.shrink();
    }
  }
}

// Widget buildItem(
//     BuildContext context, DocumentSnapshot? documentSnapshot, currentUserId) {
//   if (documentSnapshot != null) {
//     ChatUser userChat = ChatUser.fromDocument(documentSnapshot);
//     if (userChat.id == currentUserId) {
//       return const SizedBox.shrink();
//     } else {
//       return TextButton(
//         onPressed: () {
//           if (KeyboardUtils.isKeyboardShowing()) {
//             KeyboardUtils.closeKeyboard(context);
//           }
//           print("This name ${userChat.displayName}");
//           ChatArgument chatArgument = ChatArgument(
//             peerId: userChat.id,
//             peerAvatar: userChat.photoUrl,
//             peerNickname: userChat.displayName,
//             userAvatar: Provider.of<AuthController>(context, listen: false)
//                     .auth
//                     .currentUser!
//                     .photoURL ??
//                 "",
//           );
//           ServiceNavigation.serviceNavi
//               .pushNamedWidget(RouteGenerator.chatPage, args: chatArgument);
//         },
//         child: ListTile(
//           leading: userChat.photoUrl.isNotEmpty
//               ? ClipRRect(
//                   borderRadius: BorderRadius.circular(20),
//                   child: Image.network(
//                     userChat.photoUrl,
//                     fit: BoxFit.cover,
//                     width: 50,
//                     height: 50,
//                     loadingBuilder: (BuildContext ctx, Widget child,
//                         ImageChunkEvent? loadingProgress) {
//                       if (loadingProgress == null) {
//                         return child;
//                       } else {
//                         return SizedBox(
//                           width: 50,
//                           height: 50,
//                           child: CircularProgressIndicator(
//                               color: Colors.grey,
//                               value: loadingProgress.expectedTotalBytes != null
//                                   ? loadingProgress.cumulativeBytesLoaded /
//                                       loadingProgress.expectedTotalBytes!
//                                   : null),
//                         );
//                       }
//                     },
//                     errorBuilder: (context, object, stackTrace) {
//                       return const Icon(Icons.account_circle, size: 50);
//                     },
//                   ),
//                 )
//               : const Icon(
//                   Icons.account_circle,
//                   size: 50,
//                 ),
//           title: Text(
//             "www${userChat.displayName}",
//             style: const TextStyle(color: Colors.black),
//           ),
//         ),
//       );
//     }
//   } else {
//     return const SizedBox.shrink();
//   }
// }
