import 'package:firebase_auth/firebase_auth.dart' show User;
import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart' show Provider;
import 'package:laathi/features/login/repository/login_repository.dart';

// Auth Controller Provider
final authControllerProvider = Provider(
  (ref) => AuthController(
    authRepository: ref.watch(authRepositoryProvider),
  ),
);


//  Controller for auth functions
class AuthController {
  final AuthRepository authRepository;
  AuthController({
    required this.authRepository,
  });
   sendOTP(BuildContext context, String phone) {
     authRepository.signInWithPhone(context, phone, false);
  }
  void resendOTP(BuildContext context){
    authRepository.resendOTP(context);
  }
  void verifyOTP(BuildContext context, String userOTP){
    authRepository.verifyOTP(context, userOTP);
  }
  User? get currentUser => authRepository.currentUser;
  Future logOutUser(BuildContext context) async {
    await authRepository.logOutUser(context);
  }
}
