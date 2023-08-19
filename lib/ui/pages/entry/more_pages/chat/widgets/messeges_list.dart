import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:food_delivery_app/ui/pages/entry/more_pages/chat/chat_controllers/chat_controller.dart';
import 'package:food_delivery_app/ui/pages/entry/more_pages/chat/ui/chat_screen.dart';
import 'package:food_delivery_app/ui/pages/entry/more_pages/chat/widgets/message_bubbel.dart';
import 'package:provider/provider.dart';

class MessagesListWidget extends StatelessWidget {
  final ChatArgument? chatArgument;
  const MessagesListWidget({Key? key, this.chatArgument}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Consumer<ChatController>(builder: (context, chatController, child) {
      return Flexible(
          child: StreamBuilder<QuerySnapshot>(
              stream: chatController.getChatMessage(chatController.groupChatId),
              builder: (BuildContext context,
                  AsyncSnapshot<QuerySnapshot> snapshot) {
                if (snapshot.hasData) {
                  chatController.listMessages = snapshot.data!.docs;
                  if (chatController.listMessages.isNotEmpty) {
                    return ListView.separated(
                        padding: const EdgeInsets.all(10),
                        itemCount: snapshot.data!.docs.length,
                        separatorBuilder: (context, index) => Divider(
                              color: Colors.transparent,
                              height: 3,
                            ),
                        reverse: true,
                        itemBuilder: (context, index) {
                          if (snapshot.hasData && snapshot.data != null) {
                            return MessageBubbleWidget(
                              index: index,
                              documentSnapshot: snapshot.data?.docs[index],
                              chatArgument: chatArgument,
                            );
                          } else {
                            return Center(
                              child: SizedBox(
                                height: 36,
                                width: 36,
                                child: CircularProgressIndicator(
                                  valueColor: AlwaysStoppedAnimation<Color>(
                                      Colors.blue),
                                ),
                              ),
                            );
                          }
                        });
                  } else {
                    return const Center(
                      child: Text('No messages...'),
                    );
                  }
                } else {
                  return const Center(
                    child: CircularProgressIndicator(
                      color: Colors.red,
                    ),
                  );
                }
              }));
    });
  }
}

// Widget buildListMessage() {
//   return Flexible(
//     child: groupChatId.isNotEmpty
//         ? StreamBuilder<QuerySnapshot>(
//             stream: chatProvider.getChatMessage(groupChatId, _limit),
//             builder:
//                 (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
//               if (snapshot.hasData) {
//                 listMessages = snapshot.data!.docs;
//                 if (listMessages.isNotEmpty) {
//                   return ListView.builder(
//                       padding: const EdgeInsets.all(10),
//                       itemCount: snapshot.data?.docs.length,
//                       reverse: true,
//                       controller: scrollController,
//                       itemBuilder: (context, index) {
//                         if (snapshot.hasData && snapshot.data != null) {
//                           return buildItem(index, snapshot.data?.docs[index]);
//                         } else {
//                           return Center(
//                             child: SizedBox(
//                               height: 36,
//                               width: 36,
//                               child: CircularProgressIndicator(
//                                 valueColor:
//                                     AlwaysStoppedAnimation<Color>(Colors.blue),
//                               ),
//                             ),
//                           );
//                         }
//                       });
//                 } else {
//                   return const Center(
//                     child: Text('No messages...'),
//                   );
//                 }
//               } else {
//                 return const Center(
//                   child: CircularProgressIndicator(
//                     color: Colors.red,
//                   ),
//                 );
//               }
//             })
//         : const Center(
//             child: CircularProgressIndicator(
//               color: Colors.red,
//             ),
//           ),
//   );
// }
