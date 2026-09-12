
import 'package:blogapp/pages/feedpage.dart';
import 'package:flutter/material.dart';
import 'package:persistent_bottom_nav_bar_v2/persistent_bottom_nav_bar_v2.dart';


class BottomBarWidget extends StatelessWidget {
  const BottomBarWidget({super.key});

  List<PersistentTabConfig> _tabs() {
    return [
      PersistentTabConfig(
        screen: const FeedPage(),
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
