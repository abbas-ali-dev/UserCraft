import 'package:flutter/material.dart';
import 'package:persistent_bottom_nav_bar/persistent_bottom_nav_bar.dart';
import 'package:usercraft/view/home_screen/home_screen.dart';
import 'package:usercraft/view/profile_screen/profile_screen.dart';

class BottomTabs extends StatelessWidget {
  const BottomTabs({super.key});

  @override
  build(BuildContext context) {
    PersistentTabController controller =
        PersistentTabController(initialIndex: 0);

    List<Widget> screens = [
      const HomeScreen(),
      const ProfileScreen(),
    ];

    List<PersistentBottomNavBarItem> navBarItems = [
      PersistentBottomNavBarItem(
        icon: const Icon(Icons.home),
        title: 'Home',
        activeColorPrimary: Colors.black,
        inactiveColorPrimary: Colors.grey,
      ),
      PersistentBottomNavBarItem(
        icon: const Icon(Icons.person),
        title: 'Profile',
        activeColorPrimary: Colors.black,
        inactiveColorPrimary: Colors.grey,
      ),
    ];

    return PersistentTabView(
      context,
      controller: controller,
      screens: screens,
      navBarHeight: kBottomNavigationBarHeight,
      items: navBarItems,
      backgroundColor: Color(0XFFffd21f),
      handleAndroidBackButtonPress: true,
      resizeToAvoidBottomInset: true,
      hideNavigationBarWhenKeyboardAppears: false,
      stateManagement: true,
      decoration: NavBarDecoration(
        colorBehindNavBar: Colors.white,
      ),
      navBarStyle: NavBarStyle.style1,
    );
  }
}
