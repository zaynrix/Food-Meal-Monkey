import 'dart:io';

//PR
import 'package:audioplayers/audioplayers.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:food_delivery_app/ui/pages/entry/more_pages/chat/firestore_constants.dart';
import 'package:food_delivery_app/ui/pages/entry/more_pages/chat/models/chat_messages.dart';
import 'package:food_delivery_app/ui/pages/entry/more_pages/chat/ui/chat_screen.dart';
import 'package:http/http.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:record_mp3/record_mp3.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';

class ChatController extends ChangeNotifier {
  final SharedPreferences prefs;
  final FirebaseFirestore firebaseFirestore;
  final FirebaseStorage firebaseStorage;
  final FirebaseAuth auth = FirebaseAuth.instance;
  String groupChatId = '';
  bool isSending = false;
  bool isPlayingMsg = false, isRecording = false;
  File? imageFile;
  bool isLoading = false;
  bool isShowSticker = false;
  String imageUrl = '';
  String? recordFilePath;
  String senderString = "";
  String idToReceiver = "";

  final TextEditingController textEditingController = TextEditingController();

  ChatController({
    required this.prefs,
    required this.firebaseStorage,
    required this.firebaseFirestore,
  });

  void setMessageSender(String senderID) {
    senderString = senderID;
  }

  void setIdTo(String idTo) {
    idToReceiver = idTo;
    notifyListeners();
  }

  Stream<QuerySnapshot> getFirestoreData(String collectionPath) {
    return firebaseFirestore.collection(collectionPath).snapshots();
  }

  Future<void> updateFirestoreData(
      String collectionPath, String docPath, Map<String, dynamic> dataUpdate) {
    return firebaseFirestore
        .collection(collectionPath)
        .doc(docPath)
        .update(dataUpdate);
  }

  UploadTask uploadImageFile(File image, String filename) {
    Reference reference = firebaseStorage.ref().child(filename);
    return reference.putFile(image);
  }

  Future<void> loadAndPlay(String url) async {
    print("play now 1");
    final bytes = await readBytes(Uri.parse(url));
    final dir = await getApplicationDocumentsDirectory();
    final file = File('${dir.path}/audio.mp3');

    await file.writeAsBytes(bytes);

    if (await file.exists()) {
      recordFilePath = file.path;
      isPlayingMsg = true;
      notifyListeners();

      await play(recordFilePath!);

      isPlayingMsg = false;
      notifyListeners();
    }
  }

  Future<void> play(String filePath) async {
    if (File(filePath).existsSync()) {
      AudioPlayer audioPlayer = AudioPlayer();
      audioPlayer.onPlayerStateChanged.listen((event) {
        // Release the audio player when playback is complete
        audioPlayer.dispose();
      });

      await audioPlayer.play(
        UrlSource(filePath),
      );
    }
  }

  bool isMessageReceived(int index) {
    if ((index > 0 &&
            listMessages[index - 1].get(FirestoreConstants.idFrom) ==
                auth.currentUser!.uid) ||
        index == 0) {
      return true;
    } else {
      return false;
    }
  }

  void sendChatMessage(String content, int type, String groupChatId,
      String currentUserId, String peerId) {
    DocumentReference documentReference = firebaseFirestore
        .collection(FirestoreConstants.pathMessageCollection)
        .doc(groupChatId)
        .collection(groupChatId)
        .doc(DateTime.now().millisecondsSinceEpoch.toString());
    ChatMessages chatMessages = ChatMessages(
      isSeen: false,
      seenByReceiver: false,
      idFrom: currentUserId,
      idTo: peerId,
      timestamp: DateTime.now().millisecondsSinceEpoch.toString(),
      content: content,
      type: type,
    );

    FirebaseFirestore.instance.runTransaction((transaction) async {
      transaction.set(documentReference, chatMessages.toJson());
    });
  }

  Stream<QuerySnapshot> getChatMessage(String groupChatId) {
    return firebaseFirestore
        .collection(FirestoreConstants.pathMessageCollection)
        .doc(groupChatId)
        .collection(groupChatId)
        .orderBy(FirestoreConstants.timestamp, descending: true)
        .snapshots();
  }

