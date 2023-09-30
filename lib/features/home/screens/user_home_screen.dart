import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:laathi/features/notification/models/notification_model.dart';
import 'package:laathi/features/wishbox/screens/wishbox_screen.dart';
import 'package:laathi/utils/constants.dart';
import 'package:laathi/features/notification/screens/notification_screen.dart';
import 'package:laathi/features/profile/screens/profile_screen.dart';
import 'package:laathi/features/login/controller/login_controller.dart';
import 'package:laathi/widgets/icon_widget.dart';
import 'package:laathi/features/services/screens/services_screen.dart';
import 'package:laathi/features/user_information/user_information_screen.dart';

//Log out user function
void logOut(WidgetRef ref, BuildContext context) {
  ref.read(authControllerProvider).logOutUser(context);
}

class UserHomeScreen extends StatefulWidget {
  const UserHomeScreen({super.key});
  @override
  // ignore: library_private_types_in_public_api
  _UserHomeScreenState createState() => _UserHomeScreenState();
}

class _UserHomeScreenState extends State<UserHomeScreen> {
  int index = 0;
  List<Widget> list = [const ServicesScreen()];

  void set() {
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: <Widget>[
          Padding(
            padding: const EdgeInsets.only(top: 8.0),
            child: Stack(
              alignment: Alignment.topRight,
              children: [
                IconButton(
                    color: Colors.white,
                    iconSize: 30,
                    icon: const Icon(Icons.notifications_active_outlined),
                    onPressed: () {
                      Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (_) => const NotificationScreen()))
                          .then((value) {
                        notif.clear();
                        set();
                      });
                    }),
                Positioned(
                  right: 10.0,
                  top: 5.0,
                  child: Visibility(
                    visible: notifNew,
                    child: Container(
                      width: 10.0,
                      height: 10.0,
                      decoration: const BoxDecoration(
                        shape: BoxShape.circle,
                        color: Colors.red,
                      ),
                    ),
                  ),
                ),
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
                      builder: (_) => const ProfileScreen(mode: 'user')))
            },
          ),
        ],
        title: const Text('Laathi',
            style: TextStyle(color: Colors.white, fontSize: 30)),
        backgroundColor: kHeader1,
      ),
      //********************************************************************* */
      //********************************************************************* */
      //********************************************************************* */
      drawer: const MyDrawer(),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: GridView.count(
            shrinkWrap: true,
            crossAxisCount: 2,
            crossAxisSpacing: 25.0,
            mainAxisSpacing: 25.0,
            children: [
              //
              CustomIcon(
                iconLabel: 'Services',
                iconPath: 'assets/icons/services.svg',
                iconTitle: 'Services',
                functionRoute: ServicesScreen.routeName,
                callback: set,
              ),
              CustomIcon(
                iconLabel: 'Record',
                iconPath: 'assets/icons/record.svg',
                iconTitle: 'Record',
                functionRoute: WishboxRecorderScreen.routeName,
              ),
              CustomIcon(
                iconLabel: 'Entertainment',
                iconPath: 'assets/icons/entertainment.svg',
                iconTitle: 'Entertainment',
                functionRoute: '',
              ),
              CustomIcon(
                iconLabel: 'Order',
                iconPath: 'assets/icons/order.svg',
                iconTitle: 'Orders',
                functionRoute: '',
              ),
              // LogOutButton();
            ],
          ),
        ),
      ),
    );
  }
}
