part of pages;

class InboxPage extends StatefulWidget {
  @override
  State<InboxPage> createState() => _InboxPageState();
}

class _InboxPageState extends State<InboxPage> {
  @override
  void initState() {
    _closeMessageControllers();
    super.initState();
  }

  void _closeMessageControllers() {
    final chatController = Provider.of<ChatController>(context, listen: false);
    for (final controller in chatController.messageStreamControllers.values) {
      controller.close();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Inbox"),
        actions: [
          IconButton(
            onPressed: _handleShoppingCart,
            icon: const Icon(Icons.shopping_cart),
          ),
        ],
      ),
      body: _buildChatList(),
    );
  }

  ///TODO : Cart
  void _handleShoppingCart() {
    // logic here
  }

  Widget _buildChatList() {
    return Consumer2<ChatController, AuthController>(
      builder: (context, chatController, authController, child) {
        return StreamBuilder<QuerySnapshot>(
          stream: chatController
              .getFirestoreData(FirestoreConstants.pathUserCollection),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return _buildLoadingIndicator();
            } else if (snapshot.hasError) {
              return _buildErrorText('Error fetching data');
            } else if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
              return _buildNoUserFoundText();
            } else {
              return _buildChatListView(
                snapshot.data!.docs,
                chatController,
                authController,
              );
            }
          },
        );
      },
    );
  }

  Widget _buildLoadingIndicator() {
    return Center(
      child: CircularProgressIndicator(),
    );
  }

  Widget _buildErrorText(String message) {
    return Center(
      child: Text(message),
    );
  }

  Widget _buildNoUserFoundText() {
    return Center(
      child: Text('No user found...'),
    );
  }

  Widget _buildChatListView(
    List<QueryDocumentSnapshot> chatDocs,
    ChatController chatController,
    AuthController authController,
  ) {
    return ListView.separated(
      shrinkWrap: true,
      padding: EdgeInsets.zero,
      itemCount: chatDocs.length,
      itemBuilder: (context, index) {
        final chatData = chatDocs[index];
        final userChat = ChatUser.fromDocument(chatData);

        chatController
            .getLastMessageForUserChatsStream(
              ChatUser.fromDocument(chatData).id,
              authController.auth.currentUser!.uid,
            )
            .listen((messageData) {});

        return Visibility(
          visible: chatData.id != authController.auth.currentUser!.uid,
          child: StreamBuilder<Map<String, dynamic>?>(
            stream:
                chatController.messageStreamControllers[userChat.id]?.stream,
            builder: (context, messageSnapshot) {
              Map<String, dynamic>? lastMessageData = messageSnapshot.data;
              if (lastMessageData == null) {
                return ChatItemWidget(
                  userChat: userChat,
                  chatData: chatData,
                  chatItemModel: ChatItemModel.noMessages(
                    chatData,
                  ),
                  authController: authController,
                  chatController: chatController,
                );
              } else {
                return ChatItemWidget(
                  userChat: userChat,
                  chatData: chatData,
                  chatItemModel: ChatItemModel.fromSnapshot(
                    lastMessageData,
                    chatData,
                    chatController.extractLastMessage(lastMessageData),
                  ),
                  authController: authController,
                  chatController: chatController,
                );
              }
            },
          ),
        );
      },
      separatorBuilder: (BuildContext context, int index) => Padding(
        padding: const EdgeInsets.only(left: 100, right: 20),
        child: Divider(
          height: 0,
          thickness: 0,
        ),
      ),
    );
  }
}
