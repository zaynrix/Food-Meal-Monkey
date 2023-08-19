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

  final TextEditingController textEditingController = TextEditingController();

  ChatController({
    required this.prefs,
    required this.firebaseStorage,
    required this.firebaseFirestore,
  });

  void setMessageSender(String senderID) {
    senderString = senderID;
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

  // Future loadFile(String url) async {
  //   final bytes = await readBytes(
  //       Uri.parse(url)); // Use 'Uri.parse' to create a valid Uri object
  //   final dir = await getApplicationDocumentsDirectory();
  //   final file = File('${dir.path}/audio.mp3');
  //
  //   await file.writeAsBytes(bytes);
  //
  //   if (await file.exists()) {
  //     recordFilePath = file.path;
  //     isPlayingMsg = true;
  //     notifyListeners();
  //
  //     await play(); // Make sure you have the 'play' function defined somewhere
  //     isPlayingMsg = false;
  //     notifyListeners();
  //   }
  // }
  Future<void> play(String filePath) async {
    if (File(filePath).existsSync()) {
      AudioPlayer audioPlayer = AudioPlayer();
      await audioPlayer.play(
        UrlSource(filePath),
      );
      audioPlayer.onPlayerComplete.listen((event) {
        // Release the audio player when playback is complete
        audioPlayer.dispose();
      });
    }
  }

  Future<void> loadAndPlay(String url) async {
    final bytes = await readBytes(Uri.parse(url));
    final dir = await getApplicationDocumentsDirectory();
    final file = File('${dir.path}/audio.mp3');

    await file.writeAsBytes(bytes);

    if (await file.exists()) {
      recordFilePath = file.path;
      isPlayingMsg = true;
      notifyListeners();

      await play(recordFilePath!);
    }
    isPlayingMsg = false;
    notifyListeners();
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

  Future<String?> getLastMessage(String groupChatId) async {
    try {
      QuerySnapshot messagesSnapshot = await firebaseFirestore
          .collection(FirestoreConstants.pathMessageCollection)
          .doc(groupChatId)
          .collection(groupChatId)
          .orderBy(FirestoreConstants.timestamp, descending: true)
          .limit(1)
          .get();

      if (messagesSnapshot.docs.isNotEmpty) {
        String lastMessageContent =
            messagesSnapshot.docs.first.get('content') as String;
        return lastMessageContent;
      } else {
        return null; // Return null if no messages found
      }
    } catch (error) {
      print("Error fetching last message: $error");
      return null; // Return null on error
    }
  }
  // Future<String?> getLastMessage(String peerId, String currentUserId) async {
  //   try {
  //     QuerySnapshot messagesSnapshot = await FirebaseFirestore.instance
  //         .collection('messages')
  //         .doc(peerId)
  //         .collection(currentUserId)
  //         .orderBy('timestamp', descending: true)
  //         .limit(1)
  //         .get();
  //
  //     if (messagesSnapshot.docs.isNotEmpty) {
  //       String lastMessage = messagesSnapshot.docs.first.get('text') as String;
  //       return lastMessage;
  //     } else {
  //       return null; // Return null if no messages found
  //     }
  //   } catch (error) {
  //     print("Error fetching last message: $error");
  //     return null; // Return null on error
  //   }
  // }
  // String lastMessage = "";
  // void loadLastMessage(documentSnapshot) async {
  //   if (documentSnapshot != null) {
  //     String groupChatId = documentSnapshot!.id;
  //     print("this id ${groupChatId}");
  //     // Use the group chat ID from the document ID
  //
  //     QuerySnapshot lastMessageQuery = await FirebaseFirestore.instance
  //         .collection('messages')
  //         .doc(groupChatId)
  //         .collection(groupChatId)
  //         .orderBy('timestamp', descending: true)
  //         .limit(1)
  //         .get();
  //     print(
  //         "sdadadasda${FirebaseFirestore.instance.collection('messages').doc(groupChatId)}");
  //     if (lastMessageQuery.docs.isNotEmpty) {
  //       lastMessage = lastMessageQuery.docs.first['message'];
  //       notifyListeners();
  //     }
  //   }
  // }

  // void fetchLastMessage(documentSnapshot) async {
  //   if (documentSnapshot != null) {
  //     ChatUser userChat = ChatUser.fromDocument(documentSnapshot!);
  //
  //     QuerySnapshot messagesSnapshot = await FirebaseFirestore.instance
  //         .collection(FirestoreConstants.pathMessageCollection)
  //         .doc(groupChatId)
  //         .collection(groupChatId)
  //         .orderBy('timestamp', descending: true)
  //         .limit(1)
  //         .get();
  //     // setState(() {});
  //     if (messagesSnapshot.docs.isNotEmpty) {
  //       lastMessage = messagesSnapshot.docs.first['text'];
  //       print("This last $lastMessage");
  //     }
  //
  //     // setState(() {});
  //   }
  // }

  void readLocal({ChatArgument? chatArgument}) {
    final currentUserUid = auth.currentUser?.uid;
    if (currentUserUid != null) {
      final peerId = chatArgument?.peerId ?? '';
      if (currentUserUid.compareTo(peerId) > 0) {
        groupChatId = '$currentUserUid - $peerId';
      } else {
        groupChatId = '$peerId - $currentUserUid';
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

  Future getLastMessageForUserChats(
      String chatUserId, String currentUserId) async {
    String lastMessage = '';
    try {
      QuerySnapshot messagesSnapshot = await firebaseFirestore
          .collection(FirestoreConstants.pathMessageCollection)
          .doc("$currentUserId - $chatUserId")
          .collection("$currentUserId - $chatUserId")
          .orderBy(FirestoreConstants.timestamp, descending: true)
          .limit(1)
          .get();
      if (messagesSnapshot.docs.isNotEmpty) {
        Map<String, dynamic> lastMessageData =
            messagesSnapshot.docs.first.data() as Map<String, dynamic>;

        if (lastMessageData['type'] == MessageType.text) {
          lastMessage = lastMessageData['text'] as String;
        } else if (lastMessageData['type'] == MessageType.image) {
          lastMessage = 'Image'; // Or any other appropriate message for images
        } else if (lastMessageData['type'] == MessageType.sticker) {
          lastMessage =
              'Sticker'; // Or any other appropriate message for stickers
        } else if (lastMessageData['type'] == MessageType.audio) {
          lastMessage = 'Audio'; // Or any other appropriate message for audio
        }

        return lastMessage;
      }
    } catch (error) {
      print("Error fetching last message: $error");
      return null; // Return null on error
    }
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

  // Rest of the methods...
  // Future<void> play() async {
  //   if (recordFilePath != null && File(recordFilePath!).existsSync()) {
  //     AudioPlayer audioPlayer = AudioPlayer();
  //     await audioPlayer.play(
  //       UrlSource(recordFilePath!),
  //       // isLocal: true,
  //     );
  //   }
  // }

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
          FirestoreConstants.timestamp:
              DateTime.now().millisecondsSinceEpoch.toString(),
          FirestoreConstants.content: audioMsg,
          FirestoreConstants.type: 3,
        });
      }).then((value) {
        isSending = false;
        notifyListeners();
      });
      // scrollController.animateTo(0.0,
      //     duration: Duration(milliseconds: 100), curve: Curves.bounceInOut);
    } else {
      isSending = false;
      notifyListeners();
      print("Hello");
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
      isPlayingMsg = false;
      notifyListeners();
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

  // Play audio from local file
  Future<void> playAudio() async {
    if (recordFilePath != null && File(recordFilePath!).existsSync()) {
      AudioPlayer audioPlayer = AudioPlayer();
      await audioPlayer.play(
        UrlSource(recordFilePath!),
      );
    }
  }

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
