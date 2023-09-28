import 'package:country_picker/country_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:laathi/utils/show_bar.dart';
import 'package:laathi/features/companion/controller/companion_controller.dart';
import 'package:laathi/features/home/screens/home_bottom_screen.dart';

class AddCompanionScreen extends ConsumerStatefulWidget {
  static const routeName = '/add-companion';
  const AddCompanionScreen({Key? key}) : super(key: key);
  @override
  ConsumerState<AddCompanionScreen> createState() => _AddCompScreenState();
}

class _AddCompScreenState extends ConsumerState<AddCompanionScreen> {
  //  text controllers for phone and name text fields
  final phoneController = TextEditingController();
  final nameController = TextEditingController();

  //  Country for country phone code
  Country country = Country(phoneCode: "91", countryCode: "IN", e164Sc: 0, geographic: true, level: 1, name: "India", example: "9123456789", displayName: "India (IN) [+91]", displayNameNoCountryCode: "India (IN)", e164Key: "91-IN-0");


  @override
  void dispose() {
    super.dispose();
    //  Preventing memory leak
    phoneController.dispose();
    nameController.dispose();
  }

  //  Country Picker
  void pickCountry() {
    showCountryPicker(
        context: context,
        onSelect: (Country c) {
          setState(() {
            country = c;
          });
        });
  }

  // Adding companion for the user
  void addCompanion() async {
    String phone = "+${country.phoneCode}${phoneController.text.trim()}";
    String name = nameController.text.trim();
    if (phone.isNotEmpty && name.isNotEmpty) {
      await ref.watch(companionControllerProvider).setCompanion(name, phone, context);
      jumpToHomeScreen();
    } else {
      showSnackBar(context: context, content: 'Fill out all the fields!');
    }
  }

  void jumpToHomeScreen(){
    Navigator.pushReplacementNamed(context, HomeBottomScreen.routeName);
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
      resizeToAvoidBottomInset: false, //to avoid pixel limit exceeding

      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.secondary,
        elevation: 15.0,
        shadowColor: Colors.black,
        title: Text(
          'Laathi',
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
      body: GestureDetector(
        onTap: () {
          FocusScope.of(context).requestFocus(FocusNode());
        },
        child: DecoratedBox(
          decoration: const BoxDecoration(
            image: DecorationImage(
              image: AssetImage("assets/images/background.png"),
              fit: BoxFit.cover,
              colorFilter: ColorFilter.mode(Colors.white, BlendMode.softLight),
            ),
          ),
          child: Padding(
            padding:
                const EdgeInsets.symmetric(vertical: 30.0, horizontal: 20.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(top: 5.0, bottom: 40.0),
                      child: Text(
                        'Add a Companion',
                        style: TextStyle(
                          color: Theme.of(context).colorScheme.primary,
                          fontSize: 30,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    const Padding(
                      padding: EdgeInsets.symmetric(horizontal: 10.0),
                      child: Row(children: [
                        Text(
                          "Enter name",
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 18.0,
                          ),
                        ),
                      ]),
                    ),
                    Row(
                      children: [
                        Padding(
                          padding:
                              const EdgeInsets.only(left: 10.0, bottom: 30.0),
                          child: SizedBox(
                            width: size.width * 0.7,
                            child: TextField(
                              focusNode: FocusNode(),
                              controller: nameController,
                              decoration: const InputDecoration(
                                hintText: 'name',
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 10.0),
                      child: Row(children: [
                        const Text(
                          "Enter number",
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 18.0,
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 20.0),
                          child: TextButton(
                            onPressed: pickCountry,
                            child: const Text('Pick Country'),
                          ),
                        ),
                      ]),
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
                              focusNode: FocusNode(),
                              controller: phoneController,
                              keyboardType: TextInputType.phone,
                              decoration: const InputDecoration(
                                hintText: 'phone number',
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                Row(
                  children: [
                    SizedBox(
                      width: 90,
                      child: Padding(
                        padding: const EdgeInsets.only(top: 50.0, bottom: 50.0),
                        child: ElevatedButton(
                          onPressed:  () async => addCompanion(),
                          style: ElevatedButton.styleFrom(
                            shadowColor: const Color.fromARGB(255, 36, 36, 36),
                            elevation: 3.5,
                          ),
                          child: const Text('NEXT'),
                        ),
                      ),
                    ),
                    SizedBox(
                      width: 90,
                      child: Padding(
                        padding: const EdgeInsets.only(top: 50.0, bottom: 50.0),
                        child: ElevatedButton(
                          onPressed: jumpToHomeScreen,
                          style: ElevatedButton.styleFrom(
                            shadowColor: const Color.fromARGB(255, 36, 36, 36),
                            elevation: 3.5,
                          ),
                          child: const Text('SKIP'),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
