import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:food_delivery_app/core/controllers/auth_controller/auth_controller.dart';
import 'package:food_delivery_app/ui/pages/entry/more_pages/chat/chat_controllers/chat_controller.dart';
import 'package:food_delivery_app/ui/pages/entry/more_pages/chat/ui/chat_screen.dart';
import 'package:food_delivery_app/utils/extension/responsive_extension.dart';
import 'package:provider/provider.dart';

class MessageInputWidget extends StatefulWidget {
  final ChatArgument? chatArgument;

  const MessageInputWidget({Key? key, this.chatArgument}) : super(key: key);

  @override
  State<MessageInputWidget> createState() => _MessageInputWidgetState();
}

class _MessageInputWidgetState extends State<MessageInputWidget> {
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
    return Consumer<ChatController>(
      builder: (context, chatConntroller, child) => SizedBox(
        width: double.infinity,
        height: 50,
        child: Row(
          children: [
            // Padding(
            //   padding: EdgeInsets.only(
            //       top: 8,
            //       left: ((widget.chatArgument!.peerId == userData!.uid)
            //           ? 64
            //           : 10),
            //       right: ((widget.chatArgument!.peerId == userData!.uid)
            //           ? 10
            //           : 64)),
            //   child: Container(
            //     width: MediaQuery.of(context).size.width * 0.5,
            //     padding: EdgeInsets.all(8),
            //     decoration: BoxDecoration(
            //       color: (widget.chatArgument!.peerId == userData!.uid)
            //           ? Colors.greenAccent
            //           : Colors.orangeAccent,
            //       borderRadius: BorderRadius.circular(10),
            //     ),
            //     child: GestureDetector(
            //         onTap: () {
            //           // _loadFile(chatMessages.content);
            //         },
            //         onSecondaryTap: () {
            //           chatConntroller.stopRecord();
            //         },
            //         child: Row(
            //           mainAxisAlignment: MainAxisAlignment.spaceBetween,
            //           crossAxisAlignment: CrossAxisAlignment.end,
            //           children: [
            //             Row(
            //               children: [
            //                 Icon(chatConntroller.isPlayingMsg
            //                     ? Icons.cancel
            //                     : Icons.play_arrow),
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
                onPressed: () => chatConntroller.getImage(
                    peerID: widget.chatArgument!.peerId),
                icon: Icon(
                  Icons.camera_alt,
                  size: 28,
                ),
                color: Colors.white,
              ),
            ),
            Container(
              margin: 4.marginRight,
              decoration: BoxDecoration(
                color: Colors.red,
                borderRadius: BorderRadius.circular(40.borderRadius),
              ),
              child: IconButton(
                onPressed: !chatConntroller.isRecording
                    ? () => chatConntroller.startRecording()
                    : () => chatConntroller.stopRecordingAndUpload(
                        chatArgument: widget.chatArgument),
                icon: Icon(
                  !chatConntroller.isRecording ? Icons.play_arrow : Icons.pause,
                  size: 28,
                ),
                color: Colors.white,
              ),
            ),
            chatConntroller.isRecording
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
                    style: TextStyle(color: Colors.black),
                    // focusNode: focusNode,
                    textInputAction: TextInputAction.send,
                    keyboardType: TextInputType.text,
                    textCapitalization: TextCapitalization.sentences,
                    controller: chatConntroller.textEditingController,
                    // decoration:
                    //     kTextInputDecoration.copyWith(hintText: 'write here...'),
                    onSubmitted: (value) {
                      chatConntroller.onSendMessage(
                          chatConntroller.textEditingController.text,
                          peerId: widget.chatArgument!.peerId,
                          MessageType.text);
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
                          color: chatConntroller.isRecording
                              ? Colors.white
                              : Colors.black12,
                          spreadRadius: 4)
                    ],
                    // color: AppColors.spaceCadet,
                    shape: BoxShape.circle),
                child: GestureDetector(
                  onLongPress: () {
                    chatConntroller.startRecording();
                    setState(() {
                      chatConntroller.isRecording = true;
                    });
                  },
                  onLongPressEnd: (details) {
                    chatConntroller.stopRecordingAndUpload(
                        chatArgument: widget.chatArgument);
                    setState(() {
                      chatConntroller.isRecording = false;
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
                  chatConntroller.onSendMessage(
                      peerId: widget.chatArgument!.peerId,
                      chatConntroller.textEditingController.text,
                      MessageType.text);
                },
                icon: const Icon(Icons.send_rounded),
                color: Colors.white,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
