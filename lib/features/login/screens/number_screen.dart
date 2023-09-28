import 'package:country_picker/country_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:laathi/utils/constants.dart';
import 'package:laathi/utils/show_bar.dart';
import 'package:laathi/features/login/controller/login_controller.dart';

class LoginScreen extends ConsumerStatefulWidget {
  static const routeName = '/login-screen';
  const LoginScreen({Key? key}) : super(key: key);
  @override
  ConsumerState<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends ConsumerState<LoginScreen> {
  //  Text field controller for phone number
  final phoneController = TextEditingController();
  // Country to be used for country code( initially India)
  Country country = Country(
      phoneCode: "91",
      countryCode: "IN",
      e164Sc: 0,
      geographic: true,
      level: 1,
      name: "India",
      example: "9123456789",
      displayName: "India (IN) [+91]",
      displayNameNoCountryCode: "India (IN)",
      e164Key: "91-IN-0");
  @override
  void dispose() {
    super.dispose();
    //  Preventing memory leak
    phoneController.dispose();
  }

  //  Country picker function
  void pickCountry() {
    showCountryPicker(
        context: context,
        onSelect: (c) {
          setState(() {
            country = c;
          });
        });
  }

  //  Backend function for sending phone number to go to the OTP screen
  void sendPhoneNumber(BuildContext context) {
    loadingDialogBox(context, 'Validating details'); //! I added this line here
    String phoneNumber = phoneController.text.trim();
    // ignore: avoid_print
    print(phoneNumber);
    if (phoneNumber.isNotEmpty && phoneNumber.length == 10) {
      ref
              .read(authControllerProvider)
              .sendOTP(context, '+${country.phoneCode}$phoneNumber')
          // .then((result) {
          // try {
          //   debugPrint('Successful popped       😎😎😎😎😎😎😎😎');
          //   Navigator.of(context).pop();
          //   Navigator.of(context).pop();
          // } catch (e) {
          //   debugPrint('$e       😎😎😎😎😎😎😎😎');
          // }
          // })
          ;
    } else {
      Navigator.of(context).pop(); //!pop up the loadingDialogBox
      showSnackBar(
          context: context, content: 'Fill out all the fields properly!');
    }
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
      resizeToAvoidBottomInset: false, //to avoid pixel limit exceeding

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
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 30.0, horizontal: 20.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Column(
                children: [
                  const Padding(
                    padding: EdgeInsets.all(5.0),
                    child: Text(
                      'Enter your phone number',
                      style: TextStyle(
                        color: kHeader1,
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  const Text("Laathi will need to verify your phone number."),
                  TextButton(
                    onPressed: pickCountry,
                    child: const Text(
                      'Pick Country',
                      style: TextStyle(color: kHeader1),
                    ),
                  ),
                  Row(
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(top: 2.5),
                        child: Text('+${country.phoneCode}'),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: 10.0),
                        child: SizedBox(
                          width: size.width * 0.7,
                          child: TextField(
                            controller: phoneController,
                            decoration: const InputDecoration(
                              hintText: 'phone number',
                            ),
                            keyboardType: TextInputType.phone,
                            maxLength: 10,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              SizedBox(
                width: 90,
                child: Padding(
                  padding: const EdgeInsets.only(top: 50.0),
                  child: ElevatedButton(
                    onPressed: () {
                      sendPhoneNumber(context);
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: kHeader1,
                      shadowColor: const Color.fromARGB(255, 36, 36, 36),
                      elevation: 3.5,
                    ),
                    child: const Text('NEXT'),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
