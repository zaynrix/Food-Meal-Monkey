// import 'dart:async';
//
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:flutter/material.dart';
// import 'package:food_delivery_app/core/controllers/auth_controller/auth_controller.dart';
// import 'package:food_delivery_app/resources/styles.dart';
// import 'package:food_delivery_app/ui/pages/entry/more_pages/chat/chat_controllers/chat_controller.dart';
// import 'package:food_delivery_app/utils/extension/time_extension.dart';
// import 'package:provider/provider.dart';
//
// class ChatPage extends StatefulWidget {
//   final String userId;
//   final String recipientId;
//   final String recipientName;
//
//   ChatPage({
//     this.userId = "",
//     this.recipientId = "",
//     required this.recipientName,
//   });
//
//   @override
//   _ChatPageState createState() => _ChatPageState();
// }
//
// class _ChatPageState extends State<ChatPage> {
//   TextEditingController _messageController = TextEditingController();
//   Timer? _typingTimer; // Declare a Timer variable
//
//   @override
//   void dispose() {
//     _typingTimer
//         ?.cancel(); // Cancel the typing timer when the widget is disposed
//     super.dispose();
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(title: Text(widget.recipientName)),
//       body: Consumer<ChatController>(
//         builder: (context, chatController, child) => Column(
//           children: [
//             Expanded(
//               child: StreamBuilder<QuerySnapshot>(
//                 stream: FirebaseFirestore.instance
//                     .collection('chats')
//                     .doc(getChatId(widget.userId, widget.recipientId))
//                     .collection('messages')
//                     .orderBy('timestamp', descending: true)
//                     .snapshots(),
//                 builder: (context, snapshot) {
//                   if (!snapshot.hasData) {
//                     return Center(child: CircularProgressIndicator());
//                   }
//
//                   final messages = snapshot.data!.docs;
//
//                   return ListView.builder(
//                     reverse: true,
//                     itemCount: messages.length,
//                     itemBuilder: (context, index) {
//                       final message = messages[index];
//                       final isSender = message['senderId'] == widget.userId;
//                       chatController.setMessageSender(message['senderId']);
//                       Timestamp valueTime =
//                           message['timestamp'] ?? Timestamp.now();
//                       return Row(
//                         mainAxisAlignment: !isSender
//                             ? MainAxisAlignment.start
//                             : MainAxisAlignment.end,
//                         children: [
//                           !isSender
//                               ? messages[index] != 0
//                                   ? CircleAvatar(
//                                       backgroundImage:
//                                           AssetImage(ImageAssets.app_icon),
//                                       backgroundColor: Colors.transparent,
//                                     )
//                                   : SizedBox.shrink()
//                               : SizedBox(),
//                           Container(
//                             margin: EdgeInsets.symmetric(
//                                 vertical: 8, horizontal: 16),
//                             alignment: isSender
//                                 ? Alignment.centerRight
//                                 : Alignment.centerLeft,
//                             child: Container(
//                               padding: EdgeInsets.all(12),
//                               decoration: BoxDecoration(
//                                 color: isSender
//                                     ? Colors.deepOrange
//                                     : Colors.grey[300],
//                                 borderRadius: BorderRadius.circular(12),
//                               ),
//                               child: Column(
//                                 crossAxisAlignment: isSender
//                                     ? CrossAxisAlignment.end
//                                     : CrossAxisAlignment.start,
//                                 children: [
//                                   Text(
//                                     message["text"],
//                                     style: TextStyle(
//                                         fontSize: 16,
//                                         color: isSender
//                                             ? Colors.white
//                                             : Colors.black),
//                                     overflow: TextOverflow.visible,
//                                   ),
//                                   SizedBox(height: 4),
//                                   Text(
//                                     valueTime.toFormattedString(),
//                                     style: TextStyle(
//                                         fontSize: 12,
//                                         color: isSender
//                                             ? Colors.white
//                                             : Colors.black),
//                                   ),
//                                 ],
//                               ),
//                             ),
//                           ),
//                         ],
//                       );
//                     },
//                   );
//                 },
//               ),
//             ),
//             _buildTypingIndicator(chatController.senderString),
//             _buildMessageInputField(
//                 chatController.senderString, widget.recipientId),
//           ],
//         ),
//       ),
//     );
//   }
//
//   Widget _buildTypingIndicator(String sender) {
//     return StreamBuilder<DocumentSnapshot>(
//       stream: FirebaseFirestore.instance
//           .collection('chats')
//           .doc(getChatId(widget.recipientId, widget.userId))
//           .snapshots(),
//       builder: (context, snapshot) {
//         if (!snapshot.hasData) {
//           return SizedBox();
//         }
//
//         bool isRecipientTyping = snapshot.data?['userId1_isTyping'] ?? false;
//         bool isSenderTyping = snapshot.data?['userId2_isTyping'] ?? false;
//         print(
//             "This first conditions ${widget.userId != sender && isRecipientTyping}");
//
//         print(
//             "This Seconnd conditions ${widget.userId != sender && isSenderTyping}");
//         if (widget.userId == sender && isSenderTyping) {
//           print(
//               "This Seconnd conditions ${widget.userId != sender && isSenderTyping}");
//
//           return Padding(
//             padding: EdgeInsets.all(8.0),
//             child: Text(
//               'Typing... ',
//               style: TextStyle(color: Colors.red),
//             ),
//           );
//         }
//         if (widget.userId != sender && isRecipientTyping) {
//           print(
//               "This first conditions ${widget.userId != sender && isRecipientTyping}");
//           return Padding(
//             padding: EdgeInsets.all(8.0),
//             child: Text(
//               'Typing... ',
//               style: TextStyle(color: Colors.red),
//             ),
//           );
//         } else {
//           return SizedBox();
//         }
//       },
//     );
//   }
//
//   Widget _buildMessageInputField(String sender, String revicer) {
//     String authID = Provider.of<AuthController>(context, listen: false)
//         .auth
//         .currentUser!
//         .uid;
//     return Container(
//       padding: EdgeInsets.all(8.0),
//       child: Row(
//         children: [
//           Expanded(
//             child: TextField(
//               style:
//                   TextStyle(color: Colors.black, fontWeight: FontWeight.normal),
//               controller: _messageController,
//               onChanged: (value) {
//                 print("This changeting $value");
//                 setState(() {
//                   if (sender == authID) {
//                     _updateTypingStatusReciver(true);
//                   }
//                   if (sender != authID) {
//                     _updateTypingStatusSender(true);
//                   }
//
//                   if (_typingTimer != null && _typingTimer!.isActive) {
//                     _typingTimer!.cancel(); // Cancel the previous timer
//                   }
//
//                   // Set a new timer to update typing status after delay
//                   _typingTimer = Timer(Duration(seconds: 2), () {
//                     _updateTypingStatusSender(false);
//                     _updateTypingStatusReciver(false);
//                   });
//                 });
//               },
//               decoration: InputDecoration(
//                 hintStyle: TextStyle(
//                     color: Colors.grey, fontWeight: FontWeight.normal),
//                 hintText: 'Type your message...',
//               ),
//             ),
//           ),
//           IconButton(
//             icon: Icon(Icons.send),
//             onPressed: () {
//               if (_messageController.text.isNotEmpty) {
//                 _sendMessage(_messageController.text);
//                 _messageController.clear();
//               }
//             },
//           ),
//         ],
//       ),
//     );
//   }
//
//   void _updateTypingStatus(bool typing) {
//     FirebaseFirestore.instance
//         .collection('chats')
//         .doc(getChatId(widget.userId, widget.recipientId))
//         .update({
//       'isTyping': typing,
//     });
//   }
//
//   void _updateTypingStatusSender(bool typing) {
//     FirebaseFirestore.instance
//         .collection('chats')
//         .doc(getChatId(widget.userId, widget.recipientId))
//         .update({
//       'userId2_isTyping': typing,
//     });
//   }
//
//   void _updateTypingStatusReciver(bool typing) {
//     FirebaseFirestore.instance
//         .collection('chats')
//         .doc(getChatId(widget.userId, widget.recipientId))
//         .update({
//       'userId1_isTyping': typing,
//     });
//   }
//
//   void _sendMessage(String messageText) {
//     FirebaseFirestore.instance
//         .collection('chats')
//         .doc(getChatId(widget.userId, widget.recipientId))
//         .collection('messages')
//         .add({
//       'senderId': widget.userId,
//       'text': messageText,
//       'timestamp': FieldValue.serverTimestamp(),
//     });
//
//     // Clear the input field after sending the message
//     _messageController.clear();
//   }
//
//   String getChatId(String userId1, String userId2) {
//     if (userId1.hashCode <= userId2.hashCode) {
//       return '$userId1-$userId2';
//     } else {
//       return '$userId2-$userId1';
//     }
//   }
// }

