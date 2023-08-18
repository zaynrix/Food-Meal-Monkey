import 'package:flutter/material.dart';
import 'package:food_delivery_app/core/controllers/auth_controller/auth_controller.dart';
import 'package:food_delivery_app/routing/navigations.dart';
import 'package:food_delivery_app/ui/pages/entry/more_pages/chat/chat_controllers/chat_controller.dart';
import 'package:food_delivery_app/ui/pages/entry/more_pages/chat/widgets/message_input.dart';
import 'package:food_delivery_app/ui/pages/entry/more_pages/chat/widgets/messeges_list.dart';
import 'package:food_delivery_app/utils/extension/responsive_extension.dart';
import 'package:provider/provider.dart';

class ChatArgument {
  final String peerId;
  final String peerAvatar;
  final String peerNickname;
  final String userAvatar;

  const ChatArgument(
      {Key? key,
      required this.peerNickname,
      required this.peerAvatar,
      required this.peerId,
      this.userAvatar = ""})
      : super();
}

class MessageType {
  static const text = 0;
  static const image = 1;
  static const sticker = 2;
  static const audio = 3;
}

class ChatPage extends StatefulWidget {
  final ChatArgument arguments;

  const ChatPage({required this.arguments, Key? key}) : super(key: key);

  @override
  State<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  // final ScrollController scrollController = ScrollController();

  ChatController? chatProvider;
  AuthController? authProvider;

  @override
  void initState() {
    super.initState();
    chatProvider = context.read<ChatController>();
    authProvider = context.read<AuthController>();

    // focusNode.addListener(onFocusChanged);
    // scrollController.addListener(_scrollListener);
  }

