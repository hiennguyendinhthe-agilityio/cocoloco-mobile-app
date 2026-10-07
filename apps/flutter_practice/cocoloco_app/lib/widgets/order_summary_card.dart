import 'package:flutter/material.dart';
import '../core/localization/app_localizations.dart';
import '../core/theme/app_theme.dart';

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
    final l10n = context.l10n;
    return Column(
      children: [
        const SizedBox(height: AppSpacing.sm),
        _buildCostRow(
          context: context,
          label: l10n.subtotal,
          amount: '\$${subtotal.toInt()}',
          isTotal: false,
        ),
        const SizedBox(height: AppSpacing.sm),
        _buildCostRow(
          context: context,
          label: l10n.deliveryFee,
          amount: '\$${deliveryFee.toInt()}',
          isTotal: false,
        ),
        const Padding(
          padding: EdgeInsets.symmetric(vertical: AppSpacing.sm),
          child: Divider(),
        ),
        _buildCostRow(
          context: context,
          label: l10n.total,
          amount: '\$${total.toInt()}',
          isTotal: true,
        ),
      ],
    );
  }

  Widget _buildCostRow({
    required BuildContext context,
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
            color: context.colorScheme.onSurfaceVariant,
          ),
        ),
        Text(
          amount,
          style: TextStyle(
            fontFamily: AppTypography.fontFamily,
            fontSize: isTotal ? 17.5 : 16,
            fontWeight: isTotal ? FontWeight.w900 : FontWeight.w800,
            color: context.colorScheme.primary,
          ),
        ),
      ],
    );
  }
}
