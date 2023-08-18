part of pages;

class InboxPage extends StatefulWidget {
  @override
  State<InboxPage> createState() => _InboxPageState();
}

class _InboxPageState extends State<InboxPage> {
  @override
  void initState() {
    super.initState();
  }

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
      body: Consumer2<ChatController, AuthController>(
        builder: (context, chatController, authController, child) =>
            StreamBuilder<QuerySnapshot>(
          stream: chatController.getFirestoreData(
            FirestoreConstants.pathUserCollection,
          ),
          builder:
              (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
            if (snapshot.hasData) {
              if ((snapshot.data?.docs.length ?? 0) > 0) {
                return ListView.separated(
                  shrinkWrap: true,
                  itemCount: snapshot.data!.docs.length,
                  itemBuilder: (context, index) => ChatItem(
                    snapshot.data?.docs[index],
                  ),
                  // controller: scrollController,
                  separatorBuilder: (BuildContext context, int index) =>
                      const Divider(),
                );
              } else {
                return const Center(
                  child: Text('No user found...'),
                );
              }
            } else {
              return const Center(
                child: CircularProgressIndicator(),
              );
            }
          },
        ),
      ),
      // StreamBuilder<QuerySnapshot>(
      //   stream: FirebaseFirestore.instance.collection('users').snapshots(),
      //   builder: (context, snapshot) {
      //     if (snapshot.hasError) {
      //       return Text('Error: ${snapshot.error}');
      //     }
      //
      //     if (!snapshot.hasData) {
      //       return CircularProgressIndicator();
      //     }
      //
      //     final userDocs = snapshot.data!.docs;
      //
      //     final currentUserUid =
      //         Provider.of<AuthController>(context, listen: false)
      //             .auth
      //             .currentUser!
      //             .uid;
      //
      //     final filteredUserDocs = userDocs.where((userDoc) {
      //       return userDoc.id != currentUserUid;
      //     }).toList();
      //
      //     return ListView.builder(
      //       itemCount: filteredUserDocs.length,
      //       itemBuilder: (context, index) {
      //         final userDoc = filteredUserDocs[index];
      //         return UserTile(userDoc: userDoc);
      //       },
      //     );
      //   },
      // ),
    );
  }
}

// class UserTile extends StatelessWidget {
//   final DocumentSnapshot userDoc;
//
//   UserTile({required this.userDoc});
//
//   String getChatId(String userId1, String userId2) {
//     if (userId1.hashCode <= userId2.hashCode) {
//       return '$userId1-$userId2';
//     } else {
//       return '$userId2-$userId1';
//     }
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     final userData = userDoc.data() as Map<String, dynamic>;
//     final userName = userData['name'] as String;
//     final imagePath = userData['imagePath'] ?? "";
//
//     return StreamBuilder<QuerySnapshot>(
//       stream: FirebaseFirestore.instance
//           .collection('chats')
//           .doc(getChatId(
//               Provider.of<AuthController>(context, listen: false)
//                   .auth
//                   .currentUser!
//                   .uid,
//               userDoc.id))
//           .collection('messages')
//           .orderBy('timestamp', descending: true)
//           .limit(1)
//           .snapshots(),
//       builder: (context, snapshot) {
//         if (snapshot.hasError) {
//           return ListTile(
//             title: Text(
//               userName,
//               style: TextStyle(color: Colors.blue),
//             ),
//             subtitle: Text('Error loading message'),
//             onTap: () {
//               // Navigator.push(
//               //   context,
//               //   MaterialPageRoute(
//               //     builder: (context) => ChatPage(
//               //
//               //       // userId: Provider.of<AuthController>(context, listen: false)
//               //       //     .auth
//               //       //     .currentUser!
//               //       //     .uid,
//               //       // recipientId: userDoc.id,
//               //       // recipientName: userName,
//               //     ),
//               //   ),
//               // );
//             },
//           );
//         }
//
//         if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
//           return ListTile(
//             leading: CircleAvatar(
//               radius: 30,
//               backgroundColor: Colors.grey,
//               backgroundImage: CachedNetworkImageProvider(
//                 imagePath,
//               ),
//               child: Container(
//                 decoration: BoxDecoration(
//                   shape: BoxShape.circle,
//                   color: Colors.grey,
//                 ),
//                 child: Image.asset(ImageAssets.app_icon),
//               ),
//             ),
//             title: Text(
//               userName,
//               style: TextStyle(color: Colors.black),
//             ),
//             subtitle: Text('No messages'),
//             onTap: () {
//               Navigator.push(
//                 context,
//                 MaterialPageRoute(
//                   builder: (context) => ChatPage(
//                     // imagePath: imagePath,
//                     userId: Provider.of<AuthController>(context, listen: false)
//                         .auth
//                         .currentUser!
//                         .uid,
//                     recipientId: userDoc.id,
//                     recipientName: userName,
//                   ),
//                 ),
//               );
//             },
//           );
//         }
//
//         final messageData =
//             snapshot.data!.docs.first.data() as Map<String, dynamic>;
//         final lastMessage = messageData['text'] as String;
//         final Timestamp timestamp =
//             messageData['timestamp'] as Timestamp? ?? Timestamp.now();
//
//         return ListTile(
//           leading: CircleAvatar(
//             radius: 30,
//             backgroundColor: Colors.grey,
//             backgroundImage: CachedNetworkImageProvider(
//               imagePath,
//             ),
//             child: Container(
//               decoration: BoxDecoration(
//                 shape: BoxShape.circle,
//                 color: Colors.grey,
//               ),
//               child: Image.asset(ImageAssets.app_icon),
//             ),
//           ),
//           title: Text(
//             userName,
//             style: TextStyle(color: Colors.black),
//           ),
//           subtitle: Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               Text(
//                 lastMessage,
//                 maxLines: 1,
//                 style: TextStyle(color: Colors.grey),
//                 overflow: TextOverflow.ellipsis,
//               ),
//             ],
//           ),
//           trailing: Column(
//             mainAxisAlignment: MainAxisAlignment.center,
//             children: [
//               Text(
//                 "${timestamp.toFormattedString()}",
//                 style: TextStyle(color: Colors.grey),
//               ),
//             ],
//           ),
//           onTap: () {
//             Navigator.push(
//               context,
//               MaterialPageRoute(
//                 builder: (context) => ChatPage(
//                   userId: Provider.of<AuthController>(context, listen: false)
//                       .auth
//                       .currentUser!
//                       .uid,
//                   recipientId: userDoc.id,
//                   recipientName: userName,
//                 ),
//               ),
//             );
//           },
//         );
//       },
//     );
//   }
// }