  // _scrollListener() {
  //   if (scrollController.offset >= scrollController.position.maxScrollExtent &&
  //       !scrollController.position.outOfRange) {
  //     setState(() {
  //       _limit += _limitIncrement;
  //     });
  //   }
  // }
  @override
  void didChangeDependencies() {
    chatProvider!.readLocal(chatArgument: widget.arguments);
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: () {
            ServiceNavigation.serviceNavi.back();
          },
          icon: const Icon(Icons.arrow_back_ios_new_outlined),
        ),
        title: Text('${widget.arguments.peerNickname}'.trim()),
        actions: [
          IconButton(
            onPressed: () {},
            icon: const Icon(Icons.video_call),
          ),
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
              MessagesListWidget(
                chatArgument: widget.arguments,
              ),
              SizedBox(
                height: 10,
              ),
              chatProvider!.isSending
                  ? LinearProgressIndicator(
                      backgroundColor: Colors.grey[100],
                      valueColor: AlwaysStoppedAnimation<Color>(Colors.blue),
                    )
                  : SizedBox.shrink(),
              MessageInputWidget(
                chatArgument: widget.arguments,
              ),
              10.addVerticalSpace,
            ],
          ),
        ),
      ),
    );
  }
  //
  // Future _loadFile(String url) async {
  //   final bytes = await readBytes(Uri(host: url));
  //   final dir = await getApplicationDocumentsDirectory();
  //   final file = File('${dir.path}/audio.mp3');
  //
  //   await file.writeAsBytes(bytes);
  //   if (await file.exists()) {
  //     setState(() {
  //       recordFilePath = file.path;
  //       chatProvider.isPlayingMsg = true;
  //       print(chatProvider.isPlayingMsg);
  //     });
  //     await play();
  //     setState(() {
  //       chatProvider.isPlayingMsg = false;
  //       print(chatProvider.isPlayingMsg);
  //     });
  //   }
  // }
  //
  // Future<bool> checkPermission() async {
  //   if (!await Permission.microphone.isGranted) {
  //     PermissionStatus status = await Permission.microphone.request();
  //     if (status != PermissionStatus.granted) {
  //       return false;
  //     }
  //   }
  //   return true;
  // }
  //
  // // bool isRecording = false;
  //
  // void startRecord() async {
  //   bool hasPermission = await checkPermission();
  //   if (hasPermission) {
  //     recordFilePath = await getFilePath();
  //
  //     RecordMp3.instance.start(recordFilePath!, (type) {
  //       setState(() {});
  //     });
  //   } else {}
  //   setState(() {});
  // }
  //
  // void stopRecord() async {
  //   bool s = RecordMp3.instance.stop();
  //   if (s) {
  //     setState(() {
  //       chatProvider.isSending = true;
  //     });
  //     await uploadAudio();
  //
  //     setState(() {
  //       chatProvider.isPlayingMsg = false;
  //     });
  //   }
  // }
  //
  // String? recordFilePath;
  //
  // Future<void> play() async {
  //   if (recordFilePath != null && File(recordFilePath!).existsSync()) {
  //     AudioPlayer audioPlayer = AudioPlayer();
  //     await audioPlayer.play(
  //       UrlSource(recordFilePath!),
  //       // isLocal: true,
  //     );
  //   }
  // }
  //
  // int i = 0;
  //
  // Future<String> getFilePath() async {
  //   Directory storageDirectory = await getApplicationDocumentsDirectory();
  //   String sdPath = storageDirectory.path + "/record";
  //   var d = Directory(sdPath);
  //   if (!d.existsSync()) {
  //     d.createSync(recursive: true);
  //   }
  //   return sdPath + "/test_${i++}.mp3";
  // }
  //
  // sendAudioMsg(String audioMsg) async {
  //   if (audioMsg.isNotEmpty) {
  //     var ref = FirebaseFirestore.instance
  //         .collection(FirestoreConstants.pathMessageCollection)
  //         .doc(groupChatId)
  //         .collection(groupChatId)
  //         .doc(DateTime.now().millisecondsSinceEpoch.toString());
  //     await FirebaseFirestore.instance.runTransaction((transaction) async {
  //       await transaction.set(ref, {
  //         FirestoreConstants.idFrom: authProvider.auth.currentUser!.uid,
  //         FirestoreConstants.idTo: widget.arguments.peerId,
  //         FirestoreConstants.timestamp:
  //             DateTime.now().millisecondsSinceEpoch.toString(),
  //         FirestoreConstants.content: audioMsg,
  //         FirestoreConstants.type: 3,
  //       });
  //     }).then((value) {
  //       setState(() {
  //         chatProvider.isSending = false;
  //       });
  //     });
  //     scrollController.animateTo(0.0,
  //         duration: Duration(milliseconds: 100), curve: Curves.bounceInOut);
  //   } else {
  //     print("Hello");
  //   }
  // }
  //
  // uploadAudio() {
  //   FirebaseStorage storage = FirebaseStorage.instance;
  //   Reference ref = storage.ref().child(
  //       'profilepics/audio${DateTime.now().millisecondsSinceEpoch.toString()}.jpg');
  //   UploadTask uploadTask = ref.putFile(File(recordFilePath!));
  //   uploadTask.then((value) async {
  //     print('##############done#########');
  //     var audioURL = await value.ref.getDownloadURL();
  //     String strVal = audioURL.toString();
  //     await sendAudioMsg(strVal);
  //   }).catchError((e) {
  //     print(e);
  //   });
  // }

  // Widget buildListMessage() {
  //   return Flexible(
  //     child: groupChatId.isNotEmpty
  //         ? StreamBuilder<QuerySnapshot>(
  //             stream: chatProvider.getChatMessage(groupChatId),
  //             builder: (BuildContext context,
  //                 AsyncSnapshot<QuerySnapshot> snapshot) {
  //               if (snapshot.hasData) {
  //                 listMessages = snapshot.data!.docs;
  //                 if (listMessages.isNotEmpty) {
  //                   return ListView.builder(
  //                       padding: const EdgeInsets.all(10),
  //                       itemCount: snapshot.data?.docs.length,
  //                       reverse: true,
  //                       controller: scrollController,
  //                       itemBuilder: (context, index) {
  //                         if (snapshot.hasData && snapshot.data != null) {
  //                           return buildItem(index, snapshot.data?.docs[index]);
  //                         } else {
  //                           return Center(
  //                             child: SizedBox(
  //                               height: 36,
  //                               width: 36,
  //                               child: CircularProgressIndicator(
  //                                 valueColor: AlwaysStoppedAnimation<Color>(
  //                                     Colors.blue),
  //                               ),
  //                             ),
  //                           );
  //                         }
  //                       });
  //                 } else {
  //                   return const Center(
  //                     child: Text('No messages...'),
  //                   );
  //                 }
  //               } else {
  //                 return const Center(
  //                   child: CircularProgressIndicator(
  //                     color: Colors.red,
  //                   ),
  //                 );
  //               }
  //             })
  //         : const Center(
  //             child: CircularProgressIndicator(
  //               color: Colors.red,
  //             ),
  //           ),
  //   );
  // }
}
