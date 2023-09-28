import 'package:flutter/material.dart';
import 'package:laathi/utils/constants.dart';
import 'package:laathi/features/home/utils/user_home_screen_items.dart';

class HomeBottomScreen extends StatefulWidget {
  static const String routeName = '/home-bottom-screen';
  const HomeBottomScreen({Key? key}) : super(key: key);

  @override
  State<HomeBottomScreen> createState() => _HomeBottomScreenState();
}

class _HomeBottomScreenState extends State<HomeBottomScreen> {
  //  Page variable for managing the home page on the click of bottom nav bar item.
  int _page = 1;

  //  pageController used to scroll around the pages of bottom nav bar
  PageController pageController = PageController(initialPage: 1);
  @override
  void dispose() {
    super.dispose();
    //  Preventing memory leak
    pageController.dispose();
  }


  void navigationTapped(int page) {
    pageController.jumpToPage(page);
  }

  void onPageChanged(int page) {
    setState(() {
      _page = page;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      //PageView Widget is used to move around pages in using bottom nav bar
      body: PageView(
        // User should only be able to access page by tapping on buttons and not scrolling
        physics: const NeverScrollableScrollPhysics(),
        controller: pageController,
        onPageChanged: onPageChanged,
        children: userHomeScreenItems,
      ),
      backgroundColor: Colors.white70,
      bottomNavigationBar: BottomNavigationBar(
        onTap: navigationTapped,
        currentIndex: _page,
        iconSize: 50,
        // backgroundColor: kDarkBlue,
        unselectedItemColor: kHeader2,
        selectedItemColor: kDarkBlue,
        unselectedLabelStyle: const TextStyle(fontSize: 20),
        selectedLabelStyle: const TextStyle(fontSize: 20),
        items: const [
          BottomNavigationBarItem(
            icon: Icon(
              Icons.support,
            ),
            label: 'SoS',
          ),
          BottomNavigationBarItem(
            icon: Icon(
              Icons.home_filled,
            ),
            label: "Home",
          ),
          BottomNavigationBarItem(
              icon: Icon(
                Icons.chat,
              ),
              label: 'Chat'),
        ],
      ),
    );
  }
}
