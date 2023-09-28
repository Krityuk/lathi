import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:geolocator/geolocator.dart';
import 'package:laathi/features/notification/models/notification_model.dart';
import 'package:laathi/features/services/screens/confirm_screen.dart';

final serviceRepositoryProvider = Provider((ref) => ServiceRepository());

class ServiceRepository {
  Future jumpToPage(String userId, List<String> messages, String userName,
      BuildContext context, WidgetRef ref, bool chat) async {
    debugPrint('$messages  its coming here 😎😎');
    await _send(userId, messages, userName, context, ref).then((value) {
      debugPrint('$value     it is value  😎😎😎😎😎😎😎😎');
      Navigator.pushNamed(context, ConfirmScreen.routeName,
          arguments: [value,chat,messages]);
    });
  }

  Future<List<String>> _send(String userId, List<String> messages,
      String userName, BuildContext context, WidgetRef ref) async {
    String informationToSend = "";
    List<String> type = messages[0].split(" ");
    switch (type[0]) {
      //REQUESTING
      case 'request':
        informationToSend = "Please send me the ${type[1]}";
        notifAdd("Requested for ${type[1]}", userName);
        break;

      //LOCATION SHARING
      case 'location':
        // cannot share location without device location permission
        await Geolocator.requestPermission();
        //coordinates of the user
        Position position = await Geolocator.getCurrentPosition(
            desiredAccuracy: LocationAccuracy.high);
        informationToSend +=
            "https://www.google.com/maps/search/?api=1%26query=${position.latitude},${position.longitude}";
        break;

      //  OTP MESSAGES SHARING
      case 'otp':
        informationToSend = 'OTP SENDER:- ${messages[1]}\n\n ${messages[2]}';
        break;
    }
    debugPrint('$informationToSend       😎😎😎');
    return [userId, userName, informationToSend, messages[0]];
  }
}
