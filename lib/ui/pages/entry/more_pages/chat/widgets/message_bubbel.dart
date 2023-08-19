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
import 'package:food_delivery_app/utils/extension/responsive_extension.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:voice_message_package/voice_message_package.dart';

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
    // TODO: implement initState
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
        // right side (my message)
        return Consumer<ChatController>(
          builder: (context, chatController, child) {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    chatMessages.type == MessageType.audio
                        ? ClipRRect(
                            borderRadius: BorderRadius.circular(
                                30), // Adjust the value as needed
                            child: Material(
                              shadowColor: Colors
                                  .grey, // Set the desideepOrange shadow color

                              elevation: 5,
                              child: VoiceMessage(
                                contactCircleColor: Colors.white,
                                mePlayIconColor: Colors.white,
                                contactPlayIconBgColor: Colors.white,
                                contactFgColor: Colors.white,
                                contactPlayIconColor: Colors.black,
                                meFgColor: Colors.white,
                                contactBgColor: Colors.red,
                                formatDuration: (Duration duration) {
                                  return duration.toString().substring(0, 4);
                                },
                                meBgColor: Colors.white,
                                audioSrc: '${chatMessages.content}',
                                played: false,
                                me: false,
                                noiseCount: 1,
                                onPlay: () {
                                  chatController
                                      .loadFile('${chatMessages.content}');
                                }, // Do something when voice played.
                              ),
                            ),
                          )
                        : SizedBox.shrink(),
                    chatMessages.type == MessageType.text
                        ? Row(
                            children: [
                              messageBubbleText(
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
                chatController.isMessageSent(widget.index!)
                    ? Container(
                        margin: EdgeInsets.only(right: 50, top: 6, bottom: 8),
                        child: Text(
                          DateFormat('dd MMM yyyy, hh:mm a').format(
                            DateTime.fromMillisecondsSinceEpoch(
                              int.parse(chatMessages.timestamp),
                            ),
                          ),
                          style: const TextStyle(
                              color: Colors.grey,
                              fontSize: 12,
                              fontStyle: FontStyle.italic),
                        ),
                      )
                    : const SizedBox.shrink(),
              ],
            );
          },
        );
      } else {
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
                                imageUrl: widget.chatArgument!.userAvatar,
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
                        ? ClipRRect(
                            borderRadius: BorderRadius.circular(
                                30), // Adjust the value as needed
                            child: Material(
                                shadowColor: Colors
                                    .grey, // Set the desideepOrange shadow color

                                elevation: 5,
                                child: VoiceMessage(
                                  meBgColor: Colors.deepOrange,
                                  audioSrc: '${chatMessages.content}',
                                  played: true,
                                  formatDuration: (Duration duration) {
                                    return duration.toString().substring(0, 4);
                                  },
                                  me: true,
                                  noiseCount: 1,
                                  // Set message side.
                                  onPlay: () {
                                    chatController
                                        .loadFile('${chatMessages.content}');
                                  }, // Do something when voice played.
                                )),
                          )
                        : SizedBox.shrink(),
                    chatMessages.type == MessageType.text
                        ? messageBubbleText(
                            color: Colors.deepOrange,
                            textColor: Colors.white,
                            chatContent: chatMessages.content,
                            margin: EdgeInsets.only(left: 10),
                          )
                        : chatMessages.type == MessageType.image
                            ? Container(
                                margin:
                                    const EdgeInsets.only(left: 10, top: 10),
                                child: chatImage(
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
                chatController.isMessageReceived(widget.index!)
                    ? Container(
                        margin:
                            const EdgeInsets.only(left: 50, top: 6, bottom: 8),
                        child: Text(
                          DateFormat('dd MMM yyyy, hh:mm a').format(
                            DateTime.fromMillisecondsSinceEpoch(
                              int.parse(chatMessages.timestamp),
                            ),
                          ),
                          style: const TextStyle(
                              color: Colors.blueGrey,
                              fontSize: 12,
                              fontStyle: FontStyle.italic),
                        ),
                      )
                    : const SizedBox.shrink(),
              ],
            );
          },
        );
      }
    } else {
      return const SizedBox.shrink();
    }
  }
}