import 'dart:io';

import 'package:audioplayers/audioplayers.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:food_delivery_app/core/controllers/auth_controller/auth_controller.dart';
import 'package:food_delivery_app/ui/pages/entry/more_pages/chat/chat_controllers/chat_controller.dart';
import 'package:food_delivery_app/ui/pages/entry/more_pages/chat/firestore_constants.dart';
import 'package:food_delivery_app/ui/pages/entry/more_pages/chat/models/chat_messages.dart';
import 'package:food_delivery_app/ui/pages/entry/more_pages/chat/widgets/message_card.dart';
import 'package:food_delivery_app/ui/pages/entry/more_pages/chat/widgets/message_card_image.dart';
import 'package:food_delivery_app/ui/pages/pages.dart';
import 'package:food_delivery_app/utils/extension/responsive_extension.dart';
import 'package:http/http.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';
import 'package:record_mp3/record_mp3.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:voice_message_package/voice_message_package.dart';

// import 'package:voice_message_package/voice_message_package.dart';
class MessageType {
  static const text = 0;
  static const image = 1;
  static const sticker = 2;
  static const audio = 3;
}

class ChatPage extends StatefulWidget {
  final String peerId;
  final String peerAvatar;
  final String peerNickname;
  final String userAvatar;

  const ChatPage(
      {Key? key,
      required this.peerNickname,
      required this.peerAvatar,
      required this.peerId,
      this.userAvatar = ""})
      : super(key: key);