  void readLocal({ChatArgument? chatArgument, idTo}) {
    final currentUserUid = auth.currentUser?.uid;
    if (currentUserUid != null) {
      final peerId = chatArgument?.peerId ?? '';
      if (currentUserUid.compareTo(peerId) > 0) {
        groupChatId = '$currentUserUid - $peerId';
        if (currentUserUid == idToReceiver) {
          markMessagesAsSeen(currentUserUid, peerId);
          print("update now ");
        } else {
          print("no update");
        }
      } else {
        groupChatId = '$peerId - $currentUserUid';
        if (currentUserUid == idToReceiver) {
          markMessagesAsSeen(peerId, currentUserUid);
          print("update now ");
        } else {
          print("no update");
        }
        print("ELSE  peerId - currentUserUid : $peerId - $currentUserUid");
      }
      updateFirestoreData(
        FirestoreConstants.pathUserCollection,
        currentUserUid,
        {FirestoreConstants.chattingWith: peerId},
      );
    }
  }

  void callPhoneNumber(String phoneNumber) async {
    var url = 'tel://$phoneNumber';
    var uri = Uri(host: url);
    if (await launchUrl(uri)) {
      await launchUrl(uri);
    } else {
      throw 'Error Occurred';
    }
  }

  // Future<String?> getLastMessageForUserChats(
  //     String chatUserId, String currentUserId) async {
  //   print("This chatUserId $chatUserId - $currentUserId ");
  //   try {
  //     if (currentUserId != chatUserId) {
  //       print(" inside ");
  //
  //       QuerySnapshot messagesSnapshot = await firebaseFirestore
  //           .collection(FirestoreConstants.pathMessageCollection)
  //           .doc("$chatUserId - $currentUserId")
  //           .collection("$chatUserId - $currentUserId")
  //           .orderBy(FirestoreConstants.timestamp, descending: true)
  //           .limit(1)
  //           .get();
  //
  //       if (messagesSnapshot.docs.isNotEmpty) {
  //         print(
  //             " messagesSnapshot.docs.isEmpty: ${messagesSnapshot.docs.isEmpty}");
  //         Map<String, dynamic> lastMessageData =
  //             messagesSnapshot.docs.first.data() as Map<String, dynamic>;
  //
  //         print("This Message ${lastMessageData['type']}");
  //         String lastMessage = '';
  //         if (lastMessageData['type'] == MessageType.text) {
  //           lastMessage = lastMessageData['text'] as String;
  //         } else if (lastMessageData['type'] == MessageType.image) {
  //           lastMessage =
  //               'Image'; // Or any other appropriate message for images
  //         } else if (lastMessageData['type'] == MessageType.sticker) {
  //           lastMessage =
  //               'Sticker'; // Or any other appropriate message for stickers
  //         } else if (lastMessageData['type'] == MessageType.audio) {
  //           lastMessage = 'Audio'; // Or any other appropriate message for audio
  //         }
  //         return lastMessage;
  //       } else if (messagesSnapshot.docs.isEmpty) {
  //         QuerySnapshot messagesSnapshot = await firebaseFirestore
  //             .collection(FirestoreConstants.pathMessageCollection)
  //             .doc("$currentUserId - $chatUserId")
  //             .collection("$currentUserId - $chatUserId")
  //             .orderBy(FirestoreConstants.timestamp, descending: true)
  //             .limit(54)
  //             .get();
  //         print(
  //             " messagesSnapshot.docs.isEmpty: ${messagesSnapshot.docs.isEmpty}");
  //         Map<String, dynamic> lastMessageData =
  //             messagesSnapshot.docs.first.data() as Map<String, dynamic>;
  //
  //         print("This Message ${lastMessageData['type']}");
  //         String lastMessage = '';
  //         if (lastMessageData['type'] == MessageType.text) {
  //           lastMessage = lastMessageData['text'] as String;
  //         } else if (lastMessageData['type'] == MessageType.image) {
  //           lastMessage =
  //               'Image'; // Or any other appropriate message for images
  //         } else if (lastMessageData['type'] == MessageType.sticker) {
  //           lastMessage =
  //               'Sticker'; // Or any other appropriate message for stickers
  //         } else if (lastMessageData['type'] == MessageType.audio) {
  //           lastMessage = 'Audio'; // Or any other appropriate message for audio
  //         }
  //         print("else ");
  //         return lastMessage;
  //       }
  //     }
  //   } catch (error) {
  //     print("Error fetching last message: $error");
  //     return null; // Return null on error
  //   }
  // }

