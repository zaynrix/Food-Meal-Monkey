// class ChatItemUI extends StatefulWidget {
//   final ChatItemModel viewModel;
//
//   const ChatItemUI(this.viewModel);
//
//   @override
//   State<ChatItemUI> createState() => _ChatItemUIState();
// }
//
// class _ChatItemUIState extends State<ChatItemUI> {
//   User? authUser;
//   ChatController? chatController;
//   Stream<Map<String, dynamic>?>? lastMessageStream;
//
//   @override
//   void initState() {
//     super.initState();
//     authUser =
//         Provider.of<AuthController>(context, listen: false).auth.currentUser;
//     chatController = Provider.of<ChatController>(context, listen: false);
//     ;
//   }
//
//   @override
//   void didChangeDependencies() {
//     super.didChangeDependencies();
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     if (chatItemModel.documentSnapshot != null) {
//       ChatUser userChat =
//           ChatUser.fromDocument(chatItemModel.documentSnapshot!);
//       return TextButton(
//         onPressed: () {
//           if (KeyboardUtils.isKeyboardShowing()) {
//             KeyboardUtils.closeKeyboard(context);
//           }
//           ChatArgument chatArgument = ChatArgument(
//             peerId: userChat.id,
//             peerAvatar: userChat.photoUrl,
//             peerNickname: userChat.displayName,
//             userAvatar: authUser!.photoURL ?? "",
//           );
//           chatController!.setIdTo(chatItemModel.idTo!);
//           ServiceNavigation.serviceNavi
//               .pushNamedWidget(RouteGenerator.chatPage, args: chatArgument);
//         },
//         child: ListTile(
//           subtitle: Row(
//             mainAxisSize: MainAxisSize.min,
//             children: [
//               if (chatItemModel.lastMessageType == "Text")
//                 const Icon(Icons.text_fields), // Change this icon as needed
//               if (chatItemModel.lastMessageType == "Image")
//                 const Icon(Icons.image), // Change this icon as needed
//               if (chatItemModel.lastMessageType == "Sticker")
//                 const Icon(Icons.star), // Change this icon as needed
//               if (chatItemModel.lastMessageType == "Audio")
//                 const Icon(
//                     Icons.music_video_sharp), // Change this icon as needed
//               const SizedBox(width: 8),
//               Expanded(
//                 child: Text(
//                   "${chatItemModel.lastMessageType}",
//                   maxLines: 1,
//                   overflow: TextOverflow.ellipsis,
//                 ),
//               ),
//             ],
//           ),
//           leading: userChat.photoUrl.isNotEmpty
//               ? ClipOval(
//                   child: CachedNetworkImage(
//                     imageUrl: userChat.photoUrl,
//                     imageBuilder: (context, imageProvider) => Container(
//                       width: 50,
//                       height: 50,
//                       decoration: BoxDecoration(
//                         shape: BoxShape.circle,
//                         image: DecorationImage(
//                           image: imageProvider,
//                           fit: BoxFit.cover,
//                         ),
//                       ),
//                     ),
//                     placeholder: (context, url) => SizedBox(
//                       width: 50,
//                       height: 50,
//                       child: CircularProgressIndicator(
//                         color: Colors.grey,
//                       ),
//                     ),
//                     errorWidget: (context, url, error) => const Icon(
//                       Icons.account_circle,
//                       size: 50,
//                     ),
//                   ),
//                 )
//               : Image.asset(
//                   ImageAssets.app_icon,
//                   width: 50,
//                   height: 50,
//                 ),
//           title: Text(
//             "${userChat.displayName}",
//             style: const TextStyle(color: Colors.black),
//           ),
//           trailing: Column(
//             mainAxisAlignment: MainAxisAlignment.center,
//             crossAxisAlignment: CrossAxisAlignment.end,
//             children: [
//               Text(
//                 "${chatItemModel.messageTime}",
//                 style: const TextStyle(color: Colors.grey, fontSize: 12),
//               ),
//               chatItemModel.isSeen!
//                   ? Icon(
//                       Icons.done_all,
//                       // This is an example icon, replace with your preferred indicator
//                       color: Colors
//                           .blue, // This is an example color, adjust as needed
//                     )
//                   : Visibility(
//                       visible: chatItemModel.messageTime != "",
//                       child: Icon(
//                         Icons.done,
//                         // This is an example icon, replace with your preferred indicator
//                         color: Colors
//                             .grey, // This is an example color, adjust as needed
//                       ),
//                     ),
//             ],
//           ),
//         ),
//       );
//       // }
//     } else {
//       return const Text("ww");
//     }
//   }
// }
// class ChatItemUI extends StatefulWidget {
//   final DocumentSnapshot chatData;
//   const ChatItemUI(this.chatData);
//
//   @override
//   State<ChatItemUI> createState() => _ChatItemUIState();
// }
//
// class _ChatItemUIState extends State<ChatItemUI> {
//   User? authUser;
//   ChatController? chatController;
//   late StreamSubscription<Map<String, dynamic>?> lastMessageSubscription;
//
//   @override
//   void initState() {
//     super.initState();
//     authUser =
//         Provider.of<AuthController>(context, listen: false).auth.currentUser;
//     chatController = Provider.of<ChatController>(context, listen: false);
//
//     lastMessageSubscription =
//         chatController!.lastMessageStreamController.stream.listen(
//       (messageData) {
//         if (messageData != null) {
//           // Handle the last message data here
//           // Update the UI as needed
//         }
//       },
//       onError: (error) {
//         print("Error fetching last message: $error");
//       },
//     );
//   }
//
//   @override
//   void dispose() {
//     lastMessageSubscription.cancel(); // Cancel the subscription when disposing
//     super.dispose();
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     ChatUser userChat = ChatUser.fromDocument(widget.chatData);
//     //       ChatItemModel chatItemModel = ChatItemModel.fromSnapshot(
// //         lastMessageData!,
// //         widget.chatData,
// //         chatController!.extractLastMessage(lastMessageData!),
// //       );
//     return ListTile(
//       onTap: () {
//         if (KeyboardUtils.isKeyboardShowing()) {
//           KeyboardUtils.closeKeyboard(context);
//         }
//         ChatArgument chatArgument = ChatArgument(
//           peerId: userChat.id,
//           peerAvatar: userChat.photoUrl,
//           peerNickname: userChat.displayName,
//           userAvatar: authUser!.photoURL ?? "",
//         );
//         chatController!.setIdTo(chatItemModel.idTo!);
//         ServiceNavigation.serviceNavi
//             .pushNamedWidget(RouteGenerator.chatPage, args: chatArgument);
//       },
//       subtitle: Row(
//         mainAxisSize: MainAxisSize.min,
//         children: [
//           if (chatItemModel.lastMessageType == "Text")
//             const Icon(Icons.text_fields), // Change this icon as needed
//           if (chatItemModel.lastMessageType == "Image")
//             const Icon(Icons.image), // Change this icon as needed
//           if (chatItemModel.lastMessageType == "Sticker")
//             const Icon(Icons.star), // Change this icon as needed
//           if (chatItemModel.lastMessageType == "Audio")
//             const Icon(Icons.music_video_sharp), // Change this icon as needed
//           const SizedBox(width: 8),
//           Expanded(
//             child: Text(
//               "${messageSnapshot.data!["text"]}",
//               maxLines: 1,
//               overflow: TextOverflow.ellipsis,
//             ),
//           ),
//         ],
//       ),
//       leading: userChat.photoUrl.isNotEmpty
//           ? ClipOval(
//               child: CachedNetworkImage(
//                 imageUrl: userChat.photoUrl,
//                 imageBuilder: (context, imageProvider) => Container(
//                   width: 50,
//                   height: 50,
//                   decoration: BoxDecoration(
//                     shape: BoxShape.circle,
//                     image: DecorationImage(
//                       image: imageProvider,
//                       fit: BoxFit.cover,
//                     ),
//                   ),
//                 ),
//                 placeholder: (context, url) => SizedBox(
//                   width: 50,
//                   height: 50,
//                   child: CircularProgressIndicator(
//                     color: Colors.grey,
//                   ),
//                 ),
//                 errorWidget: (context, url, error) => const Icon(
//                   Icons.account_circle,
//                   size: 50,
//                 ),
//               ),
//             )
//           : Image.asset(
//               ImageAssets.app_icon,
//               width: 50,
//               height: 50,
//             ),
//       title: Text(
//         "${userChat.displayName}",
//         style: const TextStyle(color: Colors.black),
//       ),
//       trailing: StreamBuilder<Map<String, dynamic>?>(
//         stream: chatController!.lastMessageStreamController.stream,
//         builder: (context, messageSnapshot) {
//           if (messageSnapshot.connectionState == ConnectionState.waiting) {
//             return CircularProgressIndicator();
//           } else if (messageSnapshot.hasError) {
//             return Text('Error fetching data');
//           } else if (messageSnapshot.data != null) {
//             return chatItemModel.seenByReceiver!
//                 ? Icon(
//                     Icons.done_all,
//                     // This is an example icon, replace with your preferred indicator
//                     color: Colors.blue,
//                   )
//                 : Visibility(
//                     visible: chatItemModel.messageTime != "",
//                     child: Icon(
//                       Icons.done,
//                       // This is an example icon, replace with your preferred indicator
//                       color: Colors.grey,
//                     ),
//                   );
//           } else {
//             return Text("NOOOOooo");
//           }
//         },
//       ),
//     );
//   }
// }

// class ChatItemUI extends StatefulWidget {
//   final DocumentSnapshot chatData;
//
//   const ChatItemUI(this.chatData);
//
//   @override
//   State<ChatItemUI> createState() => _ChatItemUIState();
// }
//
// class _ChatItemUIState extends State<ChatItemUI> {
//   User? authUser;
//   ChatController? chatController;
//   // Map<String, dynamic>? lastMessageData;
//
//   late StreamSubscription<Map<String, dynamic>?> lastMessageSubscription;
//
//   @override
//   void initState() {
//     super.initState();
//     authUser =
//         Provider.of<AuthController>(context, listen: false).auth.currentUser;
//     chatController = Provider.of<ChatController>(context, listen: false);
//
//     // Subscribe to the chat controller's stream
//     lastMessageSubscription = chatController!
//         .getLastMessageForUserChatsStream(
//       ChatUser.fromDocument(widget.chatData).id,
//       authUser!.uid,
//     )
//         .listen((messageData) {
//       setState(() {
//         // lastMessageData = messageData;
//       });
//     });
//   }
//
//   @override
//   void dispose() {
//     // Cancel the subscription and close the stream controller
//     // lastMessageSubscription.cancel();
//     // chatController!.lastMessageStreamController.close();
//     super.dispose();
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     // if (lastMessageData != null) {
//     // ChatUser userChat = ChatUser.fromDocument(widget.chatData);
//
//     return StreamBuilder<Map<String, dynamic>?>(
//         stream: chatController!.lastMessageStreamController.stream,
//         builder: (context, messageSnapshot) {
//           if (messageSnapshot.connectionState == ConnectionState.waiting) {
//             return CircularProgressIndicator();
//           } else if (messageSnapshot.hasError) {
//             return Text('Error fetching data');
//           } else if (messageSnapshot.data != null) {
//             Map<String, dynamic>? lastMessageData = messageSnapshot.data;
//             if (lastMessageData != null) {
//               ChatUser userChat = ChatUser.fromDocument(widget.chatData);
//               ChatItemModel chatItemModel = ChatItemModel.fromSnapshot(
//                 lastMessageData,
//                 widget.chatData,
//                 chatController!.extractLastMessage(lastMessageData),
//               );
//               return TextButton(
//                 onPressed: () {
//                   if (KeyboardUtils.isKeyboardShowing()) {
//                     KeyboardUtils.closeKeyboard(context);
//                   }
//                   ChatArgument chatArgument = ChatArgument(
//                     peerId: userChat.id,
//                     peerAvatar: userChat.photoUrl,
//                     peerNickname: userChat.displayName,
//                     userAvatar: authUser!.photoURL ?? "",
//                   );
//                   chatController!.setIdTo(chatItemModel.idTo!);
//                   ServiceNavigation.serviceNavi.pushNamedWidget(
//                     RouteGenerator.chatPage,
//                     args: chatArgument,
//                   );
//                 },
//                 child: ListTile(
//                   subtitle: Row(
//                     mainAxisSize: MainAxisSize.min,
//                     children: [
//                       if (chatItemModel.lastMessageType == "Text")
//                         const Icon(
//                             Icons.text_fields), // Change this icon as needed
//                       if (chatItemModel.lastMessageType == "Image")
//                         const Icon(Icons.image), // Change this icon as needed
//                       if (chatItemModel.lastMessageType == "Sticker")
//                         const Icon(Icons.star), // Change this icon as needed
//                       if (chatItemModel.lastMessageType == "Audio")
//                         const Icon(Icons
//                             .music_video_sharp), // Change this icon as needed
//                       const SizedBox(width: 8),
//                       Expanded(
//                         child: Text(
//                           chatItemModel.lastMessage!,
//                           maxLines: 1,
//                           overflow: TextOverflow.ellipsis,
//                         ),
//                       ),
//                     ],
//                   ),
//                   leading: userChat.photoUrl.isNotEmpty
//                       ? ClipOval(
//                           child: CachedNetworkImage(
//                             imageUrl: userChat.photoUrl,
//                             imageBuilder: (context, imageProvider) => Container(
//                               width: 50,
//                               height: 50,
//                               decoration: BoxDecoration(
//                                 shape: BoxShape.circle,
//                                 image: DecorationImage(
//                                   image: imageProvider,
//                                   fit: BoxFit.cover,
//                                 ),
//                               ),
//                             ),
//                             placeholder: (context, url) => SizedBox(
//                               width: 50,
//                               height: 50,
//                               child: CircularProgressIndicator(
//                                 color: Colors.grey,
//                               ),
//                             ),
//                             errorWidget: (context, url, error) => const Icon(
//                               Icons.account_circle,
//                               size: 50,
//                             ),
//                           ),
//                         )
//                       : Image.asset(
//                           ImageAssets.app_icon,
//                           width: 50,
//                           height: 50,
//                         ),
//                   title: Text(
//                     "${userChat.displayName}",
//                     style: const TextStyle(color: Colors.black),
//                   ),
//                   trailing: Column(
//                     mainAxisAlignment: MainAxisAlignment.center,
//                     crossAxisAlignment: CrossAxisAlignment.end,
//                     children: [
//                       Text(
//                         "${chatItemModel.messageTime}",
//                         style:
//                             const TextStyle(color: Colors.grey, fontSize: 12),
//                       ),
//                       chatItemModel.seenByReceiver!
//                           ? Icon(
//                               Icons.done_all,
//                               // This is an example icon, replace with your preferred indicator
//                               color: Colors
//                                   .blue, // This is an example color, adjust as needed
//                             )
//                           : Visibility(
//                               visible: chatItemModel.messageTime != "",
//                               child: Icon(
//                                 Icons.done,
//                                 // This is an example icon, replace with your preferred indicator
//                                 color: Colors
//                                     .grey, // This is an example color, adjust as needed
//                               ),
//                             ),
//                     ],
//                   ),
//                 ),
//                 // child: ListTile(
//                 //   title: Text("Content ${chatItemModel.lastMessage}"),
//                 // ),
//               );
//             } else {
//               return Text("I DONT KNOW WHY");
//             }
//           } else {
//             return Text("NOOOOooo");
//           }
//           // child:
//         });
//   }
// }

// class ChatItemUI extends StatefulWidget {
//   final DocumentSnapshot chatData;
//
//   const ChatItemUI(this.chatData);
//
//   @override
//   State<ChatItemUI> createState() => _ChatItemUIState();
// }
//
// class _ChatItemUIState extends State<ChatItemUI> {
//   User? authUser;
//   ChatController? chatController;
//   Map<String, dynamic>? lastMessageData;
//   StreamSubscription? _streamSubscription;
//
//   @override
//   void initState() {
//     super.initState();
//     authUser =
//         Provider.of<AuthController>(context, listen: false).auth.currentUser;
//     chatController = Provider.of<ChatController>(context, listen: false);
//     chatController!.getLastMessageForUserChatsStream(
//       ChatUser.fromDocument(widget.chatData).id,
//       authUser!.uid,
//     );
//     _streamSubscription =
//         chatController!.lastMessageStreamController.stream.listen((data) {
//       setState(() {
//         lastMessageData = data;
//       });
//     });
//
//     // chatController!.lastMessageStreamController.stream.listen((data) {
//     //   setState(() {
//     //     lastMessageData = data;
//     //   });
//     // });
//   }
//
//   @override
//   void dispose() {
//     _streamSubscription?.cancel();
//
//     chatController!.lastMessageStreamController.close();
//     super.dispose();
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     // if (chatItemModel.documentSnapshot != null) {
//     ChatUser userChat = ChatUser.fromDocument(widget.chatData);
//
//     // StreamBuilder<Map<String, dynamic>?>(
//     // stream: chatController!.getLastMessageForUserChatsStream(
//     //   userChat.id,
//     //   authUser!.uid,
//     // ),
//     // builder: (context, messageSnapshot) {
//     //   print("stackTrace ${messageSnapshot.stackTrace}");
//     //   if (messageSnapshot.connectionState == ConnectionState.waiting) {
//     //     return Center(child: CircularProgressIndicator());
//     //   } else if (messageSnapshot.hasError) {
//     //     return Text('Error fetching data');
//     //   } else
//
//     if (lastMessageData != null) {
//       ChatItemModel chatItemModel = ChatItemModel.fromSnapshot(
//         lastMessageData!,
//         widget.chatData,
//         chatController!.extractLastMessage(lastMessageData!),
//       );
//       return TextButton(
//         onPressed: () {
//           if (KeyboardUtils.isKeyboardShowing()) {
//             KeyboardUtils.closeKeyboard(context);
//           }
//           ChatArgument chatArgument = ChatArgument(
//             peerId: userChat.id,
//             peerAvatar: userChat.photoUrl,
//             peerNickname: userChat.displayName,
//             userAvatar: authUser!.photoURL ?? "",
//           );
//           chatController!.setIdTo(chatItemModel.idTo!);
//           ServiceNavigation.serviceNavi
//               .pushNamedWidget(RouteGenerator.chatPage, args: chatArgument);
//         },
//         child: ListTile(
//           subtitle: Row(
//             mainAxisSize: MainAxisSize.min,
//             children: [
//               if (chatItemModel.lastMessageType == "Text")
//                 const Icon(Icons.text_fields), // Change this icon as needed
//               if (chatItemModel.lastMessageType == "Image")
//                 const Icon(Icons.image), // Change this icon as needed
//               if (chatItemModel.lastMessageType == "Sticker")
//                 const Icon(Icons.star), // Change this icon as needed
//               if (chatItemModel.lastMessageType == "Audio")
//                 const Icon(
//                     Icons.music_video_sharp), // Change this icon as needed
//               const SizedBox(width: 8),
//               Expanded(
//                 child: Text(
//                   chatItemModel.lastMessage!,
//                   maxLines: 1,
//                   overflow: TextOverflow.ellipsis,
//                 ),
//               ),
//             ],
//           ),
//           leading: userChat.photoUrl.isNotEmpty
//               ? ClipOval(
//                   child: CachedNetworkImage(
//                     imageUrl: userChat.photoUrl,
//                     imageBuilder: (context, imageProvider) => Container(
//                       width: 50,
//                       height: 50,
//                       decoration: BoxDecoration(
//                         shape: BoxShape.circle,
//                         image: DecorationImage(
//                           image: imageProvider,
//                           fit: BoxFit.cover,
//                         ),
//                       ),
//                     ),
//                     placeholder: (context, url) => SizedBox(
//                       width: 50,
//                       height: 50,
//                       child: CircularProgressIndicator(
//                         color: Colors.grey,
//                       ),
//                     ),
//                     errorWidget: (context, url, error) => const Icon(
//                       Icons.account_circle,
//                       size: 50,
//                     ),
//                   ),
//                 )
//               : Image.asset(
//                   ImageAssets.app_icon,
//                   width: 50,
//                   height: 50,
//                 ),
//           title: Text(
//             "${userChat.displayName}",
//             style: const TextStyle(color: Colors.black),
//           ),
//           trailing: Column(
//             mainAxisAlignment: MainAxisAlignment.center,
//             crossAxisAlignment: CrossAxisAlignment.end,
//             children: [
//               Text(
//                 "${chatItemModel.messageTime}",
//                 style: const TextStyle(color: Colors.grey, fontSize: 12),
//               ),
//               chatItemModel.seenByReceiver!
//                   ? Icon(
//                       Icons.done_all,
//                       // This is an example icon, replace with your preferred indicator
//                       color: Colors
//                           .blue, // This is an example color, adjust as needed
//                     )
//                   : Visibility(
//                       visible: chatItemModel.messageTime != "",
//                       child: Icon(
//                         Icons.done,
//                         // This is an example icon, replace with your preferred indicator
//                         color: Colors
//                             .grey, // This is an example color, adjust as needed
//                       ),
//                     ),
//             ],
//           ),
//         ),
//       );
//     } else {
//       return Text("NOOOOooo");
//     }
//     // };
//
//     // child:
//     // );
//     // }
//     // } else {
//     //   return const Text("ww");
//     // }
//   }
// }