  @override
  State<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  late String currentUserId;

  List<QueryDocumentSnapshot> listMessages = [];

  int _limit = 20;
  final int _limitIncrement = 20;
  String groupChatId = '';

  File? imageFile;
  bool isLoading = false;
  bool isShowSticker = false;
  String imageUrl = '';

  final TextEditingController textEditingController = TextEditingController();
  final ScrollController scrollController = ScrollController();
  final FocusNode focusNode = FocusNode();

  late ChatController chatProvider;
  late AuthController authProvider;

  @override
  void initState() {
    super.initState();
    chatProvider = context.read<ChatController>();
    authProvider = context.read<AuthController>();

    focusNode.addListener(onFocusChanged);
    scrollController.addListener(_scrollListener);
    readLocal();
  }

  _scrollListener() {
    if (scrollController.offset >= scrollController.position.maxScrollExtent &&
        !scrollController.position.outOfRange) {
      setState(() {
        _limit += _limitIncrement;
      });
    }
  }

  void onFocusChanged() {
    if (focusNode.hasFocus) {
      setState(() {
        isShowSticker = false;
      });
    }
  }

  void readLocal() {
    if (authProvider.getFirebaseUserId()?.isNotEmpty == true) {
      currentUserId = authProvider.auth.currentUser!.uid;
      ;
    } else {
      Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(builder: (context) => const LoginPage()),
          (Route<dynamic> route) => false);
    }
    if (currentUserId.compareTo(widget.peerId) > 0) {
      groupChatId = '$currentUserId - ${widget.peerId}';
    } else {
      groupChatId = '${widget.peerId} - $currentUserId';
    }
    chatProvider.updateFirestoreData(FirestoreConstants.pathUserCollection,
        currentUserId, {FirestoreConstants.chattingWith: widget.peerId});
  }

  Future getImage() async {
    ImagePicker imagePicker = ImagePicker();
    XFile? pickedFile;
    pickedFile = await imagePicker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      imageFile = File(pickedFile.path);
      if (imageFile != null) {
        setState(() {
          isLoading = true;
        });
        uploadImageFile();
      }
    }
  }

  // void startRecord() {
  //   setState(() {
  //     isRecording = true;
  //   });
  // }
  //
  // void stopRecord() {
  //   setState(() {
  //     isRecording = false;
  //   });
  // }

  void getSticker() {
    focusNode.unfocus();
    setState(() {
      isShowSticker = !isShowSticker;
    });
  }

  Future<bool> onBackPressed() {
    if (isShowSticker) {
      setState(() {
        isShowSticker = false;
      });
    } else {
      chatProvider.updateFirestoreData(FirestoreConstants.pathUserCollection,
          currentUserId, {FirestoreConstants.chattingWith: null});
    }
    return Future.value(false);
  }

  void _callPhoneNumber(String phoneNumber) async {
    var url = 'tel://$phoneNumber';
    var uri = Uri(host: url);
    if (await launchUrl(uri)) {
      await launchUrl(uri);
    } else {
      throw 'Error Occurred';
    }
  }

  void uploadImageFile() async {
    String fileName = DateTime.now().millisecondsSinceEpoch.toString();
    UploadTask uploadTask = chatProvider.uploadImageFile(imageFile!, fileName);
    try {
      TaskSnapshot snapshot = await uploadTask;
      imageUrl = await snapshot.ref.getDownloadURL();
      setState(() {
        isLoading = false;
        onSendMessage(imageUrl, MessageType.image);
      });
    } on FirebaseException catch (e) {
      setState(() {
        isLoading = false;
      });
      Fluttertoast.showToast(msg: e.message ?? e.toString());
    }
  }

  bool isSending = false;

  void onSendMessage(String content, int type) {
    setState(() {
      isSending = true;
    });
    if (content.trim().isNotEmpty) {
      textEditingController.clear();
      Future.delayed(Duration(seconds: 1), () {
        chatProvider.sendChatMessage(
            content, type, groupChatId, currentUserId, widget.peerId);
        setState(() {
          isSending = false;
        });
      });

      // scrollController.animateTo(0,
      //     duration: const Duration(milliseconds: 300), curve: Curves.easeOut);
    } else {
      Fluttertoast.showToast(
          msg: 'Nothing to send', backgroundColor: Colors.grey);
    }
    // setState(() {
    //   isSending = false;
    // });
  }

  // checking if received message
  bool isMessageReceived(int index) {
    if ((index > 0 &&
            listMessages[index - 1].get(FirestoreConstants.idFrom) ==
                currentUserId) ||
        index == 0) {
      return true;
    } else {
      return false;
    }
  }

  // checking if sent message
  bool isMessageSent(int index) {
    if ((index > 0 &&
            listMessages[index - 1].get(FirestoreConstants.idFrom) !=
                currentUserId) ||
        index == 0) {
      return true;
    } else {
      return false;
    }
  }

  bool isPlayingMsg = false, isRecording = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      //
      appBar: AppBar(
        //
        centerTitle: true,
        title: Text('Chatting with ${widget.peerNickname}'.trim()),
        actions: [
          // Consumer(
          //   builder: (context, HomeNotifier homeNotifier, child) => IconButton(
          //     onPressed: () {
          //       homeNotifier.onJoin(context, "yahya");
          //     },
          //     icon: const Icon(Icons.video_call),
          //   ),
          // ),
          IconButton(
            onPressed: () {},
            icon: const Icon(Icons.phone),
          ),
        ],
      ),
      body: SafeArea(
        bottom: true,
        child: Padding(
          padding: 8.paddingHorizontal,
          child: Column(
            children: [
              buildListMessage(),
              SizedBox(
                height: 10,
              ),
              isSending
                  ? LinearProgressIndicator(
                      backgroundColor: Colors.grey[100],
                      valueColor: AlwaysStoppedAnimation<Color>(Colors.blue),
                    )
                  : SizedBox.shrink(),
              buildMessageInput(),
            ],
          ),
        ),
      ),
    );
  }

  Future _loadFile(String url) async {
    final bytes = await readBytes(Uri(host: url));
    final dir = await getApplicationDocumentsDirectory();
    final file = File('${dir.path}/audio.mp3');

    await file.writeAsBytes(bytes);
    if (await file.exists()) {
      setState(() {
        recordFilePath = file.path;
        isPlayingMsg = true;
        print(isPlayingMsg);
      });
      await play();
      setState(() {
        isPlayingMsg = false;
        print(isPlayingMsg);
      });
    }
  }

  Future<bool> checkPermission() async {
    if (!await Permission.microphone.isGranted) {
      PermissionStatus status = await Permission.microphone.request();
      if (status != PermissionStatus.granted) {
        return false;
      }
    }
    return true;
  }

  // bool isRecording = false;

  void startRecord() async {
    bool hasPermission = await checkPermission();
    if (hasPermission) {
      recordFilePath = await getFilePath();

      RecordMp3.instance.start(recordFilePath!, (type) {
        setState(() {});
      });
    } else {}
    setState(() {});
  }

  void stopRecord() async {
    bool s = RecordMp3.instance.stop();
    if (s) {
      setState(() {
        isSending = true;
      });
      await uploadAudio();

      setState(() {
        isPlayingMsg = false;
      });
    }
  }

  String? recordFilePath;

  Future<void> play() async {
    if (recordFilePath != null && File(recordFilePath!).existsSync()) {
      AudioPlayer audioPlayer = AudioPlayer();
      await audioPlayer.play(
        UrlSource(recordFilePath!),
        // isLocal: true,
      );
    }
  }

  int i = 0;

  Future<String> getFilePath() async {
    Directory storageDirectory = await getApplicationDocumentsDirectory();
    String sdPath = storageDirectory.path + "/record";
    var d = Directory(sdPath);
    if (!d.existsSync()) {
      d.createSync(recursive: true);
    }
    return sdPath + "/test_${i++}.mp3";
  }

  sendAudioMsg(String audioMsg) async {
    if (audioMsg.isNotEmpty) {
      var ref = FirebaseFirestore.instance
          .collection(FirestoreConstants.pathMessageCollection)
          .doc(groupChatId)
          .collection(groupChatId)
          .doc(DateTime.now().millisecondsSinceEpoch.toString());
      await FirebaseFirestore.instance.runTransaction((transaction) async {
        await transaction.set(ref, {
          FirestoreConstants.idFrom: currentUserId,
          FirestoreConstants.idTo: widget.peerId,
          FirestoreConstants.timestamp:
              DateTime.now().millisecondsSinceEpoch.toString(),
          FirestoreConstants.content: audioMsg,
          FirestoreConstants.type: 3,
        });
      }).then((value) {
        setState(() {
          isSending = false;
        });
      });
      scrollController.animateTo(0.0,
          duration: Duration(milliseconds: 100), curve: Curves.bounceInOut);
    } else {
      print("Hello");
    }
  }

  uploadAudio() {
    FirebaseStorage storage = FirebaseStorage.instance;
    Reference ref = storage.ref().child(
        'profilepics/audio${DateTime.now().millisecondsSinceEpoch.toString()}.jpg');
    UploadTask uploadTask = ref.putFile(File(recordFilePath!));
    uploadTask.then((value) async {
      print('##############done#########');
      var audioURL = await value.ref.getDownloadURL();
      String strVal = audioURL.toString();
      await sendAudioMsg(strVal);
    }).catchError((e) {
      print(e);
    });
  }

  Widget buildMessageInput() {
    return SizedBox(
      width: double.infinity,
      height: 50,
      child: Row(
        children: [
          //   Padding(
          //   padding: EdgeInsets.only(
          //   top: 8,
          //       left: ((widget.peerId == currentUserId) ? 64 : 10),
          //       right: ((widget.peerId == currentUserId) ? 10 : 64)),
          //   child: Container(
          //     width: MediaQuery.of(context).size.width * 0.5,
          //     padding: EdgeInsets.all(8),
          //     decoration: BoxDecoration(
          //       color: (widget.peerId == currentUserId)
          //           ? Colors.greenAccent
          //           : Colors.orangeAccent,
          //       borderRadius: BorderRadius.circular(10),
          //     ),
          //     child: GestureDetector(
          //         onTap: () {
          //           // _loadFile(chatMessages.content);
          //         },
          //         onSecondaryTap: () {
          //           stopRecord();
          //         },
          //         child: Row(
          //           mainAxisAlignment: MainAxisAlignment.spaceBetween,
          //           crossAxisAlignment: CrossAxisAlignment.end,
          //           children: [
          //             Row(
          //               children: [
          //                 Icon(isPlayingMsg ? Icons.cancel : Icons.play_arrow),
          //                 // Text(
          //                 //   'Audio-${doc['timestamp']}',
          //                 //   maxLines: 10,
          //                 // ),
          //               ],
          //             ),
          //             // Text(
          //             //   date + " " + hour.toString() + ":" + min.toString() + ampm,
          //             //   style: TextStyle(fontSize: 10),
          //             // )
          //           ],
          //         )),
          //   ),
          // ),
          Container(
            margin: 4.marginRight,
            decoration: BoxDecoration(
              color: Colors.red,
              borderRadius: BorderRadius.circular(40.borderRadius),
            ),
            child: IconButton(
              onPressed: getImage,
              icon: Icon(
                Icons.camera_alt,
                size: 28,
              ),
              color: Colors.white,
            ),
          ),
          // Container(
          //   margin: const EdgeInsets.only(right: Sizes.dimen_4),
          //   decoration: BoxDecoration(
          //     color: AppColors.burgundy,
          //     borderRadius: BorderRadius.circular(Sizes.dimen_30),
          //   ),
          //   child: IconButton(
          //     onPressed:
          //         !isRecording ? () => startRecord() : () => stopRecord(),
          //     icon: Icon(
          //       !isRecording ? Icons.play_arrow : Icons.pause,
          //       size: Sizes.dimen_28,
          //     ),
          //     color: AppColors.white,

          //   ),
          // ),
          isRecording
              ? Flexible(
                  child: Container(
                    width: double.infinity,
                    height: 50,
                    // color: Colors.red,
                    child: Center(
                        child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        Text(
                          "Recording ...",
                          style: TextStyle(fontSize: 18),
                        ),
                        SizedBox(
                            height: 20,
                            width: 20,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                            )),
                      ],
                    )),
                  ),
                )
              : Flexible(
                  child: TextField(
                  focusNode: focusNode,
                  textInputAction: TextInputAction.send,
                  keyboardType: TextInputType.text,
                  textCapitalization: TextCapitalization.sentences,
                  controller: textEditingController,
                  // decoration:
                  //     kTextInputDecoration.copyWith(hintText: 'write here...'),
                  onSubmitted: (value) {
                    onSendMessage(textEditingController.text, MessageType.text);
                  },
                )),
          SizedBox(
            width: 10,
          ),
          Container(
              height: 50,
              margin: EdgeInsets.fromLTRB(5, 5, 10, 5),
              decoration: BoxDecoration(
                  boxShadow: [
                    BoxShadow(
                        color: isRecording ? Colors.white : Colors.black12,
                        spreadRadius: 4)
                  ],
                  // color: AppColors.spaceCadet,
                  shape: BoxShape.circle),
              child: GestureDetector(
                onLongPress: () {
                  startRecord();
                  setState(() {
                    isRecording = true;
                  });
                },
                onLongPressEnd: (details) {
                  stopRecord();
                  setState(() {
                    isRecording = false;
                  });
                },
                child: Container(
                    padding: EdgeInsets.all(10),
                    child: Icon(
                      Icons.mic,
                      color: Colors.white,
                      size: 20,
                    )),
              )),

          Container(
            margin: 4.marginLeft,
            decoration: BoxDecoration(
              color: Colors.red,
              borderRadius: BorderRadius.circular(30.borderRadius),
            ),
            child: IconButton(
              onPressed: () {
                onSendMessage(textEditingController.text, MessageType.text);
              },
              icon: const Icon(Icons.send_rounded),
              color: Colors.white,
            ),
          ),
        ],
      ),
    );
  }

  Widget buildItem(int index, DocumentSnapshot? documentSnapshot) {
    if (documentSnapshot != null) {
      ChatMessages chatMessages = ChatMessages.fromDocument(documentSnapshot);
      if (chatMessages.idFrom == currentUserId) {
        // right side (my message)
        return Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                chatMessages.type == MessageType.audio
                    ? VoiceMessage(
                        meBgColor: Colors.black38,
                        audioSrc: '${chatMessages.content}',
                        played: true,
                        // To show played badge or not.
                        me: false,
                        noiseCount: 1,

                        // Set message side.
                        onPlay: () {
                          _loadFile('${chatMessages.content}');
                        }, // Do something when voice played.
                      )
                    : SizedBox.shrink(),
                chatMessages.type == MessageType.text
                    ? Row(
                        children: [
                          messageBubble(
                            chatContent: chatMessages.content,
                            // color: AppColors.spaceLight,
                            // textColor: AppColors.white,
                            margin: 10.marginRight,
                          ),
                        ],
                      )
                    : chatMessages.type == MessageType.image
                        ? Container(
                            margin: EdgeInsets.only(right: 10, top: 10),
                            child: chatImage(
                                imageSrc: chatMessages.content, onTap: () {}),
                          )
                        : const SizedBox.shrink(),
                isMessageSent(index)
                    ? Container(
                        clipBehavior: Clip.hardEdge,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(20.borderRadius),
                        ),
                        child: Image.network(
                          widget.userAvatar,
                          width: 40.width,
                          height: 40.height,
                          fit: BoxFit.cover,
                          loadingBuilder: (BuildContext ctx, Widget child,
                              ImageChunkEvent? loadingProgress) {
                            if (loadingProgress == null) return child;
                            return Center(
                              child: CircularProgressIndicator(
                                color: Colors.red,
                                value: loadingProgress.expectedTotalBytes !=
                                            null &&
                                        loadingProgress.expectedTotalBytes !=
                                            null
                                    ? loadingProgress.cumulativeBytesLoaded /
                                        loadingProgress.expectedTotalBytes!
                                    : null,
                              ),
                            );
                          },
                          errorBuilder: (context, object, stackTrace) {
                            return const Icon(
                              Icons.account_circle,
                              size: 35,
                              color: Colors.blueGrey,
                            );
                          },
                        ),
                      )
                    : Container(
                        width: 35,
                      ),
              ],
            ),
            isMessageSent(index)
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
      } else {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                isMessageReceived(index)

                    // left side (received message)
                    ? Container(
                        clipBehavior: Clip.hardEdge,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Image.network(
                          widget.peerAvatar,
                          width: 40,
                          height: 40,
                          fit: BoxFit.cover,
                          loadingBuilder: (BuildContext ctx, Widget child,
                              ImageChunkEvent? loadingProgress) {
                            if (loadingProgress == null) return child;
                            return Center(
                              child: CircularProgressIndicator(
                                color: Colors.red,
                                value: loadingProgress.expectedTotalBytes !=
                                            null &&
                                        loadingProgress.expectedTotalBytes !=
                                            null
                                    ? loadingProgress.cumulativeBytesLoaded /
                                        loadingProgress.expectedTotalBytes!
                                    : null,
                              ),
                            );
                          },
                          errorBuilder: (context, object, stackTrace) {
                            return const Icon(
                              Icons.account_circle,
                              size: 35,
                              color: Colors.grey,
                            );
                          },
                        ),
                      )
                    : Container(
                        width: 35,
                      ),
                chatMessages.type == MessageType.audio
                    ? VoiceMessage(
                        meBgColor: Colors.red,
                        audioSrc: '${chatMessages.content}',
                        played: true,
                        // To show played badge or not.
                        me: true,
                        noiseCount: 1,
                        // Set message side.
                        onPlay: () {
                          _loadFile('${chatMessages.content}');

                          // _loadFile(chatMessages.content);
                        }, // Do something when voice played.
                      )
                    : SizedBox.shrink(),
                chatMessages.type == MessageType.text
                    ? messageBubble(
                        color: Colors.red,
                        textColor: Colors.white,
                        chatContent: chatMessages.content,
                        margin: EdgeInsets.only(left: 10),
                      )
                    : chatMessages.type == MessageType.image
                        ? Container(
                            margin: const EdgeInsets.only(left: 10, top: 10),
                            child: chatImage(
                                imageSrc: chatMessages.content, onTap: () {}),
                          )
                        : const SizedBox.shrink(),
              ],
            ),
            isMessageReceived(index)
                ? Container(
                    margin: const EdgeInsets.only(left: 50, top: 6, bottom: 8),
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
      }
    } else {
      return const SizedBox.shrink();
    }
  }

  Widget buildListMessage() {
    return Flexible(
      child: groupChatId.isNotEmpty
          ? StreamBuilder<QuerySnapshot>(
              stream: chatProvider.getChatMessage(groupChatId, _limit),
              builder: (BuildContext context,
                  AsyncSnapshot<QuerySnapshot> snapshot) {
                if (snapshot.hasData) {
                  listMessages = snapshot.data!.docs;
                  if (listMessages.isNotEmpty) {
                    return ListView.builder(
                        padding: const EdgeInsets.all(10),
                        itemCount: snapshot.data?.docs.length,
                        reverse: true,
                        controller: scrollController,
                        itemBuilder: (context, index) {
                          if (snapshot.hasData && snapshot.data != null) {
                            return buildItem(index, snapshot.data?.docs[index]);
                          } else {
                            return Center(
                              child: SizedBox(
                                height: 36,
                                width: 36,
                                child: CircularProgressIndicator(
                                  valueColor: AlwaysStoppedAnimation<Color>(
                                      Colors.blue),
                                ),
                              ),
                            );
                          }
                        });
                  } else {
                    return const Center(
                      child: Text('No messages...'),
                    );
                  }
                } else {
                  return const Center(
                    child: CircularProgressIndicator(
                      color: Colors.red,
                    ),
                  );
                }
              })
          : const Center(
              child: CircularProgressIndicator(
                color: Colors.red,
              ),
            ),
    );
  }
}
