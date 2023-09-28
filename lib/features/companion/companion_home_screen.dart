import 'package:flutter/material.dart';
import 'package:laathi/features/profile/screens/companion_profile_screen.dart';
import 'package:laathi/features/home/screens/home_bottom_screen.dart';
import 'package:laathi/features/services/utils/send_message.dart';
import 'package:laathi/widgets/icon_widget.dart';
import 'package:laathi/features/user_information/user_information_screen.dart';

class CompanionLandingPage extends StatefulWidget {
  static const routeName = '/companion-landing';
  const CompanionLandingPage({super.key});

  @override
  State<CompanionLandingPage> createState() => _CompanionLandingPageState();
}

class _CompanionLandingPageState extends State<CompanionLandingPage> {
  get set => null;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: <Widget>[
          const Padding(
            padding: EdgeInsets.only(top: 8.0),
            child: Stack(
              alignment: Alignment.topRight,
              children: [
                // IconButton(
                //     color: Colors.white,
                //     iconSize: 30,
                //     icon: Icon(Icons.notifications_active_outlined),
                //     onPressed: () {
                //       Navigator.push(
                //           context,
                //           MaterialPageRoute(
                //               builder: (_) => const NotificationScreen()))
                //           .then((value) {
                //         notif.clear();
                //         set();
                //       });
                //     }),
                // Positioned(
                //   right: 10.0,
                //   top: 5.0,
                //   child: Visibility(
                //     visible: notifNew,
                //     child: Container(
                //       width: 10.0,
                //       height: 10.0,
                //       decoration: const BoxDecoration(
                //         shape: BoxShape.circle,
                //         color: Colors.red,
                //       ),
                //     ),
                //   ),
                // ),
              ],
            ),
          ),
          IconButton(
            color: Colors.white,
            iconSize: 40,
            icon: const Icon(Icons.account_circle),
            onPressed: () => {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (_) => const ProfileScreen(mode: 'companion')))
            },
          ),
        ],
        title: const Text('Companion',
            style: TextStyle(color: Colors.redAccent, fontSize: 30)),
        backgroundColor: Colors.deepPurple,
      ),
      drawer: const CompanionDrawer(),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: GridView.count(
            shrinkWrap: true,
            crossAxisCount: 2,
            crossAxisSpacing: 25.0,
            mainAxisSpacing: 25.0,
            children: [
              CustomIcon(
                iconLabel: 'Location',
                iconPath: 'assets/icons/location.svg',
                iconTitle: 'Location',
                iconColor: Colors.deepPurple,
                functionRoute: SendMessage.routeName,
                //  argument set as a list of string with the zeroth index having
                //  'location' as the value to indicate the location sharing operation
                arguments: const [
                  ['request', 'location'],
                  true
                ],
              ),
              CustomIcon(
                iconLabel: 'OTP',
                iconPath: 'assets/icons/otp.svg',
                iconTitle: 'OTP',
                iconColor: Colors.deepPurple,
                functionRoute: SendMessage.routeName,
                arguments: const [
                  ['request', 'location'],
                  true
                ],
              ),
              CustomIcon(
                iconLabel: 'Medicines',
                iconPath: 'assets/icons/medicine.svg',
                iconTitle: 'Medicines',
                iconColor: Colors.deepPurple,
                // functionRoute: MedicineLandingScreen.routeName,
              ),
              CustomIcon(
                iconLabel: 'Entertainment',
                iconPath: 'assets/icons/entertainment.svg',
                iconTitle: 'Entertainment',
                iconColor: Colors.deepPurple,
                functionRoute: HomeBottomScreen.routeName,
              ),
              CustomIcon(
                iconLabel: 'Orders',
                iconPath: 'assets/icons/order.svg',
                iconTitle: 'Orders',
                iconColor: Colors.deepPurple,
                functionRoute: null,
              ),
              CustomIcon(
                iconLabel: 'Documents',
                iconPath: 'assets/icons/document.svg',
                iconTitle: 'Documents',
                iconColor: Colors.deepPurple,
                functionRoute: null,
              ),
              // LogOutButton();
            ],
          ),
        ),
      ),
    );
  }
}
