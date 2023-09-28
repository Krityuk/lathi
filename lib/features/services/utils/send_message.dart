import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:laathi/features/companion/Repository/companion_repository.dart';
import 'package:laathi/features/services/repository/services_repository.dart';

// Function to manipulate the messages to a WhatsApp link which in turn will
// be converted to a whatsapp message (for now).

class SendMessage extends ConsumerStatefulWidget {
  // messages[0] indicates the purpose of the list
  // and all the other strings to be sent to the companion.
  final List<String> messages;

  // Checks whether the messages are being from a user to a companion or vice versa
  final bool companionMode;
  static const String routeName = '/send-message';
  const SendMessage(this.messages, this.companionMode, {Key? key})
      : super(key: key);
  @override
  ConsumerState<SendMessage> createState() => _SendMessageScreenState();
}

class _SendMessageScreenState extends ConsumerState<SendMessage> {
  @override
  Widget build(BuildContext context) {
    return SendingContactsList(
      companionMode: widget.companionMode,
      messages: widget.messages,
    );
  }
}

class SendingContactsList extends ConsumerStatefulWidget {
  final bool companionMode;
  final List<String> messages;
  const SendingContactsList({
    super.key,
    required this.messages,
    required this.companionMode,
  });

  @override
  ConsumerState<SendingContactsList> createState() =>
      _SendingContactsListState();
}

class _SendingContactsListState extends ConsumerState<SendingContactsList> {
  bool isLoading = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Choose contact ',
            style: TextStyle(color: Colors.black)),
      ),
      body: Stack(
        children: [
          Visibility(
            visible: isLoading,
            child: const Center(
              child: CircularProgressIndicator(),
            ),
          ),
          Opacity(
            opacity: isLoading ? 0 : 1,
            child: IgnorePointer(
              ignoring: isLoading,
              child: Column(
                children: [
                  Flexible(
                    //  StreamBuilder used to fetch data from Firebase Database
                    child: StreamBuilder(
                      stream: (widget
                              .companionMode) //HERE IS CODE FOR BOTH USER MODE AND COMPANION MODE
                          ? ref
                              .watch(companionRepositoryProvider)
                              .beneficiariesList
                          : ref
                              .watch(companionRepositoryProvider)
                              .providersList,
                      builder: (BuildContext context,
                          AsyncSnapshot<QuerySnapshot> snapshot) {
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return const Center(
                            child: CircularProgressIndicator(),
                          );
                        } else if (snapshot.hasData) {
                          return Padding(
                              padding: const EdgeInsets.all(10),
                              child: GridView(
                                  gridDelegate:
                                      const SliverGridDelegateWithFixedCrossAxisCount(
                                          crossAxisCount: 2),
                                  children: snapshot.data!.docs.map((user) {
                                    String userName = user['name'];
                                    //YE userName is provider's name and userId is providers ID */
                                    String userId = user['id'];
                                    return Container(
                                      margin: const EdgeInsets.symmetric(
                                          horizontal: 5),
                                      padding: const EdgeInsets.symmetric(
                                          vertical: 5),
                                      decoration: BoxDecoration(
                                        border: Border.all(color: Colors.black),
                                        borderRadius: BorderRadius.circular(15),
                                      ),
                                      child: ListTile(
                                        leading: CircleAvatar(
                                          radius: 30,
                                          backgroundColor:
                                              Theme.of(context).primaryColor,
                                          child: Text(
                                            userName
                                                .substring(0, 1)
                                                .toUpperCase(),
                                            textAlign: TextAlign.center,
                                            style: const TextStyle(
                                                color: Colors.white,
                                                fontWeight: FontWeight.w500),
                                          ),
                                        ),
                                        title: Text(userName),
                                        onTap: () async {
                                          // ON doing ontap for one sec isLoading becomes true and then after this read and jumptoPage fn isLoading again becomes false
                                          setState(() {
                                            isLoading = true;
                                            debugPrint(
                                                'provider got tapped here       😎😎😎😎😎😎😎😎');
                                            debugPrint(
                                                '${widget.messages}       😎😎😎😎😎😎😎😎');
                                                debugPrint('       😎😎😎😎😎😎😎😎');
                                          });
                                          await ref
                                              .read(serviceRepositoryProvider)
                                              .jumpToPage(
                                                  userId, //providerID
                                                  widget.messages,
                                                  userName, //providerName
                                                  context,
                                                  ref,
                                                  false);
                                          setState(() {
                                            isLoading = false;
                                          });
                                        },
                                      ),
                                    );
                                  }).toList()));
                        }
                        return Container();
                      },
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
