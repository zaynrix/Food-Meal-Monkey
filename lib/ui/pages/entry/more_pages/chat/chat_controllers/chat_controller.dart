import 'package:flutter/material.dart';

class ChatController extends ChangeNotifier {
  String senderString = "";
  void setMessageSender(String senderID) {
    senderString = senderID;
    // notifyListeners();
  }
}
