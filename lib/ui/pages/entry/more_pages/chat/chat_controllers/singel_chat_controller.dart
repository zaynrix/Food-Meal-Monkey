import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SingleChatController extends ChangeNotifier {
  final SharedPreferences prefs;
  final FirebaseFirestore firebaseFirestore;
  final FirebaseStorage firebaseStorage;

  SingleChatController(
      {required this.prefs,
      required this.firebaseStorage,
      required this.firebaseFirestore});

  Future<String> fetchParticipantName(
      String participantUid, String currentUserUid) async {
    try {
      if (participantUid != currentUserUid) {
        final userDoc = await firebaseFirestore
            .collection('users')
            .doc(participantUid)
            .get();
        if (userDoc.exists) {
          final userData = userDoc.data() as Map<String, dynamic>;
          final userName = userData['name'] as String;
          return userName;
        }
      }

      return '';
    } catch (error) {
      throw error;
    }
  }
}
