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
  void dispose() {
    super.dispose();
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
                  // Subscribe to the chat controller's stream
                  chatController
                      .getLastMessageForUserChatsStream(
                        ChatUser.fromDocument(chatData).id,
                        authController.auth.currentUser!.uid,
                      )
                      .listen((messageData) {});
                  return Visibility(
                      visible:
                          chatData.id != authController.auth.currentUser!.uid,
                      child: StreamBuilder<Map<String, dynamic>?>(
                          stream:
                              chatController.lastMessageStreamController.stream,
                          builder: (context, messageSnapshot) {
                            if (messageSnapshot.connectionState ==
                                ConnectionState.waiting) {
                              return CircularProgressIndicator();
                            } else if (messageSnapshot.hasError) {
                              return Text('Error fetching data');
                            } else if (messageSnapshot.data != null) {
                              Map<String, dynamic>? lastMessageData =
                                  messageSnapshot.data;
                              if (lastMessageData != null) {
                                ChatUser userChat =
                                    ChatUser.fromDocument(chatData);
                                ChatItemModel chatItemModel =
                                    ChatItemModel.fromSnapshot(
                                  lastMessageData,
                                  chatData,
                                  chatController
                                      .extractLastMessage(lastMessageData),
                                );
                                return TextButton(
                                  onPressed: () {
                                    if (KeyboardUtils.isKeyboardShowing()) {
                                      KeyboardUtils.closeKeyboard(context);
                                    }
                                    ChatArgument chatArgument = ChatArgument(
                                      peerId: userChat.id,
                                      peerAvatar: userChat.photoUrl,
                                      peerNickname: userChat.displayName,
                                      userAvatar: authController
                                              .auth.currentUser!.photoURL ??
                                          "",
                                    );
                                    chatController.setIdTo(chatItemModel.idTo!);
                                    ServiceNavigation.serviceNavi
                                        .pushNamedWidget(
                                      RouteGenerator.chatPage,
                                      args: chatArgument,
                                    );
                                  },
                                  child: ListTile(
                                    subtitle: Row(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        if (chatItemModel.lastMessageType ==
                                            "Text")
                                          const Icon(Icons.text_fields),
                                        // Change this icon as needed
                                        if (chatItemModel.lastMessageType ==
                                            "Image")
                                          const Icon(Icons.image),
                                        // Change this icon as needed
                                        if (chatItemModel.lastMessageType ==
                                            "Sticker")
                                          const Icon(Icons.star),
                                        // Change this icon as needed
                                        if (chatItemModel.lastMessageType ==
                                            "Audio")
                                          const Icon(Icons.music_video_sharp),
                                        // Change this icon as needed
                                        const SizedBox(width: 8),
                                        Expanded(
                                          child: Text(
                                            chatItemModel.lastMessage!,
                                            maxLines: 1,
                                            overflow: TextOverflow.ellipsis,
                                          ),
                                        ),
                                      ],
                                    ),
                                    leading: userChat.photoUrl.isNotEmpty
                                        ? ClipOval(
                                            child: CachedNetworkImage(
                                              imageUrl: userChat.photoUrl,
                                              imageBuilder:
                                                  (context, imageProvider) =>
                                                      Container(
                                                width: 50,
                                                height: 50,
                                                decoration: BoxDecoration(
                                                  shape: BoxShape.circle,
                                                  image: DecorationImage(
                                                    image: imageProvider,
                                                    fit: BoxFit.cover,
                                                  ),
                                                ),
                                              ),
                                              placeholder: (context, url) =>
                                                  SizedBox(
                                                width: 50,
                                                height: 50,
                                                child:
                                                    CircularProgressIndicator(
                                                  color: Colors.grey,
                                                ),
                                              ),
                                              errorWidget:
                                                  (context, url, error) =>
                                                      const Icon(
                                                Icons.account_circle,
                                                size: 50,
                                              ),
                                            ),
                                          )
                                        : Image.asset(
                                            ImageAssets.app_icon,
                                            width: 50,
                                            height: 50,
                                          ),
                                    title: Text(
                                      "${userChat.displayName}",
                                      style:
                                          const TextStyle(color: Colors.black),
                                    ),
                                    trailing: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.end,
                                      children: [
                                        Expanded(
                                          child: Text(
                                            "${chatItemModel.messageTime}",
                                            style: const TextStyle(
                                                color: Colors.grey,
                                                fontSize: 12),
                                          ),
                                        ),
                                        Visibility(
                                          visible: chatItemModel.isSeen!,
                                          child: Icon(
                                            Icons.circle,
                                            size: 10,
                                            // This is an example icon, replace with your preferred indicator
                                            color: Colors
                                                .deepOrange, // This is an example color, adjust as needed
                                          ),
                                        ),
                                        chatItemModel.seenByReceiver!
                                            ? Icon(
                                                Icons.done_all,
                                                // This is an example icon, replace with your preferred indicator
                                                color: Colors
                                                    .blue, // This is an example color, adjust as needed
                                              )
                                            : Visibility(
                                                visible:
                                                    chatItemModel.messageTime !=
                                                        "",
                                                child: Icon(
                                                  Icons.done,
                                                  // This is an example icon, replace with your preferred indicator
                                                  color: Colors
                                                      .grey, // This is an example color, adjust as needed
                                                ),
                                              ),
                                      ],
                                    ),
                                  ),
                                  // child: ListTile(
                                  //   title: Text("Content ${chatItemModel.lastMessage}"),
                                  // ),
                                );
                              } else {
                                return Text("I DONT KNOW WHY");
                              }
                            } else {
                              return Text("NOOOOooo");
                            }
                            // child:
                          }));
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
          },
        ),
      ),
    );
  }
}
