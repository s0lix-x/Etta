import 'package:blogapp/pages/createpage.dart';
import 'package:blogapp/pages/discoverpage.dart';
import 'package:blogapp/pages/feedpage.dart';
import 'package:blogapp/pages/profilepage.dart';
import 'package:flutter/material.dart';
import 'package:persistent_bottom_nav_bar_v2/persistent_bottom_nav_bar_v2.dart';

class BottomBarWidget extends StatefulWidget {
  const BottomBarWidget({super.key});

  @override
  State<BottomBarWidget> createState() => _BottomBarWidgetState();
}

class _BottomBarWidgetState extends State<BottomBarWidget> {
  final controller = PersistentTabController(initialIndex: 0);
  final feedKey = GlobalKey<FeedPageState>();
  final profileKey = GlobalKey<ProfilePageState>();

  List<PersistentTabConfig> _tabs() {
    return [
      PersistentTabConfig(
        screen: FeedPage(key: feedKey),
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
        screen: const DiscoverPage(),
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
        screen: CreatePage(
          onPublished: () {
            feedKey.currentState?.getPosts();
            profileKey.currentState?.getPosts();
            controller.jumpToTab(0);
          },
        ),
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
        screen: ProfilePage(
          key: profileKey,
          onPostsChanged: () => feedKey.currentState?.getPosts(),
        ),
        item: ItemConfig(
          icon: const Icon(Icons.person, size: 24),
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
      controller: controller,
      navBarBuilder: (navBarConfig) =>
          Style1BottomNavBar(navBarConfig: navBarConfig),
    );
  }
}
