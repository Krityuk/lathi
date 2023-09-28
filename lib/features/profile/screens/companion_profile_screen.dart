import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:laathi/features/login/controller/login_controller.dart';
import 'package:laathi/repository/app_repository.dart';
import 'package:laathi/features/home/screens/home_bottom_screen.dart';

class CompanionDrawer extends ConsumerWidget {
  const CompanionDrawer({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Drawer(
      child: SafeArea(
        child: Column(
          children: [
            // const InfoCard(
            //   name: "User",
            //   contact: "+91 9813652730",
            // ),
            UserAccountsDrawerHeader(
              accountName: const Text(
                'User',
                style: TextStyle(color: Colors.black, fontSize: 20),
              ),
              accountEmail: Text(
                ref.watch(appRepositoryProvider).currentUser!.phoneNumber!,
                style: const TextStyle(color: Colors.black, fontSize: 20),
              ),
              currentAccountPicture: CircleAvatar(
                child: ClipOval(
                  child: Image.asset(
                    'assets/images/avatar.jpeg',
                    width: 90,
                    height: 90,
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              decoration: const BoxDecoration(
                  color: Colors.blue,
                  image: DecorationImage(
                    image: AssetImage('assets/images/profile_background.jpeg'),
                    fit: BoxFit.cover,
                  )),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 24, top: 32, bottom: 16),
              child: Text(
                "Accesebility".toUpperCase(),
                style: Theme.of(context).textTheme.titleMedium,
              ),
            ),

            Column(
              children: [
                const Padding(
                  padding: EdgeInsets.only(left: 24),
                  child: Divider(
                    height: 1,
                  ),
                ),
                ListTile(
                  leading: const Icon(Icons.security),
                  title: const Text('User Mode'),
                  onTap: () {
                    Navigator.pushReplacementNamed(
                        context, HomeBottomScreen.routeName);
                  },
                ),
                ListTile(
                  leading: const Icon(Icons.person_add),
                  title: const Text('Add Companion'),
                  // onTap: () {
                  //   Navigator.pushNamed(context, AddCompanionScreen.routeName);
                  // },
                  trailing: ClipOval(
                      child: Container(
                    color: Colors.lightBlueAccent,
                    width: 20,
                    height: 20,
                    child: const Center(
                      child: Text(
                        '2',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 12,
                        ),
                      ),
                    ),
                  )),
                ),
                ListTile(
                  leading: const Icon(Icons.dns),
                  title: const Text('History'),
                  onTap: () {},
                ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.only(left: 24, top: 32, bottom: 16),
              child: Text(
                "System Settings".toUpperCase(),
                style: Theme.of(context).textTheme.titleMedium,
              ),
            ),
            Column(
              children: [
                const Padding(
                  padding: EdgeInsets.only(left: 24),
                  child: Divider(
                    height: 1,
                  ),
                ),
                ListTile(
                  leading: const Icon(Icons.settings),
                  title: const Text('Settings'),
                  onTap: () {},
                ),
                ListTile(
                  leading: const Icon(Icons.logout),
                  title: const Text('LogOut'),
                  onTap: () async =>
                      ref.watch(authControllerProvider).logOutUser(context),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