  // Future<String?> getLastMessageForUserChats(
  //     String chatUserId, String currentUserId) async {
  //   try {
  //     if (currentUserId != chatUserId) {
  //       QuerySnapshot messagesSnapshot =
  //           await fetchMessagesSnapshot(chatUserId, currentUserId);
  //
  //       if (messagesSnapshot.docs.isEmpty) {
  //         messagesSnapshot =
  //             await fetchMessagesSnapshot(currentUserId, chatUserId);
  //       }
  //
  //       if (messagesSnapshot.docs.isNotEmpty) {
  //         return extractLastMessage(messagesSnapshot.docs.first.data());
  //       }
  //     }
  //   } catch (error) {
  //     print("Error fetching last message: $error");
  //   }
  //   return null; // Return null if no last message found
  // }
  Future<Map<String, dynamic>?> getLastMessageForUserChats(
      String chatUserId, String currentUserId) async {
    print("chatUserId: $chatUserId - currentUserId: $currentUserId");

    try {
      if (currentUserId != chatUserId) {
        QuerySnapshot messagesSnapshot =
            await fetchMessagesSnapshot(chatUserId, currentUserId);
        print("First if ${{messagesSnapshot.docs}}");
        if (messagesSnapshot.docs.isEmpty) {
          messagesSnapshot =
              await fetchMessagesSnapshot(currentUserId, chatUserId);
          print("Second if ${{messagesSnapshot.docs}}");
        }

        if (messagesSnapshot.docs.isNotEmpty) {
          return messagesSnapshot.docs.first.data() as Map<String, dynamic>;
        }
      }
    } catch (error) {
      print("Error fetching last message: $error");
    }
    return null; // Return null if no last message found
  }

  Future<QuerySnapshot> fetchMessagesSnapshot(
      String firstOrder, String secondOrder) async {
    print("firstOrder $firstOrder - $secondOrder");
    return await firebaseFirestore
        .collection(FirestoreConstants.pathMessageCollection)
        .doc("$firstOrder - $secondOrder")
        .collection("$firstOrder - $secondOrder")
        .orderBy(FirestoreConstants.timestamp, descending: true)
        .limit(1)
        .get();
  }

  String extractLastMessage(Map<String, dynamic> messageData) {
    String lastMessage = '';

    switch (messageData['type']) {
      case MessageType.text:
        lastMessage = messageData['text'] as String;
        break;
      case MessageType.image:
        lastMessage = 'Image';
        break;
      case MessageType.sticker:
        lastMessage = 'Sticker';
        break;
      case MessageType.audio:
        lastMessage = 'Audio';
        break;
      default:
        lastMessage = 'Unknown Message Type';
    }

    return lastMessage;
  }

  void markMessagesAsSeen(String chatUserId, String currentUserId) async {
    print("markMessagesAsSeen");

    try {
      if (currentUserId != chatUserId) {
        QuerySnapshot messagesSnapshot =
            await fetchMessagesSnapshot(chatUserId, currentUserId);
        for (QueryDocumentSnapshot messageSnapshot in messagesSnapshot.docs) {
          await messageSnapshot.reference.update({'seenByReceiver': true});
        }
        print("First if ${{messagesSnapshot.docs.single}}");
        if (messagesSnapshot.docs.isEmpty) {
          messagesSnapshot =
              await markMessagesAsSeenSub(currentUserId, chatUserId);

          print("Second if ${{messagesSnapshot.docs}}");
          for (QueryDocumentSnapshot messageSnapshot in messagesSnapshot.docs) {
            await messageSnapshot.reference.update({'isSeen': true});
          }
        }

        if (messagesSnapshot.docs.isNotEmpty) {
          messagesSnapshot =
              await markMessagesAsSeenSub(currentUserId, chatUserId);

          print("Second if ${{messagesSnapshot.docs}}");
          for (QueryDocumentSnapshot messageSnapshot in messagesSnapshot.docs) {
            await messageSnapshot.reference.update({'seenByReceiver': true});
          }
        }
      }
    } catch (error) {
      print("Error fetching last message: $error");
    }
    return null; // Return null if no last message found
  }

  Future<QuerySnapshot> markMessagesAsSeenSub(
      String firstOrder, String secondOrder) async {
    print("firstOrder $firstOrder - $secondOrder");
    return await firebaseFirestore
        .collection(FirestoreConstants.pathMessageCollection)
        .doc("$firstOrder - $secondOrder")
        .collection("$firstOrder - $secondOrder")
        .get();
  }

  List<QueryDocumentSnapshot> listMessages = [];

  bool isMessageSent(int index) {
    if ((index > 0 &&
            listMessages[index - 1].get(FirestoreConstants.idFrom) !=
                auth.currentUser!.uid) ||
        index == 0) {
      return true;
    } else {
      return false;
    }
  }

