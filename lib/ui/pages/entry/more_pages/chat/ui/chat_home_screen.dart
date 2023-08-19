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
        // leading: IconButton(
        //   onPressed: () {
        //     ServiceNavigation.serviceNavi.back();
        //     // Your navigation logic
        //   },
        //   icon: const Icon(Icons.arrow_back_ios_new_outlined),
        // ),
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
                  return FutureBuilder<dynamic>(
                    future: chatController.getLastMessageForUserChats(
                      chatData.id,
                      authController.auth.currentUser!.uid,
                    ),
                    builder: (context, messageSnapshot) {
                      String lastMessage =
                          messageSnapshot.data ?? "No messages yet";
                      return ChatItem(chatData, lastMessage, lastMessage);
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
