import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';
import 'package:food_delivery_app/utils/extension/time_extension.dart';

class ChatItemModel extends Equatable {
  final DocumentSnapshot? documentSnapshot;
  final String? lastMessage;
  final String? lastSeen;
  final dynamic lastMessageType;
  final bool? isSeen;
  final bool? seenByReceiver;
  final String? messageTime;
  final String? idTo;

  ChatItemModel({
    this.documentSnapshot,
    this.lastMessage,
    this.lastSeen,
    this.lastMessageType,
    this.isSeen,
    this.seenByReceiver,
    this.messageTime,
    this.idTo,
  });

  factory ChatItemModel.fromSnapshot(Map<String, dynamic> snap,
      DocumentSnapshot documentSnapshot, extractedData) {
    return (ChatItemModel(
      documentSnapshot: documentSnapshot,
      lastMessage: snap["text"],
      lastMessageType: extractedData,
      isSeen: snap["isSeen"],
      seenByReceiver: snap["seenByReceiver"],
      messageTime: snap["timestamp"].toString().formattedTime(),
      idTo: snap["idTo"],
    ));
  }

  factory ChatItemModel.noMessages(DocumentSnapshot documentSnapshot) {
    return ChatItemModel(
      messageTime: "",
      lastSeen: "",
      lastMessageType: "No Messages Yet",
      lastMessage: "No Messages Yet",
      documentSnapshot: documentSnapshot,
      idTo: "",
      isSeen: false,
      seenByReceiver: false,
    );
  }
  @override
  String toString() {
    return 'ChatItemModel {'
        ' documentSnapshot: $documentSnapshot,'
        ' lastMessage: $lastMessage,'
        ' lastMessageType: $lastMessageType,'
        ' isSeen: $isSeen,'
        ' messageTime: $messageTime,'
        ' idTo: $idTo'
        '}';
  }

  @override
  // TODO: implement props
  List<Object?> get props => [
        messageTime,
        lastMessage,
        lastMessageType,
        documentSnapshot,
        idTo,
        isSeen,
        seenByReceiver,
        lastSeen
      ];
}