  void uploadImageFileController({String? peerID}) async {
    String fileName = DateTime.now().millisecondsSinceEpoch.toString();
    UploadTask uploadTask = uploadImageFile(imageFile!, fileName);
    try {
      TaskSnapshot snapshot = await uploadTask;
      imageUrl = await snapshot.ref.getDownloadURL();
      isLoading = false;
      notifyListeners();
      onSendMessage(imageUrl, MessageType.image, peerId: peerID!);
    } on FirebaseException catch (e) {
      isLoading = false;
      notifyListeners();
      Fluttertoast.showToast(msg: e.message ?? e.toString());
    }
  }

  Future getImage({String? peerID}) async {
    ImagePicker imagePicker = ImagePicker();
    XFile? pickedFile;
    pickedFile = await imagePicker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      imageFile = File(pickedFile.path);
      if (imageFile != null) {
        isLoading = true;
        notifyListeners();
        uploadImageFileController(peerID: peerID!);
      }
    }
  }

  // Check microphone permission
  Future<bool> checkMicrophonePermission() async {
    if (!await Permission.microphone.isGranted) {
      PermissionStatus status = await Permission.microphone.request();
      return status == PermissionStatus.granted;
    }
    return true;
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

  sendAudioMsg(String audioMsg, {ChatArgument? chatArgument}) async {
    if (audioMsg.isNotEmpty) {
      var ref = FirebaseFirestore.instance
          .collection(FirestoreConstants.pathMessageCollection)
          .doc(groupChatId)
          .collection(groupChatId)
          .doc(DateTime.now().millisecondsSinceEpoch.toString());
      await FirebaseFirestore.instance.runTransaction((transaction) async {
        await transaction.set(ref, {
          FirestoreConstants.idFrom: auth.currentUser!.uid,
          FirestoreConstants.idTo: chatArgument!.peerId,
          FirestoreConstants.isSeen: false,
          FirestoreConstants.seenByReceiver: false,
          FirestoreConstants.timestamp:
              DateTime.now().millisecondsSinceEpoch.toString(),
          FirestoreConstants.content: audioMsg,
          FirestoreConstants.type: 3,
        });
      }).then((value) {
        isSending = false;
        notifyListeners();
      });
    } else {
      isSending = false;
      notifyListeners();
    }
  }

  // Start recording audio
  void startRecording() async {
    bool hasPermission = await checkMicrophonePermission();

    if (hasPermission) {
      try {
        recordFilePath = await getFilePath();
        RecordMp3.instance.start(recordFilePath!, (type) {
          // Handle different types or events if needed
          print('Recording event: $type');
          notifyListeners();
        });
      } catch (e) {
        print('Error starting recording: $e');
        // Handle the error as needed, e.g., show a message to the user
      }
    } else {
      // Handle the case where microphone permission is not granted
    }
  }

  // Stop recording audio and upload
  void stopRecordingAndUpload({ChatArgument? chatArgument}) async {
    bool success = RecordMp3.instance.stop();
    if (success) {
      isSending = true;
      notifyListeners();
      await uploadAudio(chatArgument: chatArgument);
      // isPlayingMsg = false;
      // notifyListeners();
    }
  }

  uploadAudio({ChatArgument? chatArgument}) {
    FirebaseStorage storage = FirebaseStorage.instance;
    Reference ref = storage.ref().child(
        'profilepics/audio${DateTime.now().millisecondsSinceEpoch.toString()}.jpg');
    UploadTask uploadTask = ref.putFile(File(recordFilePath!));
    uploadTask.then((value) async {
      print('##############done#########');
      var audioURL = await value.ref.getDownloadURL();
      String strVal = audioURL.toString();
      await sendAudioMsg(strVal, chatArgument: chatArgument);
    }).catchError((e) {
      print(e);
    });
  }

  // // Play audio from local file
  // Future<void> playAudio() async {
  //   if (recordFilePath != null && File(recordFilePath!).existsSync()) {
  //     AudioPlayer audioPlayer = AudioPlayer();
  //     audioPlayer.play(
  //       UrlSource(recordFilePath!),
  //     );
  //   }
  // }

  void onSendMessage(String content, int type, {String? peerId}) {
    isSending = true;
    notifyListeners();
    if (content.trim().isNotEmpty) {
      textEditingController.clear();
      Future.delayed(Duration(seconds: 1), () {
        sendChatMessage(
          content,
          type,
          groupChatId,
          auth.currentUser!.uid,
          peerId!,
        );
        isSending = false;
        notifyListeners();
      });
    } else {
      Fluttertoast.showToast(
        msg: 'Nothing to send',
        backgroundColor: Colors.grey,
      );
    }
    isSending = false;
    notifyListeners();
  }

// Rest of the methods...

// Rest of the class...
}
