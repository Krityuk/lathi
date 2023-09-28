import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:laathi/features/login/screens/number_screen.dart';
import 'package:laathi/utils/constants.dart';
import 'package:laathi/features/home/screens/home_bottom_screen.dart';

class LoginStatusChecker extends StatefulWidget {
  static const String routeName = '/login-status-checker';
  const LoginStatusChecker({
    super.key,
  });

  @override
  State<LoginStatusChecker> createState() => _LoginStatusCheckerState();
}

class _LoginStatusCheckerState extends State<LoginStatusChecker> {
  @override
  Widget build(BuildContext context) {
    //  StreamBuilder used for checking if firebase auth has any user logged in or not
    return StreamBuilder(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.active) {
          // IN case of an error
          if (snapshot.hasError) {
            return Center(
              child: Text('${snapshot.error}'),
            );
            //  In case of success
          } else if (snapshot.hasData) {
            return const HomeBottomScreen(); //THIS is the main screen
          }
        }

        // CIRCULAR progress indicator to be displayed while the connection is being set up
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(
            child: CircularProgressIndicator(
              color: kPrimaryColor,
            ),
          );
          // IN case no auth user is found, we return login screen to log in one
        } else {
          return const LoginScreen();
        }
      },
    );
  }
}
