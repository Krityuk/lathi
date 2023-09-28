import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:laathi/features/sms_sharing/repository/sms_sharing_repository.dart';
import 'package:laathi/utils/constants.dart';
import 'package:laathi/features/chat/repository/chat_repository.dart';
import 'package:laathi/features/chat/widgets/message_bubble.dart';
import 'package:image_picker/image_picker.dart';
import 'package:laathi/features/wishbox/utils/wishbox_recording.dart';
import 'package:laathi/features/services/repository/services_repository.dart';

class ChatScreen extends ConsumerStatefulWidget {
  //uid and uname is of the user which is tapped by the current user.
  final String uid, uname;
  static const routeName = '/chat';

  const ChatScreen({super.key, required this.uid, required this.uname});

  @override
  ConsumerState<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends ConsumerState<ChatScreen> {
  final TextEditingController message = TextEditingController();
  final picker = ImagePicker();

  void jump(List<String> value) async {
    await ref
        .read(serviceRepositoryProvider)
        .jumpToPage(widget.uid, value, widget.uname, context, ref, true);
  }

  @override
  void dispose() {
    super.dispose();
    message.dispose();
  }

  bool isTyping = false;

  Widget newBuild() {
    if (!isTyping) {
      return VoiceButton(
        buttonColor: Colors.lightBlue[500],
        buttonSize: 56,
        sendRec: sendMessage,
      );
    } else {
      return FloatingActionButton(
        heroTag: UniqueKey(),
        onPressed: () => {
          setState(() {
            isTyping = false;
          }),
          sendMessage(message.text.trim())
        },
        elevation: 5,
        backgroundColor: Colors.lightBlue[500],
        child: const Icon(
          Icons.send_sharp,
          color: Colors.white,
          size: 18,
        ),
      );
    }
  }

  // Function to send message with to the current chat
  void sendMessage(String value) async {
    if (value.isNotEmpty) {
      await ref
          .read(chatRepositoryProvider)
          .sendMessage(value.trim(), widget.uid);
      message.clear();
    }
  }

  // Function to send message with to the current chat
  void uploadAndSendMessage(String fileType, String filePath) async {
    if (filePath.isNotEmpty) {
      await ref
          .read(chatRepositoryProvider)
          .uploadAndSendMessage(fileType, filePath.trim(), widget.uid);
      message.clear();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 100,
        backgroundColor: Colors.lightBlue.shade100,
        title: Padding(
          padding: const EdgeInsets.only(right: 50.0),
          child: Column(
            children: [
              Text(
                widget.uname,
                style: const TextStyle(color: kPrimaryColor),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(right: 5.0),
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.lightBlueAccent),
                      onPressed: () {},
                      child: const Icon(Icons.call),
                    ),
                  ),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.lightBlueAccent),
                    onPressed: () {},
                    child: const Icon(Icons.video_call),
                  ),
                ],
              )
            ],
          ),
        ),
      ),
      body: GestureDetector(
        onTap: () {
          FocusScope.of(context).requestFocus(FocusNode());
        },
        child: Column(
          children: [
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8.0),
                child: SizedBox(
                  child: Messages(
                    uid: widget.uid,
                    uname: widget.uname,
                  ),
                ),
              ),
            ),

            //message writing bars
            const Divider(
              thickness: 2,
              height: 2.0,
              color: Color.fromARGB(255, 186, 153, 182),
            ),

            SizedBox(
                width: double.infinity,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    ElevatedButton(
                        child: const Icon(Icons.location_pin),
                        onPressed: () => jump(['location'])),
                    ElevatedButton(
                      child: const Icon(Icons.password),
                      onPressed: () async {
                        await ref
                            .watch(smsSharingRepositoryProvider)
                            .fetchMessages(ref, context)
                            .then((value) => jump(value));
                      },
                    ),
                    ElevatedButton(
                      child: const Icon(Icons.document_scanner),
                      onPressed: () {},
                    ),
                    ElevatedButton(
                      child: const Icon(Icons.image),
                      onPressed: () {
                        _showPicker(context: context);
                      },
                    ),
                  ],
                )),

            StatefulBuilder(builder: (context, setState) {
              return Container(
                width: double.infinity,
                padding:
                    const EdgeInsets.symmetric(horizontal: 2.0, vertical: 5.0),
                color: Colors.blue[200],
                child: Row(
                  children: <Widget>[
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 8.0),
                        child: TextField(
                          controller: message,
                          decoration: InputDecoration(
                            fillColor: Colors.white,
                            filled: true,
                            contentPadding: const EdgeInsets.symmetric(
                                vertical: 10.0, horizontal: 15.0),
                            hintText: "Write message...",
                            hintStyle: const TextStyle(color: Colors.black54),
                            border: OutlineInputBorder(
                              borderSide: const BorderSide(
                                  width: 0, style: BorderStyle.none),
                              borderRadius: BorderRadius.circular(25.7),
                            ),
                          ),
                          onSubmitted: (text) {
                            setState(() {
                              isTyping = false;
                            });
                            sendMessage(text);
                          },
                          onChanged: (text) {
                            if (text.isEmpty) {
                              setState(() {
                                isTyping = false;
                              });
                            } else {
                              setState(() {
                                isTyping = true;
                              });
                            }
                          },
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 5.0, vertical: 7.0),
                      child: SizedBox(
                        height: 45.0,
                        child: newBuild(),
                      ),
                    ),
                  ],
                ),
              );
            }),
          ],
        ),
      ),
    );
  }

  void _showPicker({
    required BuildContext context,
  }) {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return SafeArea(
          child: Wrap(
            children: <Widget>[
              ListTile(
                leading: const Icon(Icons.photo_library),
                title: const Text('Photo Library'),
                onTap: () {
                  getImage(ImageSource.gallery);
                  Navigator.of(context).pop();
                },
              ),
              ListTile(
                leading: const Icon(Icons.photo_camera),
                title: const Text('Camera'),
                onTap: () {
                  getImage(ImageSource.camera);
                  Navigator.of(context).pop();
                },
              ),
            ],
          ),
        );
      },
    );
  }

  Future getImage(
    ImageSource img,
  ) async {
    final pickedFile = await picker.pickImage(source: img);
    XFile? xfilePick = pickedFile;
    setState(
      () {
        if (xfilePick != null) {
          uploadAndSendMessage('image', pickedFile!.path);
        } else {
          ScaffoldMessenger.of(context).showSnackBar(// is this context <<<
              const SnackBar(content: Text('Nothing is selected')));
        }
      },
    );
  }
}
