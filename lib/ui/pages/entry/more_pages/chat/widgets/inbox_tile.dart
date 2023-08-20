import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:food_delivery_app/core/controllers/auth_controller/auth_controller.dart';
import 'package:food_delivery_app/resources/styles.dart';
import 'package:food_delivery_app/routing/navigations.dart';
import 'package:food_delivery_app/routing/router.dart';
import 'package:food_delivery_app/ui/pages/entry/more_pages/chat/chat_controllers/chat_controller.dart';
import 'package:food_delivery_app/ui/pages/entry/more_pages/chat/models/chat_user.dart';
import 'package:food_delivery_app/ui/pages/entry/more_pages/chat/ui/chat_screen.dart';
import 'package:food_delivery_app/utils/keyboard_utils.dart';
import 'package:provider/provider.dart';

class ChatItem extends StatefulWidget {
  final DocumentSnapshot? documentSnapshot;
  final String? lastMesage;
  final String lastMessageType; // Add this parameter

  const ChatItem(this.documentSnapshot, this.lastMesage, this.lastMessageType)
      : super();

  @override
  State<ChatItem> createState() => _ChatItemState();
}

class _ChatItemState extends State<ChatItem> {
  User? authUser;
  ChatController? chatController;

  @override
  void initState() {
    super.initState();
    authUser =
        Provider.of<AuthController>(context, listen: false).auth.currentUser;
    chatController = Provider.of<ChatController>(context, listen: false);
    ;
  }

  @override
  void didChangeDependencies() {
    // chatController?.getChatMessage(authUser.uid - widget.)
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    if (widget.documentSnapshot != null) {
      ChatUser userChat = ChatUser.fromDocument(widget.documentSnapshot!);
      if (userChat.id == authUser!.uid) {
        return Visibility(
            visible: userChat.id == authUser!.uid, child: SizedBox());
      } else {
        return TextButton(
          onPressed: () {
            if (KeyboardUtils.isKeyboardShowing()) {
              KeyboardUtils.closeKeyboard(context);
            }
            ChatArgument chatArgument = ChatArgument(
              peerId: userChat.id,
              peerAvatar: userChat.photoUrl,
              peerNickname: userChat.displayName,
              userAvatar: authUser!.photoURL ?? "",
            );
            ServiceNavigation.serviceNavi
                .pushNamedWidget(RouteGenerator.chatPage, args: chatArgument);
          },
          child: ListTile(
            subtitle: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                if (widget.lastMessageType == "Text")
                  const Icon(Icons.text_fields), // Change this icon as needed
                if (widget.lastMessageType == "Image")
                  const Icon(Icons.image), // Change this icon as needed
                if (widget.lastMessageType == "Sticker")
                  const Icon(Icons.star), // Change this icon as needed
                if (widget.lastMessageType == "Audio")
                  const Icon(
                      Icons.music_video_sharp), // Change this icon as needed
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    "${widget.lastMesage}",
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
                  ),
            title: Text(
              "${userChat.displayName}",
              style: const TextStyle(color: Colors.black),
            ),
            // minVerticalPadding: 0,
            // horizontalTitleGap: 0,
            // contentPadding: EdgeInsets.zero,
          ),
        );
      }
    } else {
      return const Text("");
    }
  }
}
