import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../core/localization/app_localizations.dart';
import '../core/services/session_service.dart';
import '../core/theme/app_theme.dart';
import '../data/repositories/order_repository.dart';
import '../models/order.dart';
import '../models/user_profile.dart';
import 'admin_products_screen.dart';
import 'clerk_webview_screen.dart';
import 'settings_screen.dart';

class ProfileScreen extends ConsumerStatefulWidget {
  const ProfileScreen({super.key});

  @override
  ConsumerState<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends ConsumerState<ProfileScreen> {
  final SessionService _session = SessionService.instance;
  final OrderRepository _orderRepo = OrderRepository();

  @override
  void initState() {
    super.initState();
    _session.addListener(_onSessionChanged);
  }

  @override
  void dispose() {
    _session.removeListener(_onSessionChanged);
    super.dispose();
  }

  void _onSessionChanged() {
    if (mounted) setState(() {});
  }

  Future<void> _handleClerkLogin() async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => const ClerkWebViewScreen()),
    );
    if (!mounted || result == null) return;

    String token;
    String? email;
    String? fullName;
    String? avatarUrl;

    if (result is ClerkAuthResult) {
      token = result.token;
      email = result.email;
      fullName = result.fullName;
      avatarUrl = result.avatarUrl;
    } else if (result is String) {
      token = result;
    } else {
      return;
    }

    if (token.isEmpty) return;

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            SizedBox(
              width: 20,
              height: 20,
              child: CircularProgressIndicator(color: context.colorScheme.onPrimary, strokeWidth: 2),
            ),
            const SizedBox(width: 12),
            const Text('Syncing with Cocoloco system...'),
          ],
        ),
        backgroundColor: context.colorScheme.primary,
        duration: const Duration(seconds: 10),
      ),
    );

    final success = await SessionService.instance.loginWithClerkToken(
      token,
      email: email,
      fullName: fullName,
      avatarUrl: avatarUrl,
    );
    if (!mounted) return;

      ScaffoldMessenger.of(context).hideCurrentSnackBar();
      if (success) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Row(
              children: [
                Icon(Icons.check_circle_rounded, color: AppPalette.pureWhite),
                const SizedBox(width: 10),
                const Text('Signed in and synced successfully!'),
              ],
            ),
            backgroundColor: AppPalette.emeraldGreen,
          ),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: const Text('Sync failed. Please try again.'),
            backgroundColor: context.colorScheme.error,
          ),
        );
      }
  }

  void _openAdminOrdersManager() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: context.colorScheme.surface,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
      ),
      builder: (ctx) {
        return DraggableScrollableSheet(
          initialChildSize: 0.85,
          maxChildSize: 0.95,
          minChildSize: 0.5,
          expand: false,
          builder: (_, scrollController) {
            return FutureBuilder<List<OrderModel>>(
              future: _orderRepo.getAllOrders(),
              builder: (context, snapshot) {
                final orders = snapshot.data ?? [];
                return Padding(
                  padding: const EdgeInsets.fromLTRB(20, 8, 20, 24),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'All Store Orders',
                            style: TextStyle(
                              fontFamily: AppTypography.fontFamily,
                              fontSize: 20,
                              fontWeight: FontWeight.w800,
                              color: context.colorScheme.onSurface,
                            ),
                          ),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                            decoration: BoxDecoration(
                              color: context.colorScheme.primary,
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Text(
                              'ADMIN HUB',
                              style: TextStyle(fontSize: 11, fontWeight: FontWeight.w800, color: context.colorScheme.onPrimary),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 6),
                      Text(
                        'Tap a status button to quickly update order lifecycle',
                        style: TextStyle(fontSize: 13, color: context.colorScheme.onSurfaceVariant),
                      ),
                      Divider(height: 24, color: context.colorScheme.outlineVariant),
                      Expanded(
                        child: snapshot.connectionState == ConnectionState.waiting
                            ? Center(child: CircularProgressIndicator(color: context.colorScheme.primary))
                            : orders.isEmpty
                                ? const Center(child: Text('No orders yet.'))
                                : ListView.separated(
                                    controller: scrollController,
                                    itemCount: orders.length,
                                    separatorBuilder: (_, _) => const SizedBox(height: 12),
                                    itemBuilder: (context, index) {
                                      final ord = orders[index];
                                      return _buildAdminOrderRow(ord, () {
                                        Navigator.pop(ctx);
                                        _openAdminOrdersManager();
                                      });
                                    },
                                  ),
                      ),
                    ],
                  ),
                );
              },
            );
          },
        );
      },
    );
  }

  Widget _buildAdminOrderRow(OrderModel ord, VoidCallback onRefresh) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: context.colorScheme.surfaceContainerHighest,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: context.colorScheme.outlineVariant),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                '${ord.shortId} • \$${ord.totalAmount.toStringAsFixed(2)}',
                style: TextStyle(fontWeight: FontWeight.w800, fontSize: 15, color: context.colorScheme.onSurface),
              ),
              PopupMenuButton<String>(
                initialValue: ord.status,
                onSelected: (newStatus) async {
                  await _orderRepo.updateOrderStatus(ord.id, newStatus);
                  onRefresh();
                },
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(
                    color: ord.statusBgColor,
                    borderRadius: BorderRadius.circular(14),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        ord.statusLabel,
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w700,
                          color: ord.statusTextColor,
                        ),
                      ),
                      const SizedBox(width: 4),
                      Icon(Icons.arrow_drop_down, size: 16, color: ord.statusTextColor),
                    ],
                  ),
                ),
                itemBuilder: (context) => const [
                  PopupMenuItem(value: 'PENDING', child: Text('⏳ PENDING (Pending)')),
                  PopupMenuItem(value: 'CONFIRMED', child: Text('☕ CONFIRMED (Brewing)')),
                  PopupMenuItem(value: 'COMPLETED', child: Text('✅ COMPLETED (Done)')),
                  PopupMenuItem(value: 'CANCELLED', child: Text('❌ CANCELLED (Cancelled)')),
                ],
              ),
            ],
          ),
          const SizedBox(height: 6),
          Text(
            ord.items.map((i) => '${i.quantity}x ${i.productName}').join(', '),
            style: TextStyle(fontSize: 13, color: context.colorScheme.onSurfaceVariant),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }

  void _showComingSoon(String feature) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('$feature feature coming soon!'),
        backgroundColor: context.colorScheme.primary,
        duration: const Duration(seconds: 2),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final role = _session.role;
    final user = _session.user;
    final bool isLoggedIn = role != AppRole.guest;
    final l10n = context.l10n;

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: BackButton(color: context.colorScheme.onSurface),
        centerTitle: true,
        title: Text(
          l10n.cocolocoAccount,
          style: TextStyle(
            fontFamily: AppTypography.fontFamily,
            fontSize: 18,
            fontWeight: FontWeight.w800,
            color: context.colorScheme.onSurface,
          ),
        ),
        actions: [
          IconButton(
            icon: Icon(
              Icons.settings_outlined,
              color: context.colorScheme.onSurface,
              size: 24,
            ),
            tooltip: l10n.settingsAndUtilities,
            onPressed: () {
              Navigator.push(
                context,
                CupertinoPageRoute(
                  builder: (_) => const SettingsScreen(),
                ),
              );
            },
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          padding: const EdgeInsets.fromLTRB(20, 8, 20, 36),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // 1. User Profile Card
              _buildProfileCard(isLoggedIn, role, user),

              const SizedBox(height: 20),

              // 2. Loyalty Rewards Card (If Logged In)
              if (isLoggedIn) ...[
                _buildLoyaltyCard(role),
                const SizedBox(height: 20),
              ],

              // 3. Admin Hub Banner (Strictly Admin only)
              if (role == AppRole.admin) ...[
                _buildAdminBanner(),
                const SizedBox(height: 20),
              ],

              // 4. Section: Orders & Payments
              _buildSectionHeader(l10n.ordersAndTransactions),
              _buildMenuCard([
                _buildMenuItem(
                  icon: Icons.receipt_long_outlined,
                  title: l10n.orderHistory,
                  subtitle: l10n.orderHistorySub,
                  onTap: () {
                    _showComingSoon(l10n.orderHistory);
                  },
                ),
                _buildDivider(),
                _buildMenuItem(
                  icon: Icons.location_on_outlined,
                  title: l10n.savedAddresses,
                  subtitle: l10n.savedAddressesSub,
                  onTap: () => _showComingSoon(l10n.savedAddresses),
                ),
                _buildDivider(),
                _buildMenuItem(
                  icon: Icons.credit_card_outlined,
                  title: l10n.paymentMethods,
                  subtitle: l10n.paymentMethodsSub,
                  onTap: () => _showComingSoon(l10n.paymentMethods),
                ),
                _buildDivider(),
                _buildMenuItem(
                  icon: Icons.confirmation_number_outlined,
                  title: l10n.vouchersAndOffers,
                  subtitle: l10n.vouchersSub,
                  badge: '2 NEW',
                  badgeColor: AppPalette.amberOrange,
                  onTap: () => _showComingSoon(l10n.vouchersAndOffers),
                ),
              ]),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildProfileCard(bool isLoggedIn, AppRole role, UserProfile? user) {
    final avatarUrl = user?.avatarUrl;
    final hasAvatar = isLoggedIn && avatarUrl != null && avatarUrl.isNotEmpty;
    final theme = Theme.of(context);
    final cocolocoColors = context.cocolocoTheme;

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: context.colorScheme.surface,
        borderRadius: BorderRadius.circular(26),
        boxShadow: [
          BoxShadow(
            color: theme.shadowColor.withValues(alpha: 0.05),
            blurRadius: 18,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Column(
        children: [
          Row(
            children: [
              Container(
                width: 64,
                height: 64,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: role == AppRole.admin
                        ? [context.colorScheme.primary, AppPalette.burgundy700]
                        : isLoggedIn
                            ? [context.colorScheme.primary, AppPalette.burgundy600]
                            : [context.colorScheme.surfaceContainerHighest, context.colorScheme.outlineVariant],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: role == AppRole.admin
                          ? context.colorScheme.primary.withValues(alpha: 0.3)
                          : theme.shadowColor.withValues(alpha: 0.12),
                      blurRadius: 10,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: ClipOval(
                  child: hasAvatar
                      ? Image.network(
                          avatarUrl,
                          width: 64,
                          height: 64,
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) => Center(
                            child: Icon(
                              role == AppRole.admin
                                  ? Icons.admin_panel_settings_rounded
                                  : Icons.person_rounded,
                              size: 32,
                              color: isLoggedIn ? context.colorScheme.onPrimary : context.colorScheme.onSurfaceVariant,
                            ),
                          ),
                        )
                      : Center(
                          child: Icon(
                            role == AppRole.admin
                                ? Icons.admin_panel_settings_rounded
                                : isLoggedIn
                                    ? Icons.person_rounded
                                    : Icons.person_outline_rounded,
                            size: 32,
                            color: isLoggedIn ? context.colorScheme.onPrimary : context.colorScheme.onSurfaceVariant,
                          ),
                        ),
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      isLoggedIn ? (user?.fullName ?? 'Cocoloco Member') : context.l10n.welcomeToCocoloco,
                      style: TextStyle(
                        fontFamily: AppTypography.fontFamily,
                        fontSize: 18,
                        fontWeight: FontWeight.w800,
                        color: context.colorScheme.onSurface,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 4),
                    Text(
                      isLoggedIn
                          ? (user?.email ?? 'Clerk Verified Account')
                          : context.l10n.signInSubtitle,
                      style: TextStyle(fontSize: 13, color: context.colorScheme.onSurfaceVariant),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 8),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                      decoration: BoxDecoration(
                        color: role == AppRole.admin
                            ? cocolocoColors.statusCancelledBg
                            : isLoggedIn
                                ? cocolocoColors.statusCompletedBg
                                : context.colorScheme.surfaceContainerHighest,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Text(
                        role == AppRole.admin
                            ? '🛡️ Administrator (ADMIN)'
                            : isLoggedIn
                                ? '⭐ Loyal Member (USER)'
                                : '👤 Guest (GUEST)',
                        style: TextStyle(
                          fontSize: 11.5,
                          fontWeight: FontWeight.w700,
                          color: role == AppRole.admin
                              ? cocolocoColors.statusCancelledText
                              : isLoggedIn
                                  ? cocolocoColors.statusCompletedText
                                  : context.colorScheme.onSurfaceVariant,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          if (!isLoggedIn) ...[
            const SizedBox(height: 18),
            SizedBox(
              width: double.infinity,
              height: 48,
              child: ElevatedButton.icon(
                onPressed: _handleClerkLogin,
                icon: Icon(Icons.login_rounded, color: context.colorScheme.onPrimary, size: 20),
                label: Text(
                  context.l10n.signInButton,
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w700,
                    color: context.colorScheme.onPrimary,
                  ),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: context.colorScheme.primary,
                  foregroundColor: context.colorScheme.onPrimary,
                  elevation: 0,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildLoyaltyCard(AppRole role) {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [AppPalette.darkSurfaceElevated, AppPalette.darkSurface],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(22),
        boxShadow: [
          BoxShadow(
            color: Theme.of(context).shadowColor.withValues(alpha: 0.14),
            blurRadius: 14,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(6),
                      decoration: BoxDecoration(
                        color: AppPalette.gold.withValues(alpha: 0.2),
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(Icons.coffee_rounded, color: AppPalette.gold, size: 18),
                    ),
                    const SizedBox(width: 8),
                    const Flexible(
                      child: Text(
                        'COCOLOCO REWARDS',
                        style: TextStyle(
                          color: AppPalette.gold,
                          fontSize: 12,
                          fontWeight: FontWeight.w800,
                          letterSpacing: 0.8,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 8),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                decoration: BoxDecoration(
                  color: AppPalette.pureWhite.withValues(alpha: 0.12),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Text(
                  context.l10n.goldMember.toUpperCase(),
                  style: const TextStyle(color: AppPalette.pureWhite, fontSize: 10, fontWeight: FontWeight.w800),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      context.l10n.cocolocoBeans,
                      style: TextStyle(color: AppPalette.pureWhite.withValues(alpha: 0.7), fontSize: 12),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 2),
                    const Text(
                      '180 ☕',
                      style: TextStyle(
                        fontFamily: AppTypography.fontFamily,
                        color: AppPalette.pureWhite,
                        fontSize: 24,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 8),
              OutlinedButton(
                onPressed: () => _showComingSoon('Redeem Points'),
                style: OutlinedButton.styleFrom(
                  side: const BorderSide(color: AppPalette.gold, width: 1.2),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                  padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                ),
                child: Text(
                  context.l10n.redeemGifts,
                  style: const TextStyle(color: AppPalette.gold, fontSize: 12, fontWeight: FontWeight.w700),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildAdminBanner() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [context.colorScheme.primary, AppPalette.burgundy700],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: context.colorScheme.primary.withValues(alpha: 0.25),
            blurRadius: 18,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Icon(Icons.shield_rounded, color: context.colorScheme.onPrimary, size: 20),
                  const SizedBox(width: 8),
                  Text(
                    'STORE MANAGEMENT',
                    style: TextStyle(
                      color: context.colorScheme.onPrimary,
                      fontWeight: FontWeight.w800,
                      letterSpacing: 0.5,
                      fontSize: 13.5,
                    ),
                  ),
                ],
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                decoration: BoxDecoration(
                  color: context.colorScheme.onPrimary.withValues(alpha: 0.2),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Text(
                  'ADMIN HUB',
                  style: TextStyle(fontSize: 10, fontWeight: FontWeight.w800, color: context.colorScheme.onPrimary),
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Text(
            'You have full permissions to track and manage customer orders across the system.',
            style: TextStyle(color: context.colorScheme.onPrimary.withValues(alpha: 0.8), fontSize: 13, height: 1.4),
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: SizedBox(
                  height: 46,
                  child: ElevatedButton.icon(
                    onPressed: () => AdminProductsScreen.show(context),
                    icon: Icon(Icons.inventory_2_outlined, color: context.colorScheme.primary, size: 18),
                    label: Text(
                      'Menu Catalog',
                      style: TextStyle(fontWeight: FontWeight.w800, color: context.colorScheme.primary, fontSize: 13.5),
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: context.colorScheme.surface,
                      foregroundColor: context.colorScheme.primary,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                      elevation: 0,
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: SizedBox(
                  height: 46,
                  child: ElevatedButton.icon(
                    onPressed: _openAdminOrdersManager,
                    icon: Icon(Icons.receipt_long_rounded, color: context.colorScheme.primary, size: 18),
                    label: Text(
                      'All Orders',
                      style: TextStyle(fontWeight: FontWeight.w800, color: context.colorScheme.primary, fontSize: 13.5),
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: context.colorScheme.surface,
                      foregroundColor: context.colorScheme.primary,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                      elevation: 0,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildSectionHeader(String title) {
    return Padding(
      padding: const EdgeInsets.only(left: 4, bottom: 8),
      child: Text(
        title,
        style: TextStyle(
          fontSize: 13,
          fontWeight: FontWeight.w800,
          color: context.colorScheme.onSurfaceVariant,
          letterSpacing: 0.3,
        ),
      ),
    );
  }

  Widget _buildMenuCard(List<Widget> children) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(22),
        boxShadow: [
          BoxShadow(
            color: Theme.of(context).shadowColor.withValues(alpha: 0.04),
            blurRadius: 14,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Material(
        color: context.colorScheme.surface,
        borderRadius: BorderRadius.circular(22),
        clipBehavior: Clip.antiAlias,
        child: Column(children: children),
      ),
    );
  }

  Widget _buildMenuItem({
    required IconData icon,
    required String title,
    String? subtitle,
    String? badge,
    Color? badgeColor,
    Widget? trailing,
    required VoidCallback onTap,
  }) {
    return ListTile(
      onTap: onTap,
      contentPadding: const EdgeInsets.symmetric(horizontal: 18, vertical: 2),
      leading: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: context.colorScheme.surfaceContainerHighest,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Icon(icon, color: context.colorScheme.primary, size: 22),
      ),
      title: Row(
        children: [
          Expanded(
            child: Text(
              title,
              style: TextStyle(
                fontWeight: FontWeight.w700,
                fontSize: 15,
                color: context.colorScheme.onSurface,
              ),
            ),
          ),
          if (badge != null)
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
              decoration: BoxDecoration(
                color: badgeColor ?? context.colorScheme.primary,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Text(
                badge,
                style: TextStyle(fontSize: 10, fontWeight: FontWeight.w800, color: context.colorScheme.onPrimary),
              ),
            ),
        ],
      ),
      subtitle: subtitle != null
          ? Text(
              subtitle,
              style: TextStyle(fontSize: 12.5, color: context.colorScheme.onSurfaceVariant),
            )
          : null,
      trailing: trailing ?? Icon(Icons.arrow_forward_ios_rounded, size: 14, color: context.colorScheme.outlineVariant),
    );
  }

  Widget _buildDivider() {
    return Divider(height: 1, indent: 62, endIndent: 16, color: context.colorScheme.outlineVariant);
  }
}
