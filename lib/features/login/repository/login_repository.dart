import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
// import 'package:laathi/features/login/screens/number_screen.dart';
import 'package:laathi/utils/show_bar.dart';

import 'package:laathi/repository/app_repository.dart';
import 'package:laathi/features/login/screens/permission_screen.dart';
import 'package:laathi/features/login/screens/otp_screen.dart';
import 'package:laathi/features/home/screens/home_bottom_screen.dart';
import 'package:laathi/features/login/utils/login_status.dart';

// Auth Repository Provider
final authRepositoryProvider = Provider((ref) => AuthRepository(
    auth: FirebaseAuth.instance,
    firestore: FirebaseFirestore.instance,
    databaseRepository: ref.watch(appRepositoryProvider)));

//  Repository for auth functions

class AuthRepository {
  final FirebaseAuth auth;
  final FirebaseFirestore firestore;
  final AppRepository databaseRepository;
  //  Firebase variables for phone log in
  //    Verification ID is used in the verify OTP function
  String _verificationId = "";
  String _phone = "";
  //    resend token is used in the resend OTP function
  int? _resendToken;
  AuthRepository({
    required this.databaseRepository,
    required this.auth,
    required this.firestore,
  });

  User? get currentUser => auth.currentUser;

  void resendOTP(BuildContext context) async {
    signInWithPhone(context, _phone, true);
  }

  // Firebase function to sign in with phone and get an otp on your device
  //  boolean resend is true if otp is resent
  void signInWithPhone(BuildContext context, String phone, bool resend) async {
    try {
      await auth.verifyPhoneNumber(
        phoneNumber: phone,
        verificationCompleted: (credential) async {
          await auth.signInWithCredential(credential);
        },
        //  In case of any error
        verificationFailed: (e) {
          showSnackBar(context: context, content: e.toString());
        },
        //  Function to call once the code is sent
        codeSent: (String verificationId, int? resendToken) async {
          _resendToken = resendToken;
          _verificationId = verificationId;
          if (resend) {
            Navigator.pop(context);
          } else {
            _phone = phone;
          }

          Navigator.pushNamed(
            context,
            OTPScreen.routeName,
          );
        },
        forceResendingToken: _resendToken,
        codeAutoRetrievalTimeout: (String verificationId) {
          _verificationId = verificationId;
        },
      );
    } catch (e) {
      showSnackBar(context: context, content: e.toString());
    }
  }

  //  Firebase function to verify the OTP put by the user
  void verifyOTP(BuildContext context, String userOTP) async {
    try {
      PhoneAuthCredential cred = PhoneAuthProvider.credential(
          verificationId: _verificationId, smsCode: userOTP);

      // Go the the "Permissions" screen if the user is logged in Successfully
      await auth.signInWithCredential(cred).then((_) async {
        String flag = await databaseRepository.getUserId(_phone);
        if (flag != "") {
          // ignore: use_build_context_synchronously
          Navigator.pushReplacementNamed(context, HomeBottomScreen.routeName);
        } else {
          await databaseRepository.registerUser(auth.currentUser!, "fullName");
          // ignore: use_build_context_synchronously
          Navigator.pushNamedAndRemoveUntil(
            context,
            PermissionsPage.routeName,
            (route) => false,
          );
        }
        // set current user to database for to fetch all the details from the cloud
        databaseRepository.loginCurrentUser();
      });
    } catch (e) {
      showSnackBar(context: context, content: e.toString());
    }
  }

  // Logging out and going to the Login screen
  Future logOutUser(BuildContext context) async {
    try {
      await auth.signOut().then((_) {
        // Navigator.pushReplacementNamed(context, LoginStatusChecker.routeName);
        Navigator.of(context).pushNamedAndRemoveUntil(
            LoginStatusChecker.routeName, (route) => false);
        databaseRepository.logoutCurrentUser();
      });
    } catch (e) {
      showSnackBar(context: context, content: e.toString());
    }
  }
}
