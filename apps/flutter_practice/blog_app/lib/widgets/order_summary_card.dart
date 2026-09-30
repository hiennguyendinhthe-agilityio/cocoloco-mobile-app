import 'package:flutter/material.dart';
import '../core/theme/app_colors.dart';
import '../core/theme/app_typography.dart';

class OrderSummaryCard extends StatelessWidget {
  final double subtotal;
  final double deliveryFee;
  final double total;

  const OrderSummaryCard({
    super.key,
    required this.subtotal,
    required this.deliveryFee,
    required this.total,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const SizedBox(height: 10),
        _buildCostRow(
          label: 'Subtotal',
          amount: '\$${subtotal.toInt()}',
          isTotal: false,
        ),
        const SizedBox(height: 10),
        _buildCostRow(
          label: 'Delivery',
          amount: '\$${deliveryFee.toInt()}',
          isTotal: false,
        ),
        const Padding(
          padding: EdgeInsets.symmetric(vertical: 8),
          child: Divider(color: Color(0xFFF1ECE4), thickness: 1),
        ),
        _buildCostRow(
          label: 'Total',
          amount: '\$${total.toInt()}',
          isTotal: true,
        ),
      ],
    );
  }

  Widget _buildCostRow({
    required String label,
    required String amount,
    required bool isTotal,
  }) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: isTotal ? 15.5 : 15,
            fontWeight: isTotal ? FontWeight.w600 : FontWeight.w500,
            color: const Color(0xFFA59E96),
          ),
        ),
        Text(
          amount,
          style: TextStyle(
            fontFamily: AppTypography.fontFamily,
            fontSize: isTotal ? 17.5 : 16,
            fontWeight: isTotal ? FontWeight.w900 : FontWeight.w800,
            color: AppColors.primary,
          ),
        ),
      ],
    );
  }
}
