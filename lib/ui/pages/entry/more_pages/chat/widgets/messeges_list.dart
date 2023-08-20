import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:food_delivery_app/ui/pages/entry/more_pages/chat/chat_controllers/chat_controller.dart';
import 'package:food_delivery_app/ui/pages/entry/more_pages/chat/ui/chat_screen.dart';
import 'package:food_delivery_app/ui/pages/entry/more_pages/chat/widgets/message_bubbel.dart';
import 'package:food_delivery_app/utils/extension/responsive_extension.dart';
import 'package:food_delivery_app/utils/extension/time_extension.dart';
// class MessagesListWidget extends StatelessWidget {
//   final ChatArgument? chatArgument;
//   const MessagesListWidget({Key? key, this.chatArgument}) : super(key: key);
//
//   @override
//   Widget build(BuildContext context) {
//     return Consumer<ChatController>(builder: (context, chatController, child) {
//       return Flexible(
//           child: StreamBuilder<QuerySnapshot>(
//               stream: chatController.getChatMessage(chatController.groupChatId),
//               builder: (BuildContext context,
//                   AsyncSnapshot<QuerySnapshot> snapshot) {
//                 if (snapshot.hasData) {
//                   chatController.listMessages = snapshot.data!.docs;
//                   if (chatController.listMessages.isNotEmpty) {
//                     return ListView.separated(
//                         shrinkWrap: true,
//                         padding: const EdgeInsets.all(10),
//                         itemCount: snapshot.data!.docs.length,
//                         separatorBuilder: (context, index) => Divider(
//                               color: Colors.transparent,
//                               height: 3,
//                             ),
//                         reverse: true,
//                         itemBuilder: (context, index) {
//                           if (snapshot.hasData && snapshot.data != null) {
//                             return MessageBubbleWidget(
//                               index: index,
//                               documentSnapshot: snapshot.data?.docs[index],
//                               chatArgument: chatArgument,
//                             );
//                           } else {
//                             return Center(
//                               child: SizedBox(
//                                 height: 36,
//                                 width: 36,
//                                 child: CircularProgressIndicator(
//                                   valueColor: AlwaysStoppedAnimation<Color>(
//                                       Colors.blue),
//                                 ),
//                               ),
//                             );
//                           }
//                         });
//                   } else {
//                     return const Center(
//                       child: Text('No messages...'),
//                     );
//                   }
//                 } else {
//                   return const Center(
//                     child: CircularProgressIndicator(
//                       color: Colors.red,
//                     ),
//                   );
//                 }
//               }));
//     });
//   }
// }

import 'package:grouped_list/grouped_list.dart';
import 'package:provider/provider.dart';

class MessagesListWidget extends StatefulWidget {
  final ChatArgument? chatArgument;

  const MessagesListWidget({Key? key, this.chatArgument}) : super(key: key);

  @override
  State<MessagesListWidget> createState() => _MessagesListWidgetState();
}

class _MessagesListWidgetState extends State<MessagesListWidget> {
  final ScrollController? _scrollController = ScrollController();

  @override
  Widget build(BuildContext context) {
    return Consumer<ChatController>(builder: (context, chatController, child) {
      return Flexible(
        child: StreamBuilder<QuerySnapshot>(
          stream: chatController.getChatMessage(chatController.groupChatId),
          builder:
              (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
            if (snapshot.hasData) {
              chatController.listMessages = snapshot.data!.docs;
              chatController.listMessages = snapshot.data!.docs;

              // Calculate the total height of all messages to scroll to the end
              // double totalHeight = 0.0;
              // for (var message in chatController.listMessages) {
              //   totalHeight += 100;
              // }
              //
              // // Set the initial scroll offset to show the last messages
              // _scrollController!.jumpTo(totalHeight);
              if (chatController.listMessages.isNotEmpty) {
                return GroupedListView<DocumentSnapshot, String>(
                  elements: chatController.listMessages,
                  floatingHeader: true,

                  sort: true,
                  useStickyGroupSeparators: true, // optional
                  groupBy: (message) {
                    return int.parse(message['timestamp']).formattedTimestamp();
                  },
                  itemComparator: (item1, item2) => item1['timestamp']
                      .compareTo(item2['timestamp']), // optional
                  order: GroupedListOrder.DESC, // optional
                  reverse: true,
                  addAutomaticKeepAlives: true,
                  groupSeparatorBuilder: (element) => Padding(
                    padding: 100.paddingHorizontal,
                    child: Container(
                      padding: 10.paddingAll,
                      margin: 10.marginAll,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.all(Radius.circular(
                                  20.0) //                 <--- border radius here
                              ),
                          shape: BoxShape.rectangle,
                          color: Colors.deepOrange.withOpacity(0.8)),
                      child: Text("$element",
                          textAlign: TextAlign.center,
                          style: TextStyle(color: Colors.white, fontSize: 12)),
                    ),
                  ),
                  // groupSeparatorBuilder: (value) => Container(
                  //   padding: 10.paddingAll,
                  //   margin: 10.marginTop,
                  //   decoration: BoxDecoration(
                  //       borderRadius: BorderRadius.all(Radius.circular(
                  //               20.0) //                 <--- border radius here
                  //           ),
                  //       shape: BoxShape.rectangle,
                  //       color: Colors.deepOrange.withOpacity(0.8)),
                  //   child:
                  //       Text("$value", style: TextStyle(color: Colors.white)),
                  // ),
                  indexedItemBuilder: (context, message, index) {
                    return MessageBubbleWidget(
                      index: index,
                      documentSnapshot: message,
                      chatArgument: widget.chatArgument,
                    );
                  },
                );
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
          },
        ),
      );
    });
  }
}
