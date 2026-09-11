
import 'package:flutter/material.dart';
import 'package:persistent_bottom_nav_bar_v2/persistent_bottom_nav_bar_v2.dart';


class BottomBarWidget extends StatelessWidget {
  const BottomBarWidget({super.key});

  List<PersistentTabConfig> _tabs() {
    return [
      PersistentTabConfig(
        screen: const HomePage(),
        item: ItemConfig(
          icon: const Icon(Icons.menu_book_outlined, size: 24),
          title: "FEED",
          activeForegroundColor: const Color(0xffb84a2a),
          inactiveForegroundColor: const Color(0xff666666),
          textStyle: const TextStyle(
            fontSize: 11,
            fontWeight: FontWeight.w500,
            letterSpacing: 1,
          ),
        ),
      ),
      PersistentTabConfig(
        screen: const MessagePage(),
        item: ItemConfig(
          icon: const Icon(Icons.explore_outlined, size: 24),
          title: "DISCOVER",
          activeForegroundColor: const Color(0xffb84a2a),
          inactiveForegroundColor: const Color(0xff666666),
          textStyle: const TextStyle(
            fontSize: 11,
            fontWeight: FontWeight.w500,
            letterSpacing: 1,
          ),
        ),
      ),
      PersistentTabConfig(
        screen: const SearchPage(),
        item: ItemConfig(
          icon: const Icon(Icons.edit_outlined, size: 24),
          title: "WRITE",
          activeForegroundColor: const Color(0xffb84a2a),
          inactiveForegroundColor: const Color(0xff666666),
          textStyle: const TextStyle(
            fontSize: 11,
            fontWeight: FontWeight.w500,
            letterSpacing: 1,
          ),
        ),
      ),
      PersistentTabConfig(
        screen: const NotificationPage(),
        item: ItemConfig(
          icon: const Icon(Icons.grid_view_outlined, size: 24),
          title: "CATEGORIES",
          activeForegroundColor: const Color(0xffb84a2a),
          inactiveForegroundColor: const Color(0xff666666),
          textStyle: const TextStyle(
            fontSize: 11,
            fontWeight: FontWeight.w500,
            letterSpacing: 1,
          ),
        ),
      ),
      PersistentTabConfig(
        screen: const ProfilePage(),
        item: ItemConfig(
          icon: const Icon(Icons.person_outline, size: 24),
          title: "PROFILE",
          activeForegroundColor: const Color(0xffb84a2a),
          inactiveForegroundColor: const Color(0xff666666),
          textStyle: const TextStyle(
            fontSize: 11,
            fontWeight: FontWeight.w500,
            letterSpacing: 1,
          ),
        ),
      ),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return PersistentTabView(
      tabs: _tabs(),
      navBarBuilder: (navBarConfig) => Style1BottomNavBar(
        navBarConfig: navBarConfig,
      ),
    );
  }
}
