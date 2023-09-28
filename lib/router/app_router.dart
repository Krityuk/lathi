import 'package:flutter/material.dart';
import 'package:laathi/features/history/screens/history_screen.dart';
import 'package:laathi/features/home/screens/home_bottom_screen.dart';
import 'package:laathi/features/login/utils/login_status.dart';
import 'package:laathi/features/services/screens/confirm_screen.dart';
import 'package:laathi/features/wishbox/screens/wishbox_screen.dart';
import 'package:laathi/widgets/error_widget.dart';
import 'package:laathi/features/login/screens/permission_screen.dart';
import 'package:laathi/features/login/screens/otp_screen.dart';
import 'package:laathi/features/login/screens/number_screen.dart';
import 'package:laathi/features/chat/screens/chat_select_screen.dart';
import 'package:laathi/features/chat/screens/chat_companion_screen.dart';
import 'package:laathi/features/companion/screens/add_companion_screen.dart';
import 'package:laathi/features/companion/companion_home_screen.dart';
import 'package:laathi/features/medicine_reminder/screens/medicine_home_screen.dart';
import 'package:laathi/features/services/screens/services_screen.dart';
import 'package:laathi/features/services/utils/send_message.dart';

//  Switch casing the routes

//  Each screen class has a static String variable called routeName
//  which is used for pushing Named routes

Route<dynamic> generateRoute(RouteSettings settings) {
  switch (settings.name) {
    case LoginScreen.routeName:
      return MaterialPageRoute(
        builder: (_) => const LoginScreen(),
      );
    case OTPScreen.routeName:
      return MaterialPageRoute(builder: (_) => OTPScreen());
    // case OTPShareScreen.routeName:
    //   return MaterialPageRoute(builder: (_) => const OTPShareScreen());
    case AddCompanionScreen.routeName:
      return MaterialPageRoute(builder: (_) => const AddCompanionScreen());
    case HomeBottomScreen.routeName:
      return MaterialPageRoute(builder: (_) => const HomeBottomScreen());
    case MedicineLandingScreen.routeName:
      return MaterialPageRoute(builder: (_) => const MedicineLandingScreen());
    case ServicesScreen.routeName:
      return MaterialPageRoute(builder: (_) => const ServicesScreen());
    case PermissionsPage.routeName:
      return MaterialPageRoute(builder: (_) => const PermissionsPage());
    case LoginStatusChecker.routeName:
      return MaterialPageRoute(builder: (_) => const LoginStatusChecker());
    case CompanionLandingPage.routeName:
      return MaterialPageRoute(builder: (_) => const CompanionLandingPage());
    case ConfirmScreen.routeName:
      var args = settings.arguments as List<Object?>;
      var newA = args[0] as List<String>;
      var lastmsg = args[2] as List<String>;
      return MaterialPageRoute(
          builder: (_) => ConfirmScreen(
              userId: newA[0],
              userName: newA[1],
              location: newA[2],
              information: lastmsg.toString(),
              type: newA[3],
              isChat: args[1] as bool));
    case ChatScreen.routeName:
      var args = settings.arguments as List<String>;
      return MaterialPageRoute(
          builder: (_) => ChatScreen(uid: args[0], uname: args[1]));
    case ChatHomeScreen.routeName:
      return MaterialPageRoute(builder: (_) => const ChatHomeScreen());
    case SendMessage.routeName:
      final args = settings.arguments as List<Object?>;
      return MaterialPageRoute(
          builder: (_) =>
              SendMessage(args[0]! as List<String>, args[1]! as bool));
    case WishboxRecorderScreen.routeName:
      return MaterialPageRoute(builder: (_) => const WishboxRecorderScreen());
    case LogsScreen.routeName:
      return MaterialPageRoute(builder: (_) => const LogsScreen());
    //  default route in case of any error!
    default:
      return MaterialPageRoute(
        builder: (_) => const Scaffold(
          body: ErrorScreen(error: 'This page does not exist'),
        ),
      );
  }
}
