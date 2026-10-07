import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:cocoloco_app/core/localization/app_localizations.dart';
import 'package:cocoloco_app/core/providers/network_providers.dart';
import 'package:cocoloco_app/core/services/session_service.dart';
import 'package:cocoloco_app/data/repositories/order_repository.dart';
import 'package:cocoloco_app/models/order.dart';
import 'package:cocoloco_app/models/user_profile.dart';
import 'package:cocoloco_app/screens/orders_screen.dart';

class MockOrderRepoForScreen extends OrderRepository {
  List<OrderModel> ordersToReturn;

  MockOrderRepoForScreen({this.ordersToReturn = const []});

  @override
  Future<List<OrderModel>> getMyOrders() async {
    return ordersToReturn;
  }
}

void main() {
  late MockOrderRepoForScreen mockRepo;

  final sampleOrders = [
    OrderModel(
      id: 'ord-test-1111',
      userId: 'usr-1',
      status: 'PENDING',
      totalAmount: 12.50,
      createdAt: DateTime(2026, 10, 5, 8, 30),
      items: const [
        OrderItemModel(
          id: 'item-1',
          productId: 'prod-1',
          productName: 'Iced Vanilla Latte',
          quantity: 2,
          unitPrice: 5.0,
          totalPrice: 10.0,
        ),
      ],
    ),
    OrderModel(
      id: 'ord-test-2222',
      userId: 'usr-1',
      status: 'COMPLETED',
      totalAmount: 4.50,
      createdAt: DateTime(2026, 10, 4, 15, 00),
      items: const [
        OrderItemModel(
          id: 'item-2',
          productId: 'prod-2',
          productName: 'Pain au Chocolat',
          quantity: 1,
          unitPrice: 4.5,
          totalPrice: 4.5,
        ),
      ],
    ),
  ];

  setUp(() {
    SharedPreferences.setMockInitialValues({});
    mockRepo = MockOrderRepoForScreen(ordersToReturn: sampleOrders);
  });

  tearDown(() async {
    await SessionService.instance.logout();
  });

  Widget createOrdersScreen() {
    return ProviderScope(
      overrides: [
        orderRepositoryProvider.overrideWithValue(mockRepo),
      ],
      child: const MaterialApp(
        supportedLocales: AppLocalizations.supportedLocales,
        localizationsDelegates: [
          AppLocalizations.delegate,
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
        ],
        home: OrdersScreen(),
      ),
    );
  }

  group('OrdersScreen Widget Tests', () {
    testWidgets('Guest State: renders login prompt when not logged in', (tester) async {
      await SessionService.instance.logout();

      await tester.pumpWidget(createOrdersScreen());
      await tester.pumpAndSettle();

      expect(find.text('Your Orders'), findsOneWidget);
      expect(find.text('Guest'), findsOneWidget);
      expect(find.text('Log in to view orders'), findsOneWidget);
    });

    testWidgets('Empty State: renders empty illustration when logged in with 0 orders', (tester) async {
      await SessionService.instance.loginAs(AppRole.user);
      mockRepo.ordersToReturn = [];

      await tester.pumpWidget(createOrdersScreen());
      await tester.pumpAndSettle();

      expect(find.text('No orders yet'), findsOneWidget);
      expect(find.text('0 orders'), findsOneWidget);
    });

    testWidgets('Populated State: renders list of orders and status chips', (tester) async {
      await SessionService.instance.loginAs(AppRole.user);
      mockRepo.ordersToReturn = sampleOrders;

      await tester.pumpWidget(createOrdersScreen());
      await tester.pumpAndSettle();

      // Check header and orders count
      expect(find.text('Your Orders'), findsOneWidget);
      expect(find.text('2 orders'), findsOneWidget);

      // Check order details with quantity prefix
      expect(find.text('2x Iced Vanilla Latte'), findsOneWidget);
      expect(find.text('1x Pain au Chocolat'), findsOneWidget);
      expect(find.text('\$12.50'), findsOneWidget);
      expect(find.text('\$4.50'), findsNWidgets(2));
    });

    testWidgets('Filter Chips: filtering by Pending status shows only pending order', (tester) async {
      await SessionService.instance.loginAs(AppRole.user);
      mockRepo.ordersToReturn = sampleOrders;

      await tester.pumpWidget(createOrdersScreen());
      await tester.pumpAndSettle();

      // Tap Pending filter chip
      final pendingChip = find.text('⏳ Pending');
      expect(pendingChip, findsOneWidget);
      await tester.tap(pendingChip);
      await tester.pumpAndSettle();

      // Only pending order should be visible
      expect(find.text('2x Iced Vanilla Latte'), findsOneWidget);
      expect(find.text('1x Pain au Chocolat'), findsNothing);
    });

    testWidgets('Pull to refresh triggers refresh of orders', (tester) async {
      await SessionService.instance.loginAs(AppRole.user);
      mockRepo.ordersToReturn = sampleOrders;

      await tester.pumpWidget(createOrdersScreen());
      await tester.pumpAndSettle();

      // Pull down to refresh
      await tester.fling(find.byType(ListView).last, const Offset(0, 300), 1000);
      await tester.pumpAndSettle();

      expect(find.text('2x Iced Vanilla Latte'), findsOneWidget);
    });
  });
}
