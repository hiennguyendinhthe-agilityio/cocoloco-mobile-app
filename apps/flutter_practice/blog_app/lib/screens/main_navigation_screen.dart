import 'package:flutter/material.dart';
import '../widgets/cocoloco_bottom_nav_bar.dart';
import 'browse_screen.dart';
import 'cart_screen.dart';
import 'favorites_screen.dart';
import 'orders_screen.dart';
import 'profile_screen.dart';

class MainNavigationScreen extends StatefulWidget {
  const MainNavigationScreen({super.key});

  @override
  State<MainNavigationScreen> createState() => _MainNavigationScreenState();
}

class _MainNavigationScreenState extends State<MainNavigationScreen> {
  int _currentIndex = 0;
  final List<String> _cartTitles = [];
  double _totalAmount = 0.0;

  void _addToCart(String title, double price) {
    setState(() {
      _cartTitles.add(title);
      _totalAmount += price;
    });
  }

  void _clearCart() {
    setState(() {
      _cartTitles.clear();
      _totalAmount = 0.0;
    });
  }

  @override
  Widget build(BuildContext context) {
    final List<Widget> screens = [
      BrowseScreen(
        onAddToCart: _addToCart,
      ),
      FavoritesScreen(
        onAddToCart: _addToCart,
      ),
      CartScreen(
        onCheckout: _clearCart,
      ),
      OrdersScreen(
        cartItems: _cartTitles,
        totalAmount: _totalAmount,
        onClearCart: _clearCart,
      ),
      const ProfileScreen(),
    ];

    return Scaffold(
      extendBody: true,
      body: IndexedStack(
        index: _currentIndex,
        children: screens,
      ),
      bottomNavigationBar: CocolocoBottomNavBar(
        currentIndex: _currentIndex,
        cartItemCount: _cartTitles.length,
        onIndexChanged: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
      ),
    );
  }
}
