// import 'package:flutter/material.dart';
// import 'package:flutter_riverpod/flutter_riverpod.dart';
// import 'package:flutter_sms_inbox/flutter_sms_inbox.dart';
// import 'package:laathi/utils/constants.dart';
// import 'package:laathi/features/sms_sharing/controller/sms_sharing_controller.dart';
// import 'package:laathi/features/services/utils/send_message.dart';

// class SmsShareScreen extends ConsumerStatefulWidget {
//   static const String routeName = '/SMS-share';
//   const SmsShareScreen({Key? key}) : super(key: key);

//   @override
//   ConsumerState<SmsShareScreen> createState() => _SmsShareScreenState();
// }

// class _SmsShareScreenState extends ConsumerState<SmsShareScreen> {
// //  Fetches messages from the phone to be displayed on the screen
//   Future<SmsMessage> fetchMessages(
//       WidgetRef ref, BuildContext context) async {
//     SmsMessage? smsMessages =
//         await ref.watch(smsSharingControllerProvider).fetchLastSms(context);
//     return smsMessages!;
//     // return smsMessages;
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       //background image [can be changed later]
//       appBar: AppBar(
//         title: const Text('Retrieving Messages ',
//             style: TextStyle(color: Colors.black)),
//       ),
//       body: SafeArea(
//         child: Padding(
//           padding: const EdgeInsets.all(25),
//           child: Column(
//             mainAxisSize: MainAxisSize.max,
//             mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//             children: [
//               Text("The retrieved messages are:",
//                   textAlign: TextAlign.center,
//                   style: Theme.of(context).textTheme.headlineMedium!.copyWith(
//                         fontSize: 50,
//                       )),
//               Center(
//                 child: FutureBuilder(
//                     future: fetchMessages(ref, context),
//                     builder:
//                         (context, AsyncSnapshot<List<SmsMessage>> snapshot) {
//                       return (snapshot.hasData)
//                           ? Column(
//                               mainAxisSize: MainAxisSize.min,
//                               children: [
//                                 ListView.builder(
//                                   shrinkWrap: true,
//                                   itemBuilder: (context, index) => Center(
//                                     child: Padding(
//                                       padding: const EdgeInsets.symmetric(
//                                           vertical: 15),
//                                       child: SizedBox(
//                                         width:
//                                             MediaQuery.of(context).size.width,
//                                         child: Text(
//                                           "${snapshot.data![index].sender!} - \n${snapshot.data![index].body!}",
//                                           style: kFontStyle,
//                                           maxLines: 4,
//                                           overflow: TextOverflow.ellipsis,
//                                         ),
//                                       ),
//                                     ),
//                                   ),
//                                   itemCount: snapshot.data!.length,
//                                 ),
//                                 ElevatedButton(
//                                     onPressed: () {
//                                       List<String> infoList = ['otp messages'];
//                                       for (int i = 0; i < 1; i++) {
//                                         infoList.add(snapshot.data![i].sender!);
//                                         infoList.add(snapshot.data![i].body!);
//                                       }
//                                       Navigator.push(
//                                         context,
//                                         MaterialPageRoute(
//                                           builder: (context) =>
//                                               SendMessage(infoList, false),
//                                         ),
//                                       );
//                                     },
//                                     child: const Text('Send')),
//                               ],
//                             )
//                           : const Center(
//                               child: CircularProgressIndicator(),
//                             );
//                     }),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }
