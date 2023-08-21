import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:food_delivery_app/core/controllers/auth_controller/auth_controller.dart';
import 'package:food_delivery_app/resources/styles.dart';
import 'package:food_delivery_app/ui/pages/entry/more_pages/chat/chat_controllers/chat_controller.dart';
import 'package:food_delivery_app/ui/pages/entry/more_pages/chat/models/chat_messages.dart';
import 'package:food_delivery_app/ui/pages/entry/more_pages/chat/ui/chat_screen.dart';
import 'package:food_delivery_app/ui/pages/entry/more_pages/chat/widgets/message_card.dart';
import 'package:food_delivery_app/ui/pages/entry/more_pages/chat/widgets/message_card_image.dart';
import 'package:food_delivery_app/ui/pages/entry/more_pages/chat/widgets/message_voice.dart';
import 'package:food_delivery_app/utils/extension/responsive_extension.dart';
import 'package:food_delivery_app/utils/extension/time_extension.dart';
import 'package:provider/provider.dart';

class MessageBubbleWidget extends StatefulWidget {
  final int? index;
  final DocumentSnapshot? documentSnapshot;
  final ChatArgument? chatArgument;

  const MessageBubbleWidget(
      {Key? key, this.chatArgument, this.documentSnapshot, this.index})
      : super(key: key);

  @override
  State<MessageBubbleWidget> createState() => _MessageBubbleWidgetState();
}

class _MessageBubbleWidgetState extends State<MessageBubbleWidget> {
  User? userData;

  @override
  void initState() {
    userData =
        Provider.of<AuthController>(context, listen: false).auth.currentUser;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    if (widget.documentSnapshot != null) {
      ChatMessages chatMessages =
          ChatMessages.fromDocument(widget.documentSnapshot!);
      if (chatMessages.idFrom == userData!.uid) {
        return _buildRightMessage(chatMessages);
      } else {
        return _buildLeftMessage(chatMessages);
      }
    } else {
      return const SizedBox.shrink();
    }
  }

  Widget _buildRightMessage(ChatMessages chatMessages) {
    return Consumer<ChatController>(
      builder: (context, chatController, child) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                chatMessages.type == MessageType.audio
                    ? VoiceMessageWidget(
                        timeStamp: chatMessages.timestamp.formattedTime(),
                        isSender: true,
                        audioSrc: '${chatMessages.content}',
                      )
                    : SizedBox.shrink(),
                chatMessages.type == MessageType.text
                    ? Row(
                        children: [
                          messageBubbleText(
                            isSender: true,
                            timeStamp: chatMessages.timestamp.formattedTime(),
                            chatContent: chatMessages.content,
                            color: Colors.red,
                            textColor: Colors.white,
                            margin: 10.marginRight,
                          ),
                        ],
                      )
                    : chatMessages.type == MessageType.image
                        ? Container(
                            margin: EdgeInsets.only(right: 10, top: 10),
                            child: chatImage(
                                timeStamp:
                                    chatMessages.timestamp.formattedTime(),
                                context: context,
                                imageSrc: chatMessages.content,
                                onTap: () {
                                  print(
                                      "This is the image ${chatMessages.content}");
                                }),
                          )
                        : const SizedBox.shrink(),
                chatController.isMessageSent(widget.index!)
                    ? Container(
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          border: Border.all(
                            color: Colors.red,
                            width: 2.0,
                          ),
                        ),
                        child: ClipOval(
                          child: CachedNetworkImage(
                            imageUrl: widget.chatArgument!.userAvatar,
                            width: 40,
                            height: 40,
                            fit: BoxFit.cover,
                            progressIndicatorBuilder: (BuildContext context,
                                String url, DownloadProgress progress) {
                              return Center(
                                child: CircularProgressIndicator(
                                  color: Colors.red,
                                  value: progress.progress,
                                ),
                              );
                            },
                            errorWidget: (BuildContext context, String url,
                                dynamic error) {
                              return Image.asset(ImageAssets.app_icon);
                            },
                          ),
                        ),
                      )
                    : Container(
                        width: 35,
                      ),
              ],
            ),
          ],
        );
      },
    );
  }

  Widget _buildLeftMessage(ChatMessages chatMessages) {
    return Consumer<ChatController>(
      builder: (context, chatController, child) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                chatController.isMessageReceived(widget.index!)

                    // left side (received message)
                    ? Container(
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          border: Border.all(
                            color: orangeColor,
                            width: 2.0,
                          ),
                        ),
                        child: ClipOval(
                          child: CachedNetworkImage(
                            imageUrl: widget.chatArgument!.peerAvatar,
                            width: 40,
                            height: 40,
                            fit: BoxFit.cover,
                            progressIndicatorBuilder: (BuildContext context,
                                String url, DownloadProgress progress) {
                              return Center(
                                child: CircularProgressIndicator(
                                  color: Colors.deepOrange,
                                  value: progress.progress,
                                ),
                              );
                            },
                            errorWidget: (BuildContext context, String url,
                                dynamic error) {
                              return Image.asset(ImageAssets.app_icon);
                            },
                          ),
                        ),
                      )
                    : Container(
                        width: 35,
                      ),
                chatMessages.type == MessageType.audio
                    ? VoiceMessageWidget(
                        timeStamp: chatMessages.timestamp.formattedTime(),
                        isSender: false,
                        audioSrc: '${chatMessages.content}',
                      )
                    : SizedBox.shrink(),
                chatMessages.type == MessageType.text
                    ? messageBubbleText(
                        isSender: false,
                        timeStamp: chatMessages.timestamp.formattedTime(),
                        color: Colors.deepOrange,
                        textColor: Colors.white,
                        chatContent: chatMessages.content,
                        margin: EdgeInsets.only(left: 10),
                      )
                    : chatMessages.type == MessageType.image
                        ? Container(
                            margin: const EdgeInsets.only(left: 10, top: 10),
                            child: chatImage(
                                timeStamp:
                                    chatMessages.timestamp.formattedTime(),
                                context: context,
                                imageSrc: chatMessages.content,
                                onTap: () {
                                  print(
                                      "This is the image ${chatMessages.content}");
                                }),
                          )
                        : const SizedBox.shrink(),
              ],
            ),
          ],
        );
      },
    );
  }
}
