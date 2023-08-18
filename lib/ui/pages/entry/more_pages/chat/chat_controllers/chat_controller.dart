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

  Future loadFile(String url) async {
    final bytes = await readBytes(Uri(host: url));
    final dir = await getApplicationDocumentsDirectory();
    final file = File('${dir.path}/audio.mp3');

    await file.writeAsBytes(bytes);
    if (await file.exists()) {
      // setState(() {
      recordFilePath = file.path;
      isPlayingMsg = true;
      notifyListeners();
      // });
      await play();
      isPlayingMsg = false;
      notifyListeners();
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

  void readLocal({ChatArgument? chatArgument}) {
    if (auth.currentUser!.uid.compareTo(chatArgument!.peerId) > 0) {
      groupChatId = '${auth.currentUser!.uid} - ${chatArgument.peerId}';
    } else {
      groupChatId = '${chatArgument.peerId} - ${auth.currentUser!.uid}';
    }
    updateFirestoreData(
      FirestoreConstants.pathUserCollection,
      auth.currentUser!.uid,
      {FirestoreConstants.chattingWith: chatArgument.peerId},
    );
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
  Future<void> play() async {
    if (recordFilePath != null && File(recordFilePath!).existsSync()) {
      AudioPlayer audioPlayer = AudioPlayer();
      await audioPlayer.play(
        UrlSource(recordFilePath!),
        // isLocal: true,
      );
    }
  }

  // Load audio file from URL and play
  // Future<void> loadFileAndPlay(String url) async {
  //   final bytes = await readBytes(Uri.parse(url));
  //   final dir = await getApplicationDocumentsDirectory();
  //   final file = File('${dir.path}/audio.mp3');
  //
  //   await file.writeAsBytes(bytes);
  //
  //   if (await file.exists()) {
  //     recordFilePath = file.path;
  //     isPlayingMsg = true;
  //     notifyListeners();
  //     await play();
  //     isPlayingMsg = false;
  //     notifyListeners();
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
      recordFilePath = await getFilePath();
      RecordMp3.instance.start(recordFilePath!, (type) {});
      notifyListeners();
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
