part of pages;
//
// class InboxPage extends StatelessWidget {
//   InboxPage({Key? key}) : super(key: key);
//
//   final List<InboxModel> inboxes = InboxModel.inboxes;
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text("Inbox"),
//         leading: IconButton(
//           onPressed: () {
//             ServiceNavigation.serviceNavi.back();
//           },
//           icon: const Icon(Icons.arrow_back_ios_new_outlined),
//         ),
//         actions: [
//           IconButton(onPressed: () {}, icon: const Icon(Icons.shopping_cart)),
//         ],
//       ),
//       body: StreamBuilder<QuerySnapshot>(
//         stream: FirebaseFirestore.instance.collection('chats').snapshots(),
//         builder: (context, snapshot) {
//           if (snapshot.hasError) {
//             return Text('Error: ${snapshot.error}');
//           }
//
//           if (!snapshot.hasData) {
//             return CircularProgressIndicator();
//           }
//
//           final chatDocs = snapshot.data!.docs;
//
//           return ListView.builder(
//             itemCount: chatDocs.length,
//             itemBuilder: (context, index) {
//               final chatDoc = chatDocs[index];
//               return ChatTile(chatDoc: chatDoc);
//             },
//           );
//         },
//       ),
//     );
//   }
// }
//
// class ChatTile extends StatelessWidget {
//   final DocumentSnapshot chatDoc;
//
//   ChatTile({required this.chatDoc});
//
//   @override
//   Widget build(BuildContext context) {
//     // Extract chat data, participants, etc. from chatDoc
//
//     return StreamBuilder<QuerySnapshot>(
//       stream: chatDoc.reference
//           .collection('messages')
//           .orderBy('timestamp')
//           .snapshots(),
//       builder: (context, snapshot) {
//         if (snapshot.hasError) {
//           return Text('Error: ${snapshot.error}');
//         }
//
//         if (!snapshot.hasData) {
//           return CircularProgressIndicator();
//         }
//         final chatData = chatDoc.data() as Map<String, dynamic>;
//         final participants = chatData['participants'] as List<dynamic>;
//         final messageData =
//             snapshot.data!.docs.first.data() as Map<String, dynamic>;
//         final lastMessage = messageData['content'] as String;
//
//         final messageDocs = snapshot.data!.docs;
//
//         return Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             Row(
//               children: [
//                 const CustomCircleAvatar(),
//                 hSpace5,
//                 Text(
//                   lastMessage,
//                   // style: textTheme.headline5,
//                 ),
//                 const Spacer(),
//                 Text("date"),
//               ],
//             ),
//             vSpace15,
//             Row(
//               children: [
//                 hSpace14,
//                 Text(
//                   "supTitle",
//                   // style: textTheme.subtitle2,
//                 ),
//               ],
//             ),
//             Align(
//               alignment: Alignment.centerRight,
//               child: IconButton(
//                 onPressed: () {},
//                 icon: const Icon(
//                   Icons.star_border,
//                   color: orangeColor,
//                 ),
//               ),
//             )
//           ],
//         );
//       },
//     );
//   }
// }
// // SingleChildScrollView(
// //     child:
// // ListView.builder(
// //   itemCount: inboxes.length,
// //   shrinkWrap: true,
// //   physics: const NeverScrollableScrollPhysics(),
// //   itemBuilder: (context , index) {
// //     final inbox = inboxes[index];
// //     return InboxTile(title: inbox.title, supTitle: inbox.content, date: inbox.date, isRead: inbox.isRead);
// //   },
// //
// // ),
// //       ),
// //     );
// //   }
// // }

class InboxPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Inbox"),
        leading: IconButton(
          onPressed: () {
            ServiceNavigation.serviceNavi.back();
            // Your navigation logic
          },
          icon: const Icon(Icons.arrow_back_ios_new_outlined),
        ),
        actions: [
          IconButton(onPressed: () {}, icon: const Icon(Icons.shopping_cart)),
        ],
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance.collection('chats').snapshots(),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return Text('Error: ${snapshot.error}');
          }

          if (!snapshot.hasData) {
            return CircularProgressIndicator();
          }

          final chatDocs = snapshot.data!.docs;

          return ListView.builder(
            itemCount: chatDocs.length,
            itemBuilder: (context, index) {
              final chatDoc = chatDocs[index];
              return InboxTile(chatDoc: chatDoc);
            },
          );
        },
      ),
    );
  }
}

class ChatTile extends StatelessWidget {
  final DocumentSnapshot chatDoc;

  ChatTile({required this.chatDoc});

  @override
  Widget build(BuildContext context) {
    // Extract chat data, participants, etc. from chatDoc
    final chatData = chatDoc.data() as Map<String, dynamic>;
    final participants = chatData['participants'] as List<dynamic>;

    return ListTile(
      title: Text('Chat with ${participants.join(', ')}'),
      subtitle: StreamBuilder<QuerySnapshot>(
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

          final messageData =
              snapshot.data!.docs.first.data() as Map<String, dynamic>;
          final lastMessage = messageData['content'] as String;

          return Text(lastMessage);
        },
      ),
      onTap: () {
        // Navigator.push(
        //   context,
        //   MaterialPageRoute(
        //     builder: (context) => ChatScreen(chatDoc: chatDoc),
        //   ),
        // );
      },
    );
  }
}
