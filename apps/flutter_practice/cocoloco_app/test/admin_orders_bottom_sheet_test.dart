import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:cocoloco_app/widgets/admin_orders_bottom_sheet.dart';
import 'package:cocoloco_app/core/providers/network_providers.dart';
import 'package:cocoloco_app/data/repositories/order_repository.dart';
import 'package:cocoloco_app/models/order.dart';

class MockOrderRepository extends OrderRepository {
  final List<OrderModel> orders;
  MockOrderRepository({this.orders = const []});

  @override
  Future<List<OrderModel>> getAllOrders() async {
    return orders;
  }

  @override
  Future<bool> updateOrderStatus(String orderId, String newStatus) async {
    return true;
  }
}

void main() {
  final testOrder = OrderModel(
    id: 'ord_12345678',
    userId: 'usr_test',
    status: 'PENDING',
    totalAmount: 18.50,
    createdAt: DateTime(2026, 1, 1),
    items: const [
      OrderItemModel(
        id: 'item_1',
        productId: 'prod_1',
        productName: 'Caramel Macchiato',
        quantity: 2,
        unitPrice: 9.25,
        totalPrice: 18.50,
      ),
    ],
  );

  Widget createWidgetUnderTest(List<OrderModel> orders) {
    return ProviderScope(
      overrides: [
        orderRepositoryProvider.overrideWithValue(MockOrderRepository(orders: orders)),
      ],
      child: const MaterialApp(
        home: Scaffold(
          body: AdminOrdersBottomSheet(),
        ),
      ),
    );
  }

  testWidgets('AdminOrdersBottomSheet displays title, admin hub badge, and empty state', (tester) async {
    await tester.pumpWidget(createWidgetUnderTest([]));
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 100));

    expect(find.text('All Store Orders'), findsOneWidget);
    expect(find.text('ADMIN HUB'), findsOneWidget);
    expect(find.text('No active orders waiting. All caught up!'), findsOneWidget);
  });

  testWidgets('AdminOrdersBottomSheet renders orders with status dropdown', (tester) async {
    await tester.pumpWidget(createWidgetUnderTest([testOrder]));
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 100));

    expect(find.text('All Store Orders'), findsOneWidget);
    expect(find.textContaining('ORD_1234'), findsOneWidget);
    expect(find.textContaining('18.50'), findsOneWidget);
    expect(find.text('Pending'), findsOneWidget);
    expect(find.text('2x Caramel Macchiato'), findsOneWidget);
  });
}
