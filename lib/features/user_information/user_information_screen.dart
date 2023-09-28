import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:laathi/features/user_information/information.dart';
import 'package:laathi/utils/constants.dart';
import 'package:laathi/repository/app_repository.dart';

class ProfileScreen extends ConsumerStatefulWidget {
  static const String routeName = '/profile';
  final String mode;
  const ProfileScreen({Key? key, required this.mode}) : super(key: key);
  @override
  ConsumerState<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends ConsumerState<ProfileScreen> {
  final String username = 'user';
  late String phoneNumber =
      ref.watch(appRepositoryProvider).currentUser!.phoneNumber!;
  final String profilePic = 'assets/images/profile_background.jpeg';
  late Color bg = widget.mode == 'user'
      ? const Color.fromARGB(255, 73, 138, 171)
      : const Color.fromARGB(255, 88, 72, 118);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: widget.mode == 'user' ? kHeader1 : Colors.deepPurple,
        toolbarHeight: 80.0,
        title: const Text('Profile', style: TextStyle(color: Colors.white)),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Container(
              decoration: BoxDecoration(
                  color: Colors.blue,
                  image: DecorationImage(
                    image: AssetImage(profilePic),
                    fit: BoxFit.cover,
                  )),
              child: Stack(
                children: [
                  SizedBox(
                    height: 130,
                    width: double.infinity,
                    child: Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: CircleAvatar(
                        child: ClipOval(
                          child: Image.asset(
                            'assets/images/avatar.jpeg',
                            width: 90,
                            height: 90,
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                    ),
                  ),
                  Align(
                    alignment: Alignment.bottomRight,
                    child: Padding(
                      padding: const EdgeInsets.only(right: 5.0, top: 80.0),
                      child: ElevatedButton(
                        onPressed: () {},
                        style: ElevatedButton.styleFrom(
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(18.0)),
                            backgroundColor: bg),
                        child: const Icon(
                          Icons.edit,
                          size: 25,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 28, right: 3.0, top: 40),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ProfileInfo(
                      heading: 'Username',
                      entry: username,
                      mode: widget.mode,
                      toChange: () {}),
                  ProfileInfo(
                      heading: 'Phone Number',
                      entry: phoneNumber,
                      mode: widget.mode,
                      toChange: () {}),
                ],
              ),
            )
          ]),
          Padding(
            padding:
                const EdgeInsets.symmetric(horizontal: 10.0, vertical: 40.0),
            child: ListTile(
              leading: Icon(
                Icons.security,
                size: 40.0,
                color: bg,
              ),
              title: Text('Complete KYC',
                  style: TextStyle(
                      fontSize: 20, fontWeight: FontWeight.bold, color: bg)),
            ),
          ),
        ],
      ),
    );
  }
}
