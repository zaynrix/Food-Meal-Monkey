part of pages;

//PR
class ChatItemWidget extends StatelessWidget {
  final ChatUser userChat;
  final DocumentSnapshot chatData;
  final ChatItemModel chatItemModel;
  final AuthController authController;
  final ChatController chatController;

  ChatItemWidget({
    required this.userChat,
    required this.chatData,
    required this.chatItemModel,
    required this.authController,
    required this.chatController,
  });

  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: () {
        if (KeyboardUtils.isKeyboardShowing()) {
          KeyboardUtils.closeKeyboard(context);
        }
        ChatArgument chatArgument = ChatArgument(
          peerId: userChat.id,
          peerAvatar: userChat.photoUrl,
          peerNickname: userChat.displayName,
          userAvatar: authController.auth.currentUser!.photoURL ?? "",
        );
        chatController.setIdTo(chatItemModel.idTo!);
        ServiceNavigation.serviceNavi.pushNamedWidget(
          RouteGenerator.chatPage,
          args: chatArgument,
        );
      },
      child: ListTile(
        subtitle: _buildSubtitle(),
        leading: _buildLeading(),
        title: Text(
          "${userChat.displayName}",
          style: const TextStyle(color: Colors.black),
        ),
        trailing: _buildTrailing(),
      ),
    );
  }

  Widget _buildSubtitle() {
    final messageType = chatItemModel.lastMessageType;
    String messageText = "";

    if (messageType == "Text") {
      messageText = chatItemModel.lastMessage!;
    } else {
      messageText = chatItemModel.lastMessageType!; // Use the extracted message
    }

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        if (messageType != "Text") _getMessageIcon(messageType),
        Expanded(
          child: Text(
            "$messageText",
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ),
        const SizedBox(width: 8),
      ],
    );
  }

  Widget _getMessageIcon(String messageType) {
    switch (messageType) {
      case "Text":
      // return Icons.text_fields;
      case "Image":
        return Icon(Icons.image);
      case "Sticker":
        return Icon(Icons.star);

      case "Audio":
        return Icon(Icons.music_video_sharp);

      default:
        return Text(""); // Default to text icon
    }
  }

  Widget _buildLeading() {
    return userChat.photoUrl.isNotEmpty
        ? ClipOval(
            child: CachedNetworkImage(
              imageUrl: userChat.photoUrl,
              imageBuilder: (context, imageProvider) => Container(
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
              placeholder: (context, url) => SizedBox(
                width: 50,
                height: 50,
                child: CircularProgressIndicator(
                  color: Colors.grey,
                ),
              ),
              errorWidget: (context, url, error) => const Icon(
                Icons.account_circle,
                size: 50,
              ),
            ),
          )
        : Image.asset(
            ImageAssets.app_icon,
            width: 50,
            height: 50,
          );
  }

  Widget _buildTrailing() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        Expanded(
          child: Text(
            "${chatItemModel.messageTime}",
            style: const TextStyle(color: Colors.grey, fontSize: 12),
          ),
        ),
        Visibility(
          visible: chatItemModel.isSeen!,
          child: Icon(
            Icons.circle,
            size: 10,
            color: Colors.deepOrange,
          ),
        ),
        chatItemModel.seenByReceiver!
            ? Icon(
                Icons.done_all,
                color: Colors.blue,
              )
            : Visibility(
                visible: chatItemModel.messageTime != "",
                child: Icon(
                  Icons.done,
                  color: Colors.grey,
                ),
              ),
      ],
    );
  }
}
