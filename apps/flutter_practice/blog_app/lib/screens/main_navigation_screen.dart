import 'package:flutter/material.dart';
import '../widgets/custom_bottom_nav_bar.dart';
import 'create_post_screen.dart';
import 'feed_screen.dart';
import 'profile_screen.dart';

class MainNavigationScreen extends StatefulWidget {
  const MainNavigationScreen({super.key});

  @override
  State<MainNavigationScreen> createState() => _MainNavigationScreenState();
}

class _MainNavigationScreenState extends State<MainNavigationScreen> {
  int _currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    final List<Widget> screens = [
      FeedScreen(onOpenCreatePost: () => setState(() => _currentIndex = 2)),
      const Center(child: Text('Explore Categories')),
      CreatePostScreen(onPostCreated: () => setState(() => _currentIndex = 0)),
      const Center(child: Text('Saved Bookmarks')),
      const ProfileScreen(),
    ];

    return Scaffold(
      body: Stack(
        children: [
          IndexedStack(
            index: _currentIndex,
            children: screens,
          ),
          Positioned(
            left: 0,
            right: 0,
            bottom: 0,
            child: CustomBottomNavBar(
              currentIndex: _currentIndex,
              onIndexChanged: (index) {
                setState(() => _currentIndex = index);
              },
            ),
          ),
        ],
      ),
    );
  }
}
