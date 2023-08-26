import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:food_delivery_app/ui/pages/entry/more_pages/chat/firestore_constants.dart';

class ChatUser {
  final String id;
  final String photoUrl;
  final String displayName;
  final String phoneNumber;
  final String email;
  final String address;
  final String lastSeen;
  final bool online;

  ChatUser({
    required this.id,
    required this.photoUrl,
    required this.displayName,
    required this.phoneNumber,
    required this.email,
    required this.address,
    required this.lastSeen,
    required this.online,
  });

  factory ChatUser.fromDocument(DocumentSnapshot snapshot) {
    final Map<String, dynamic>? data = snapshot.data() as Map<String, dynamic>?;

    final String? photoUrl = data?[FirestoreConstants.photoUrl];
    final String? displayName = data?[FirestoreConstants.displayName];
    final String? phoneNumber = data?[FirestoreConstants.phoneNumber];
    final String? email = data?[FirestoreConstants.email];
    final String? address = data?[FirestoreConstants.address];
    final String? lastSeen = data?[FirestoreConstants.lastSeen];
    final bool? online = data?[FirestoreConstants.online];

    return ChatUser(
      id: snapshot.id,
      photoUrl: photoUrl ?? "",
      displayName: displayName ?? "",
      phoneNumber: phoneNumber ?? "",
      address: address ?? "",
      lastSeen: lastSeen ?? "",
      online: online ?? false,
      email: email ?? "",
    );
  }
}
