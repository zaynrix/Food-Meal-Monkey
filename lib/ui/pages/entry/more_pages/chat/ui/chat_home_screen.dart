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
    );
  }
}
