import 'package:flutter/material.dart';
import 'package:food_delivery_app/ui/pages/entry/more_pages/chat/chat_controllers/chat_controller.dart';
import 'package:food_delivery_app/utils/extension/responsive_extension.dart';
import 'package:provider/provider.dart';
import 'package:voice_message_package/voice_message_package.dart';

class VoiceMessageWidget extends StatelessWidget {
  final bool isSender;
  final String audioSrc;
  final String timeStamp;

  const VoiceMessageWidget({
    required this.isSender,
    required this.audioSrc,
    required this.timeStamp,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment:
          isSender ? CrossAxisAlignment.start : CrossAxisAlignment.end,
      children: [
        ClipRRect(
          borderRadius: BorderRadius.circular(30), // Adjust the value as needed
          child: VoiceMessage(
            meBgColor: isSender ? Colors.red : Colors.deepOrange,
            // contactCircleColor: Colors.white,
            // mePlayIconColor: isSender ?Colors.white,
            contactPlayIconBgColor: Colors.white,
            contactFgColor: Colors.white,
            contactPlayIconColor: Colors.black,
            meFgColor: Colors.white,
            showDuration: false,
            // duration: Duration(seconds: ).inSeconds,
            contactBgColor: isSender ? Colors.red : Colors.deepOrange,
            formatDuration: (Duration duration) {
              return duration.toString().substring(2, 11);
            },
            audioSrc: audioSrc,
            played: true,
            me: isSender,
            noiseCount: 1,
            // Set message side.
            onPlay: () {
              Provider.of<ChatController>(context, listen: false)
                  .loadAndPlay(audioSrc);
            }, // Do something when voice played.
          ),
        ),
        Container(
          padding: 10.paddingAll,
          child: Text(
            timeStamp!,
            textAlign: TextAlign.start,
            style: const TextStyle(
                color: Colors.grey, fontSize: 12, fontStyle: FontStyle.italic),
          ),
        )
      ],
    );
  }
}
