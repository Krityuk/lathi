import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:audioplayers/audioplayers.dart' show AudioPlayer, UrlSource;
// import 'package:flutter_riverpod/flutter_riverpod.dart';
// import 'package:laathi/features/notification/repository/notification_repository.dart';
import 'package:record/record.dart';
import 'package:laathi/features/wishbox/utils/wishbox_recording.dart';

class WishboxRecorderScreen extends StatefulWidget {
  const WishboxRecorderScreen({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _WishboxRecorderScreenState createState() => _WishboxRecorderScreenState();
  static const String routeName = '/voice-recording';
}

class _WishboxRecorderScreenState extends State<WishboxRecorderScreen> {
  bool _isRecording = false;
  String _recordingPath = '';
  late Record audioRecord;
  late AudioPlayer audioPlayer;
  final double _buttonSize = 150.0;
  final Color _buttonColor = Colors.blue;

  @override
  void initState() {
    audioPlayer = AudioPlayer();
    audioRecord = Record();
    super.initState();
  }

  @override
  void dispose() {
    audioRecord.dispose();
    audioPlayer.dispose();
    super.dispose();
  }

  Future<void> _startRecording() async {
    _isRecording = true;
    setState(() {});
  }

  Future<void> _stopRecording(String? path) async {
    _recordingPath = path!;
    _isRecording = false;
    setState(() {});
  }

  Future<void> _playRecording() async {
    try {
      var urlSource = UrlSource(_recordingPath);
      await audioPlayer.play(urlSource);
    } catch (e) {
      // ignore: avoid_print
      print('Error Playing Recording : $e');
    }
  }

  // Future<void> _playRecording() async {
  //   try {
  //     // Get the application's temporary directory
  //     final appDir = await getTemporaryDirectory();

  //     // Create a new file path by combining the temporary directory path and the recording file name
  //     final filePath = '${appDir.path}/$_recordingPath';

  //     // Convert the file path to a valid URL
  //     final fileUri = Uri.file(filePath);
  //     final urlPath = fileUri.toString();

  //     // Play the recording using the URL path
  //     await audioPlayer.play(
  //       UrlSource(urlPath),
  //     );
  //   } catch (e) {
  //     // ignore: avoid_print
  //     print('Error Playing Recording: $e');
  //   }
  // }

  Future<void> _uploadRecording() async {
    try {
      final File fileData = File(_recordingPath);
      final String fileName = fileData.path.split('/').last;

      final String? uid = FirebaseAuth.instance.currentUser?.uid;
      final String remotePath = 'users/$uid/wishbox/audio/$fileName';

      final firebaseStorage = FirebaseStorage.instance;

      final storageUploadTask =
          firebaseStorage.ref(remotePath).putFile(fileData);

      await storageUploadTask.whenComplete(() => null);

      final downloadUrl =
          await firebaseStorage.ref(remotePath).getDownloadURL();

      final storageReference = FirebaseFirestore.instance
          .collection('users/$uid/wishbox/data/audio')
          .doc();
      final String documentId = storageReference.id;
      await storageReference.set({
        'id': documentId,
        'url': downloadUrl,
        'storagePath': remotePath,
        'time': Timestamp.now(),
      });
    } catch (e) {
      // ignore: avoid_print
      print('Error Uploading Recording: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
  // Widget build(BuildContext context, WidgetRef ref) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title:
              const Text('Voice Recorder', style: TextStyle(color: Colors.black)),
        ),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Visibility(
                visible: _isRecording,
                maintainSize: true,
                maintainAnimation: true,
                maintainState: true,
                child: const Padding(
                  padding: EdgeInsets.all(8.0),
                  child: Text(
                    'Recording is in progress',
                    style: TextStyle(
                      fontSize: 20,
                    ),
                  ),
                ),
              ),
              VoiceButton(
                  buttonColor: _buttonColor,
                  buttonSize: _buttonSize,
                  startRec: _startRecording,
                  stopRec: _stopRecording,
                  size: 50),
              const SizedBox(
                height: 25,
              ),
              Visibility(
                  visible: !_isRecording && _recordingPath.isNotEmpty,
                  maintainSize: true,
                  maintainAnimation: true,
                  maintainState: true,
                  child: Column(
                    children: [
                      ElevatedButton(
                        onPressed: _playRecording,
                        child: const Text('Play Recording'),
                      ),
                      ElevatedButton(
                        onPressed: _uploadRecording,
                        // onPressed: () async {
                        //   await ref
                        //   _uploadRecording
                        //       // .watch(chatRepositoryProvider)
                        //       // .sendMessage(information, userId)
                        //       .then((_) async {
                        //   ref
                        //       .watch(notificationRepositoryProvider)
                        //       .addNotification(userId, userName, type);
                        //   await showMyDialog(context, "Done");
                        //   });
                        //   },
                        child: const Text('Upload Recording'),
                      ),
                    ],
                  ))
            ],
          ),
        ),
      ),
    );
  }
}
