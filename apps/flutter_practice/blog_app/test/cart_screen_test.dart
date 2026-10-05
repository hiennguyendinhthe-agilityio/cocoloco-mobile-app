import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:blog_app/core/constants/mock_data.dart';
import 'package:blog_app/core/localization/app_localizations.dart';
import 'package:blog_app/core/services/session_service.dart';
import 'package:blog_app/core/theme/app_theme.dart';
import 'package:blog_app/core/providers/network_providers.dart';
import 'package:blog_app/data/providers/cart_provider.dart';
import 'package:blog_app/data/repositories/order_repository.dart';
import 'package:blog_app/models/order.dart';
import 'package:blog_app/models/user_profile.dart';
import 'package:blog_app/screens/cart_screen.dart';
import 'package:blog_app/screens/order_success_screen.dart';
import 'package:blog_app/screens/product_detail_screen.dart';
import 'package:blog_app/widgets/order_summary_card.dart';

class MockCartOrderRepository extends OrderRepository {
  @override
  Future<OrderModel> createOrder({required List<Map<String, dynamic>> items}) async {
    return OrderModel(
      id: 'ord-test-success',
      userId: 'usr-1',
      status: 'PENDING',
      totalAmount: 10.0,
      createdAt: DateTime.now(),
      items: const [],
    );
  }

  @override
  Future<List<OrderModel>> getMyOrders() async {
    return [];
  }
}

