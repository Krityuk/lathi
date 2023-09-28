import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:otp_timer_button/otp_timer_button.dart';
import 'package:laathi/utils/constants.dart';
import 'package:laathi/features/login/controller/login_controller.dart';

// ignore: must_be_immutable
class OTPScreen extends ConsumerWidget {
  //  Text controller for OTP text field
  TextEditingController otpController = TextEditingController();
  static const routeName = '/otp-screen';
  OTPScreen({Key? key}) : super(key: key);

  //  Verifying OTP in backend
  void verifyOTP(WidgetRef ref, BuildContext context, String userOTP) {
    ref.read(authControllerProvider).verifyOTP(context, userOTP);
  }

  //  Resend OTP in case not received due to some issues
  void resendOTP(WidgetRef ref, BuildContext context) {
    ref.read(authControllerProvider).resendOTP(context);
  }

  void dispose() {
    //  Preventing memory leak
    otpController.dispose();
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: kHeader1,
        elevation: 15.0,
        shadowColor: Colors.black,
        title: Text(
          ' Laathi',
          style: TextStyle(
            shadows: const <Shadow>[
              Shadow(
                offset: Offset(3.0, 3.0),
                blurRadius: 10.0,
                color: Colors.black26,
              ),
            ],
            fontSize: 33,
            fontWeight: FontWeight.w700,
            color: Theme.of(context).colorScheme.onSecondary,
          ),
        ),
        toolbarHeight: 70,
      ),

      //background image [can be changed later]
      body: DecoratedBox(
        decoration: const BoxDecoration(
            // image: DecorationImage(
            //   image: AssetImage("assets/images/background.png"),
            //   fit: BoxFit.cover,
            //   colorFilter: ColorFilter.mode(Colors.white, BlendMode.softLight),
            // ),
            ),
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              children: [
                const Padding(
                  padding: EdgeInsets.all(10.0),
                  child: Text(
                    'Verifying your number',
                    style: TextStyle(
                      color: kHeader1,
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                const Text('We have sent an SMS with a code.'),
                SizedBox(
                  width: size.width * 0.5,
                  child: TextField(
                    textAlign: TextAlign.center,
                    decoration: const InputDecoration(
                      hintText: '- - - - - -',
                    ),
                    keyboardType: TextInputType.number,
                    controller: otpController,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 15),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      // Verify OTP button
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 15),
                        child: ElevatedButton(
                          onPressed: () => verifyOTP(
                              ref, context, otpController.text.trim()),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: kHeader1,
                            shadowColor: const Color.fromARGB(255, 36, 36, 36),
                            elevation: 3.5,
                          ),
                          child: const Text('NEXT'),
                        ),
                      ),
                      // Resend button
                      OtpTimerButton(
                        onPressed: () => resendOTP(ref, context),
                        text: const Text("Resend OTP"),
                        duration: 30,
                        backgroundColor: kHeader1,
                      ),
                    ],
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
