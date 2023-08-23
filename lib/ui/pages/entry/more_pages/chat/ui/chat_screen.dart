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
  ChatController? chatProvider;
  AuthController? authProvider;

  @override
  void initState() {
    super.initState();
    chatProvider = context.read<ChatController>();
    authProvider = context.read<AuthController>();
  }

  @override
  void didChangeDependencies() {
    chatProvider!.readLocal(
        chatArgument: widget.arguments, idTo: chatProvider!.idToReceiver);
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
}