void main() {
  setUp(() {
    SharedPreferences.setMockInitialValues({});
  });

  tearDown(() async {
    await SessionService.instance.logout();
  });

  final testProduct1 = MockData.dailyProducts[0]; // Capuchino
  final testProduct2 = MockData.dailyProducts[1]; // Fruit Market Bowl

  Widget createCartTestWidget({ProviderContainer? container}) {
    final cont = container ??
        ProviderContainer(
          overrides: [
            orderRepositoryProvider.overrideWithValue(MockCartOrderRepository()),
          ],
        );
    return UncontrolledProviderScope(
      container: cont,
      child: MaterialApp(
        theme: AppTheme.lightTheme,
        supportedLocales: AppLocalizations.supportedLocales,
        localizationsDelegates: const [
          AppLocalizations.delegate,
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
        ],
        home: const CartScreen(),
      ),
    );
  }

  group('CartScreen Swipe-to-Dismiss & Edit-Flow Tests', () {
    testWidgets('renders all items, subtotals, and Go to checkout button',
        (tester) async {
      final container = ProviderContainer();
      container.read(cartProvider.notifier).addProduct(testProduct1, quantity: 2);
      container.read(cartProvider.notifier).addProduct(testProduct2, quantity: 2);

      await tester.pumpWidget(createCartTestWidget(container: container));
      await tester.pumpAndSettle();

      // Verify header and items
      expect(find.text('Your Cart'), findsOneWidget);
      expect(find.text(testProduct1.name), findsOneWidget);
      expect(find.text(testProduct2.name), findsOneWidget);
      expect(find.text('2x'), findsNWidgets(2));

      // Subtotal: 2*3 + 2*3 = 12, Delivery: 2, Total: 14
      expect(find.text(r'$12'), findsOneWidget);
      expect(find.text(r'$2'), findsOneWidget);
      expect(find.text(r'$14'), findsOneWidget);
      expect(find.text('Go to checkout'), findsOneWidget);

      container.dispose();
    });

    testWidgets('Swipe to delete item removes it and displays SnackBar with Undo',
        (tester) async {
      final container = ProviderContainer();
      container.read(cartProvider.notifier).addProduct(testProduct1, quantity: 2);
      container.read(cartProvider.notifier).addProduct(testProduct2, quantity: 1);

      await tester.pumpWidget(createCartTestWidget(container: container));
      await tester.pumpAndSettle();

      expect(find.text(testProduct1.name), findsOneWidget);
      expect(find.text(testProduct2.name), findsOneWidget);

      // Swipe Dismissible on testProduct1 (drag from right to left)
      await tester.drag(find.text(testProduct1.name), const Offset(-500, 0));
      await tester.pumpAndSettle();

      // testProduct1 should be dismissed and removed from cart state
      expect(find.text(testProduct1.name), findsNothing);
      expect(find.text(testProduct2.name), findsOneWidget);
      expect(container.read(cartProvider).items.length, equals(1));

      // SnackBar with Undo action should appear
      expect(find.text('${testProduct1.name} removed from cart'), findsOneWidget);
      expect(find.text('Undo'), findsOneWidget);

      container.dispose();
    });

    testWidgets('Tapping Undo in SnackBar restores the deleted item at original position',
        (tester) async {
      final container = ProviderContainer();
      container.read(cartProvider.notifier).addProduct(testProduct1, quantity: 2);
      container.read(cartProvider.notifier).addProduct(testProduct2, quantity: 1);

      await tester.pumpWidget(createCartTestWidget(container: container));
      await tester.pumpAndSettle();

      // Swipe to delete testProduct1
      await tester.drag(find.text(testProduct1.name), const Offset(-500, 0));
      await tester.pumpAndSettle();
      expect(find.text(testProduct1.name), findsNothing);

      // Tap "Undo" on SnackBar
      await tester.tap(find.text('Undo'));
      await tester.pumpAndSettle();

      // testProduct1 must be restored in the UI and in Provider state
      expect(find.text(testProduct1.name), findsOneWidget);
      expect(find.text(testProduct2.name), findsOneWidget);
      expect(container.read(cartProvider).items.length, equals(2));
      expect(container.read(cartProvider).items[0].name, equals(testProduct1.name));
      expect(container.read(cartProvider).items[0].quantity, equals(2));

      container.dispose();
    });

    testWidgets('Tapping on a cart item opens ProductDetailScreen in edit mode',
        (tester) async {
      final container = ProviderContainer();
      container.read(cartProvider.notifier).addProduct(testProduct1, quantity: 2);

      await tester.pumpWidget(createCartTestWidget(container: container));
      await tester.pumpAndSettle();

      // Tap on the testProduct1 cart card
      await tester.tap(find.text(testProduct1.name));
      await tester.pumpAndSettle();

      // Should have navigated to ProductDetailScreen
      expect(find.byType(ProductDetailScreen), findsOneWidget);
      // In edit mode with existing item, button should say 'Update Cart'
      expect(find.text('Update Cart'), findsOneWidget);
      // Quantity is 2x
      expect(find.text('2x'), findsWidgets);

      container.dispose();
    });

    testWidgets('When all items are removed, CartScreen displays empty state',
        (tester) async {
      final container = ProviderContainer();
      container.read(cartProvider.notifier).addProduct(testProduct1, quantity: 1);

      await tester.pumpWidget(createCartTestWidget(container: container));
      await tester.pumpAndSettle();

      expect(find.text(testProduct1.name), findsOneWidget);

      // Dismiss the only item
      await tester.drag(find.text(testProduct1.name), const Offset(-500, 0));
      await tester.pumpAndSettle();

      // Empty state is rendered
      expect(find.text('Your cart is empty'), findsOneWidget);
      expect(find.byType(OrderSummaryCard), findsNothing);
      final checkoutBtn =
          tester.widget<ElevatedButton>(find.byType(ElevatedButton));
      expect(checkoutBtn.onPressed, isNull);

      container.dispose();
    });

    testWidgets('Tapping back button pops CartScreen when route is on top',
        (tester) async {
      await tester.pumpWidget(
        ProviderScope(
          child: MaterialApp(
            home: Scaffold(
              body: Builder(
                builder: (context) => ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (_) => const CartScreen()),
                    );
                  },
                  child: const Text('Open Cart'),
                ),
              ),
            ),
          ),
        ),
      );
      await tester.pumpAndSettle();

      await tester.tap(find.text('Open Cart'));
      await tester.pumpAndSettle();

      expect(find.byType(CartScreen), findsOneWidget);

      final backButton = find.byIcon(Icons.arrow_back_rounded);
      expect(backButton, findsOneWidget);
      await tester.tap(backButton);
      await tester.pumpAndSettle();

      expect(find.byType(CartScreen), findsNothing);
    });

    testWidgets('Logged in checkout flow navigates to OrderSuccessScreen',
        (tester) async {
      await SessionService.instance.loginAs(AppRole.user);

      final container = ProviderContainer(
        overrides: [
          orderRepositoryProvider.overrideWithValue(MockCartOrderRepository()),
        ],
      );
      container.read(cartProvider.notifier).addProduct(testProduct1, quantity: 2);

      await tester.pumpWidget(createCartTestWidget(container: container));
      await tester.pumpAndSettle();

      // Tap Go to checkout
      final checkoutButton = find.widgetWithText(ElevatedButton, 'Go to checkout');
      expect(checkoutButton, findsOneWidget);
      await tester.tap(checkoutButton);
      await tester.pumpAndSettle();

      // Should have navigated to OrderSuccessScreen
      expect(find.byType(OrderSuccessScreen), findsOneWidget);

      container.dispose();
      await SessionService.instance.logout();
    });
  });
}
