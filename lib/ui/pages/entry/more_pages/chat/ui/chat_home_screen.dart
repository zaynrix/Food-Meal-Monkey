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
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            } else if (snapshot.hasError) {
              return const Center(
                child: Text('Error fetching data'),
              );
            } else if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
              return const Center(
                child: Text('No user found...'),
              );
            } else {
              return ListView.separated(
                shrinkWrap: true,
                padding: EdgeInsets.zero,
                itemCount: snapshot.data!.docs.length,
                itemBuilder: (context, index) {
                  DocumentSnapshot chatData = snapshot.data!.docs[index];
                  return FutureBuilder<Map<String, dynamic>?>(
                    future: chatController.getLastMessageForUserChats(
                      chatData.id,
                      authController.auth.currentUser!.uid,
                    ),
                    builder: (context, messageSnapshot) {
                      Map<String, dynamic>? lastMessageData =
                          messageSnapshot.data;
                      print("this data shor $lastMessageData");
                      if (lastMessageData != null) {
                        dynamic messageType = chatController
                            .extractLastMessage(messageSnapshot.data!);
                        String messageText = lastMessageData['text'] as String;
                        String messageTime =
                            lastMessageData['timestamp'] as String;
                        bool isSeen = lastMessageData['seenByReceiver'];
                        bool seenByReceiver = lastMessageData['seenByReceiver'];
                        String idTo = lastMessageData['idTo'];

                        return ChatItem(chatData, messageText, messageType,
                            isSeen, messageTime.formattedTime(), idTo);
                      } else {
                        return ChatItem(chatData, "No messages yet",
                            "No messages yet", false, "", "");
                      }
                    },
                  );
                },
                separatorBuilder: (BuildContext context, int index) =>
                    const Divider(
                  thickness: 0,
                  color: Colors.transparent,
                ),
              );
            }
          },
        ),
      ),
    );
  }
// );
// }
}
