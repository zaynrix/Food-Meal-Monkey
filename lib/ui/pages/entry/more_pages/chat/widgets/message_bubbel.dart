import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:food_delivery_app/core/controllers/auth_controller/auth_controller.dart';
import 'package:food_delivery_app/ui/pages/entry/more_pages/chat/chat_controllers/chat_controller.dart';
import 'package:food_delivery_app/ui/pages/entry/more_pages/chat/models/chat_messages.dart';
import 'package:food_delivery_app/ui/pages/entry/more_pages/chat/ui/chat_screen.dart';
import 'package:food_delivery_app/ui/pages/entry/more_pages/chat/widgets/message_card.dart';
import 'package:food_delivery_app/ui/pages/entry/more_pages/chat/widgets/message_card_image.dart';
import 'package:food_delivery_app/utils/extension/responsive_extension.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:voice_message_package/voice_message_package.dart';

class MessageBubbleWidget extends StatefulWidget {
  final int? index;
  final DocumentSnapshot? documentSnapshot;
  final ChatArgument? chatArgument;

  const MessageBubbleWidget(
      {Key? key, this.chatArgument, this.documentSnapshot, this.index})
      : super(key: key);

  @override
  State<MessageBubbleWidget> createState() => _MessageBubbleWidgetState();
}

class _MessageBubbleWidgetState extends State<MessageBubbleWidget> {
  User? userData;

  @override
  void initState() {
    // TODO: implement initState
    userData =
        Provider.of<AuthController>(context, listen: false).auth.currentUser;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    if (widget.documentSnapshot != null) {
      ChatMessages chatMessages =
          ChatMessages.fromDocument(widget.documentSnapshot!);
      if (chatMessages.idFrom == userData!.uid) {
        // right side (my message)
        return Consumer<ChatController>(
          builder: (context, chatController, child) => Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  chatMessages.type == MessageType.audio
                      ? VoiceMessage(
                          meBgColor: Colors.black38,
                          audioSrc: '${chatMessages.content}',
                          played: true,
                          // To show played badge or not.
                          me: false,
                          noiseCount: 1,

                          // Set message side.
                          onPlay: () {
                            chatController.loadFile('${chatMessages.content}');
                          }, // Do something when voice played.
                        )
                      : SizedBox.shrink(),
                  chatMessages.type == MessageType.text
                      ? Row(
                          children: [
                            messageBubble(
                              chatContent: chatMessages.content,
                              // color: AppColors.spaceLight,
                              // textColor: AppColors.white,
                              margin: 10.marginRight,
                            ),
                          ],
                        )
                      : chatMessages.type == MessageType.image
                          ? Container(
                              margin: EdgeInsets.only(right: 10, top: 10),
                              child: chatImage(
                                  imageSrc: chatMessages.content, onTap: () {}),
                            )
                          : const SizedBox.shrink(),
                  chatController.isMessageSent(widget.index!)
                      ? Container(
                          clipBehavior: Clip.hardEdge,
                          decoration: BoxDecoration(
                            borderRadius:
                                BorderRadius.circular(20.borderRadius),
                          ),
                          child: Image.network(
                            widget.chatArgument!.userAvatar,
                            width: 40.width,
                            height: 40.height,
                            fit: BoxFit.cover,
                            loadingBuilder: (BuildContext ctx, Widget child,
                                ImageChunkEvent? loadingProgress) {
                              if (loadingProgress == null) return child;
                              return Center(
                                child: CircularProgressIndicator(
                                  color: Colors.red,
                                  value: loadingProgress.expectedTotalBytes !=
                                              null &&
                                          loadingProgress.expectedTotalBytes !=
                                              null
                                      ? loadingProgress.cumulativeBytesLoaded /
                                          loadingProgress.expectedTotalBytes!
                                      : null,
                                ),
                              );
                            },
                            errorBuilder: (context, object, stackTrace) {
                              return const Icon(
                                Icons.account_circle,
                                size: 35,
                                color: Colors.blueGrey,
                              );
                            },
                          ),
                        )
                      : Container(
                          width: 35,
                        ),
                ],
              ),
              chatController.isMessageSent(widget.index!)
                  ? Container(
                      margin: EdgeInsets.only(right: 50, top: 6, bottom: 8),
                      child: Text(
                        DateFormat('dd MMM yyyy, hh:mm a').format(
                          DateTime.fromMillisecondsSinceEpoch(
                            int.parse(chatMessages.timestamp),
                          ),
                        ),
                        style: const TextStyle(
                            color: Colors.grey,
                            fontSize: 12,
                            fontStyle: FontStyle.italic),
                      ),
                    )
                  : const SizedBox.shrink(),
            ],
          ),
        );
      } else {
        return Consumer<ChatController>(
          builder: (context, chatController, child) => Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  chatController.isMessageReceived(widget.index!)

                      // left side (received message)
                      ? Container(
                          clipBehavior: Clip.hardEdge,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Image.network(
                            widget.chatArgument!.peerAvatar,
                            width: 40,
                            height: 40,
                            fit: BoxFit.cover,
                            loadingBuilder: (BuildContext ctx, Widget child,
                                ImageChunkEvent? loadingProgress) {
                              if (loadingProgress == null) return child;
                              return Center(
                                child: CircularProgressIndicator(
                                  color: Colors.red,
                                  value: loadingProgress.expectedTotalBytes !=
                                              null &&
                                          loadingProgress.expectedTotalBytes !=
                                              null
                                      ? loadingProgress.cumulativeBytesLoaded /
                                          loadingProgress.expectedTotalBytes!
                                      : null,
                                ),
                              );
                            },
                            errorBuilder: (context, object, stackTrace) {
                              return const Icon(
                                Icons.account_circle,
                                size: 35,
                                color: Colors.grey,
                              );
                            },
                          ),
                        )
                      : Container(
                          width: 35,
                        ),
                  chatMessages.type == MessageType.audio
                      ? VoiceMessage(
                          meBgColor: Colors.red,
                          audioSrc: '${chatMessages.content}',
                          played: true,
                          // To show played badge or not.
                          me: true,
                          noiseCount: 1,
                          // Set message side.
                          onPlay: () {
                            chatController.loadFile('${chatMessages.content}');

                            // _loadFile(chatMessages.content);
                          }, // Do something when voice played.
                        )
                      : SizedBox.shrink(),
                  chatMessages.type == MessageType.text
                      ? messageBubble(
                          color: Colors.red,
                          textColor: Colors.white,
                          chatContent: chatMessages.content,
                          margin: EdgeInsets.only(left: 10),
                        )
                      : chatMessages.type == MessageType.image
                          ? Container(
                              margin: const EdgeInsets.only(left: 10, top: 10),
                              child: chatImage(
                                  imageSrc: chatMessages.content, onTap: () {}),
                            )
                          : const SizedBox.shrink(),
                ],
              ),
              chatController.isMessageReceived(widget.index!)
                  ? Container(
                      margin:
                          const EdgeInsets.only(left: 50, top: 6, bottom: 8),
                      child: Text(
                        DateFormat('dd MMM yyyy, hh:mm a').format(
                          DateTime.fromMillisecondsSinceEpoch(
                            int.parse(chatMessages.timestamp),
                          ),
                        ),
                        style: const TextStyle(
                            color: Colors.blueGrey,
                            fontSize: 12,
                            fontStyle: FontStyle.italic),
                      ),
                    )
                  : const SizedBox.shrink(),
            ],
          ),
        );
      }
    } else {
      return const SizedBox.shrink();
    }
  }
}

