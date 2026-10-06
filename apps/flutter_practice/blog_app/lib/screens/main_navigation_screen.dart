import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../data/providers/orders_provider.dart';
import '../widgets/cocoloco_bottom_nav_bar.dart';
import 'browse_screen.dart';
import 'favorites_screen.dart';
import 'orders_screen.dart';
import 'chat_screen.dart';

class MainNavigationScreen extends ConsumerStatefulWidget {
  const MainNavigationScreen({super.key});

  @override
  ConsumerState<MainNavigationScreen> createState() => _MainNavigationScreenState();
}

class _MainNavigationScreenState extends ConsumerState<MainNavigationScreen> {
  int _currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    final List<Widget> screens = const [
      BrowseScreen(),
      FavoritesScreen(),
      OrdersScreen(),
      ChatScreen(),
    ];

    return Scaffold(
      extendBody: false,
      body: IndexedStack(
        index: _currentIndex,
        children: screens,
      ),
      bottomNavigationBar: CocolocoBottomNavBar(
        currentIndex: _currentIndex,
        onIndexChanged: (index) {
          ScaffoldMessenger.of(context).hideCurrentSnackBar();
          setState(() {
            _currentIndex = index;
          });
          if (index == 2) {
            ref.read(ordersProvider.notifier).loadOrders();
          }
        },
      ),
    );
  }
}