// Widget buildItem(int index, DocumentSnapshot? documentSnapshot) {
//   if (documentSnapshot != null) {
//     ChatMessages chatMessages = ChatMessages.fromDocument(documentSnapshot);
//     if (chatMessages.idFrom == authProvider.auth.currentUser!.uid) {
//       // right side (my message)
//       return Column(
//         crossAxisAlignment: CrossAxisAlignment.end,
//         children: [
//           Row(
//             mainAxisAlignment: MainAxisAlignment.end,
//             children: [
//               chatMessages.type == MessageType.audio
//                   ? VoiceMessage(
//                 meBgColor: Colors.black38,
//                 audioSrc: '${chatMessages.content}',
//                 played: true,
//                 // To show played badge or not.
//                 me: false,
//                 noiseCount: 1,
//
//                 // Set message side.
//                 onPlay: () {
//                   _loadFile('${chatMessages.content}');
//                 }, // Do something when voice played.
//               )
//                   : SizedBox.shrink(),
//               chatMessages.type == MessageType.text
//                   ? Row(
//                 children: [
//                   messageBubble(
//                     chatContent: chatMessages.content,
//                     // color: AppColors.spaceLight,
//                     // textColor: AppColors.white,
//                     margin: 10.marginRight,
//                   ),
//                 ],
//               )
//                   : chatMessages.type == MessageType.image
//                   ? Container(
//                 margin: EdgeInsets.only(right: 10, top: 10),
//                 child: chatImage(
//                     imageSrc: chatMessages.content, onTap: () {}),
//               )
//                   : const SizedBox.shrink(),
//               isMessageSent(index)
//                   ? Container(
//                 clipBehavior: Clip.hardEdge,
//                 decoration: BoxDecoration(
//                   borderRadius: BorderRadius.circular(20.borderRadius),
//                 ),
//                 child: Image.network(
//                   widget.arguments.userAvatar,
//                   width: 40.width,
//                   height: 40.height,
//                   fit: BoxFit.cover,
//                   loadingBuilder: (BuildContext ctx, Widget child,
//                       ImageChunkEvent? loadingProgress) {
//                     if (loadingProgress == null) return child;
//                     return Center(
//                       child: CircularProgressIndicator(
//                         color: Colors.red,
//                         value: loadingProgress.expectedTotalBytes !=
//                             null &&
//                             loadingProgress.expectedTotalBytes !=
//                                 null
//                             ? loadingProgress.cumulativeBytesLoaded /
//                             loadingProgress.expectedTotalBytes!
//                             : null,
//                       ),
//                     );
//                   },
//                   errorBuilder: (context, object, stackTrace) {
//                     return const Icon(
//                       Icons.account_circle,
//                       size: 35,
//                       color: Colors.blueGrey,
//                     );
//                   },
//                 ),
//               )
//                   : Container(
//                 width: 35,
//               ),
//             ],
//           ),
//           isMessageSent(index)
//               ? Container(
//             margin: EdgeInsets.only(right: 50, top: 6, bottom: 8),
//             child: Text(
//               DateFormat('dd MMM yyyy, hh:mm a').format(
//                 DateTime.fromMillisecondsSinceEpoch(
//                   int.parse(chatMessages.timestamp),
//                 ),
//               ),
//               style: const TextStyle(
//                   color: Colors.grey,
//                   fontSize: 12,
//                   fontStyle: FontStyle.italic),
//             ),
//           )
//               : const SizedBox.shrink(),
//         ],
//       );
//     } else {
//       return Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           Row(
//             mainAxisAlignment: MainAxisAlignment.start,
//             children: [
//               isMessageReceived(index)
//
//               // left side (received message)
//                   ? Container(
//                 clipBehavior: Clip.hardEdge,
//                 decoration: BoxDecoration(
//                   borderRadius: BorderRadius.circular(20),
//                 ),
//                 child: Image.network(
//                   widget.arguments.peerAvatar,
//                   width: 40,
//                   height: 40,
//                   fit: BoxFit.cover,
//                   loadingBuilder: (BuildContext ctx, Widget child,
//                       ImageChunkEvent? loadingProgress) {
//                     if (loadingProgress == null) return child;
//                     return Center(
//                       child: CircularProgressIndicator(
//                         color: Colors.red,
//                         value: loadingProgress.expectedTotalBytes !=
//                             null &&
//                             loadingProgress.expectedTotalBytes !=
//                                 null
//                             ? loadingProgress.cumulativeBytesLoaded /
//                             loadingProgress.expectedTotalBytes!
//                             : null,
//                       ),
//                     );
//                   },
//                   errorBuilder: (context, object, stackTrace) {
//                     return const Icon(
//                       Icons.account_circle,
//                       size: 35,
//                       color: Colors.grey,
//                     );
//                   },
//                 ),
//               )
//                   : Container(
//                 width: 35,
//               ),
//               chatMessages.type == MessageType.audio
//                   ? VoiceMessage(
//                 meBgColor: Colors.red,
//                 audioSrc: '${chatMessages.content}',
//                 played: true,
//                 // To show played badge or not.
//                 me: true,
//                 noiseCount: 1,
//                 // Set message side.
//                 onPlay: () {
//                   _loadFile('${chatMessages.content}');
//
//                   // _loadFile(chatMessages.content);
//                 }, // Do something when voice played.
//               )
//                   : SizedBox.shrink(),
//               chatMessages.type == MessageType.text
//                   ? messageBubble(
//                 color: Colors.red,
//                 textColor: Colors.white,
//                 chatContent: chatMessages.content,
//                 margin: EdgeInsets.only(left: 10),
//               )
//                   : chatMessages.type == MessageType.image
//                   ? Container(
//                 margin: const EdgeInsets.only(left: 10, top: 10),
//                 child: chatImage(
//                     imageSrc: chatMessages.content, onTap: () {}),
//               )
//                   : const SizedBox.shrink(),
//             ],
//           ),
//           isMessageReceived(index)
//               ? Container(
//             margin: const EdgeInsets.only(left: 50, top: 6, bottom: 8),
//             child: Text(
//               DateFormat('dd MMM yyyy, hh:mm a').format(
//                 DateTime.fromMillisecondsSinceEpoch(
//                   int.parse(chatMessages.timestamp),
//                 ),
//               ),
//               style: const TextStyle(
//                   color: Colors.blueGrey,
//                   fontSize: 12,
//                   fontStyle: FontStyle.italic),
//             ),
//           )
//               : const SizedBox.shrink(),
//         ],
//       );
//     }
//   } else {
//     return const SizedBox.shrink();
//   }
// }
