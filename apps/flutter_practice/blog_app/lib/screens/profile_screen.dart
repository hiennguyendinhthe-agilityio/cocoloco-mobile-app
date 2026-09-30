import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';
import '../core/services/session_service.dart';
import '../core/theme/app_colors.dart';
import '../core/theme/app_typography.dart';
import '../data/repositories/order_repository.dart';
import '../models/order.dart';
import '../models/user_profile.dart';
import 'admin_products_screen.dart';
import 'clerk_webview_screen.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final SessionService _session = SessionService.instance;
  final OrderRepository _orderRepo = OrderRepository();
  bool _notificationsEnabled = true;

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
          children: const [
            SizedBox(
              width: 20,
              height: 20,
              child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2),
            ),
            SizedBox(width: 12),
            Text('Syncing with Cocoloco system...'),
          ],
        ),
        backgroundColor: AppColors.primary,
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
          const SnackBar(
            content: Row(
              children: [
                Icon(Icons.check_circle_rounded, color: Colors.white),
                SizedBox(width: 10),
                Text('Signed in and synced successfully!'),
              ],
            ),
            backgroundColor: Color(0xFF2E7D32),
          ),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Sync failed. Please try again.'),
            backgroundColor: Colors.red,
          ),
        );
      }
  }

  void _confirmLogout() {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
        backgroundColor: Colors.white,
        title: const Row(
          children: [
            Icon(Icons.logout_rounded, color: Color(0xFFC53030), size: 24),
            SizedBox(width: 10),
            Text(
              'Confirm Sign Out',
              style: TextStyle(
                fontFamily: AppTypography.fontFamily,
                fontWeight: FontWeight.w800,
                fontSize: 18,
                color: AppColors.textDark,
              ),
            ),
          ],
        ),
        content: const Text(
          'Are you sure you want to sign out of your Cocoloco account on this device?',
          style: TextStyle(fontSize: 14, color: AppColors.textSecondary, height: 1.4),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text(
              'Cancel',
              style: TextStyle(color: Color(0xFF7A7067), fontWeight: FontWeight.w600),
            ),
          ),
          ElevatedButton(
            onPressed: () async {
              Navigator.pop(ctx);
              try {
                await WebViewCookieManager().clearCookies();
              } catch (_) {}
              _session.logout();
              if (mounted) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Signed out successfully.'),
                    backgroundColor: AppColors.primary,
                  ),
                );
              }
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFFC53030),
              elevation: 0,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
            ),
            child: const Text(
              'Sign Out',
              style: TextStyle(color: Colors.white, fontWeight: FontWeight.w700),
            ),
          ),
        ],
      ),
    );
  }

  void _openAdminOrdersManager() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.white,
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
                  padding: const EdgeInsets.fromLTRB(20, 16, 20, 24),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Center(
                        child: Container(
                          width: 44,
                          height: 5,
                          decoration: BoxDecoration(
                            color: const Color(0xFFE2DDD5),
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                      ),
                      const SizedBox(height: 16),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text(
                            'All Store Orders',
                            style: TextStyle(
                              fontFamily: AppTypography.fontFamily,
                              fontSize: 20,
                              fontWeight: FontWeight.w800,
                              color: AppColors.textDark,
                            ),
                          ),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                            decoration: BoxDecoration(
                              color: const Color(0xFF5B1921),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: const Text(
                              'ADMIN HUB',
                              style: TextStyle(fontSize: 11, fontWeight: FontWeight.w800, color: Colors.white),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 6),
                      const Text(
                        'Tap a status button to quickly update order lifecycle',
                        style: TextStyle(fontSize: 13, color: AppColors.textSecondary),
                      ),
                      const Divider(height: 24),
                      Expanded(
                        child: snapshot.connectionState == ConnectionState.waiting
                            ? const Center(child: CircularProgressIndicator(color: AppColors.primary))
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
        color: const Color(0xFFFBF9F5),
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: const Color(0xFFECE7DE)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                '${ord.shortId} • \$${ord.totalAmount.toStringAsFixed(2)}',
                style: const TextStyle(fontWeight: FontWeight.w800, fontSize: 15, color: AppColors.textDark),
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
            style: const TextStyle(fontSize: 13, color: Color(0xFF5A524C)),
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
        backgroundColor: AppColors.primary,
        duration: const Duration(seconds: 2),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final role = _session.role;
    final user = _session.user;
    final bool isLoggedIn = role != AppRole.guest;

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: const BackButton(color: AppColors.textDark),
        centerTitle: true,
        title: const Text(
          'Cocoloco Account',
          style: TextStyle(
            fontFamily: AppTypography.fontFamily,
            fontSize: 18,
            fontWeight: FontWeight.w800,
            color: AppColors.textDark,
          ),
        ),
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
              _buildSectionHeader('Orders & Transactions'),
              _buildMenuCard([
                _buildMenuItem(
                  icon: Icons.receipt_long_outlined,
                  title: 'Order History',
                  subtitle: 'Track your orders and delivery status',
                  onTap: () {
                    _showComingSoon('Order History');
                  },
                ),
                _buildDivider(),
                _buildMenuItem(
                  icon: Icons.location_on_outlined,
                  title: 'Saved Addresses',
                  subtitle: 'Manage delivery addresses for coffee & bakery',
                  onTap: () => _showComingSoon('Saved Addresses'),
                ),
                _buildDivider(),
                _buildMenuItem(
                  icon: Icons.credit_card_outlined,
                  title: 'Payment Methods',
                  subtitle: 'Credit Card, Apple Pay, Cash',
                  onTap: () => _showComingSoon('Payment Methods'),
                ),
                _buildDivider(),
                _buildMenuItem(
                  icon: Icons.confirmation_number_outlined,
                  title: 'Vouchers & Offers',
                  subtitle: 'You have two 20% discount vouchers',
                  badge: '2 NEW',
                  badgeColor: const Color(0xFFE65100),
                  onTap: () => _showComingSoon('Vouchers & Offers'),
                ),
              ]),

              const SizedBox(height: 20),

              // 5. Section: Preferences & Security
              _buildSectionHeader('Settings & Utilities'),
              _buildMenuCard([
                ListTile(
                  contentPadding: const EdgeInsets.symmetric(horizontal: 18, vertical: 4),
                  leading: Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: const Color(0xFFF3EFE8),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: const Icon(Icons.notifications_outlined, color: AppColors.primary, size: 22),
                  ),
                  title: const Text(
                    'Push Notifications',
                    style: TextStyle(fontWeight: FontWeight.w700, fontSize: 15, color: AppColors.textDark),
                  ),
                  subtitle: const Text(
                    'Receive order status updates',
                    style: TextStyle(fontSize: 12.5, color: AppColors.textSecondary),
                  ),
                  trailing: Switch.adaptive(
                    value: _notificationsEnabled,
                    activeTrackColor: AppColors.primary,
                    onChanged: (val) {
                      setState(() {
                        _notificationsEnabled = val;
                      });
                    },
                  ),
                ),
                _buildDivider(),
                _buildMenuItem(
                  icon: Icons.verified_user_outlined,
                  title: 'Account Security',
                  subtitle: 'Clerk RS256 JWKS authentication',
                  trailing: const Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(Icons.check_circle_rounded, color: Color(0xFF2E7D32), size: 18),
                      SizedBox(width: 4),
                      Text('Secure', style: TextStyle(fontSize: 12, fontWeight: FontWeight.w700, color: Color(0xFF2E7D32))),
                    ],
                  ),
                  onTap: () {},
                ),
                _buildDivider(),
                _buildMenuItem(
                  icon: Icons.language_rounded,
                  title: 'Display Language',
                  subtitle: 'English (Default)',
                  onTap: () => _showComingSoon('Change Language'),
                ),
              ]),

              const SizedBox(height: 20),

              // 6. Section: Support & Info
              _buildSectionHeader('Information & Support'),
              _buildMenuCard([
                _buildMenuItem(
                  icon: Icons.headset_mic_outlined,
                  title: 'Customer Support Hotline',
                  subtitle: 'Hotline 1900 6868 (8:00 - 22:00)',
                  onTap: () => _showComingSoon('Call Hotline'),
                ),
                _buildDivider(),
                _buildMenuItem(
                  icon: Icons.policy_outlined,
                  title: 'Terms of Service & Policies',
                  subtitle: 'Protecting user rights',
                  onTap: () => _showComingSoon('Terms & Policies'),
                ),
                _buildDivider(),
                _buildMenuItem(
                  icon: Icons.info_outline_rounded,
                  title: 'App Version',
                  subtitle: 'Cocoloco Mobile App v1.0.0 (FastAPI 3.12+)',
                  trailing: const Text(
                    'v1.0.0',
                    style: TextStyle(fontSize: 13, fontWeight: FontWeight.w700, color: AppColors.textSecondary),
                  ),
                  onTap: () {},
                ),
              ]),

              const SizedBox(height: 28),

              // 7. Logout Button (If Logged In)
              if (isLoggedIn)
                SizedBox(
                  width: double.infinity,
                  height: 52,
                  child: OutlinedButton.icon(
                    onPressed: _confirmLogout,
                    icon: const Icon(Icons.logout_rounded, color: Color(0xFFC53030), size: 20),
                    label: const Text(
                      'Sign Out',
                      style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w700,
                        color: Color(0xFFC53030),
                      ),
                    ),
                    style: OutlinedButton.styleFrom(
                      side: const BorderSide(color: Color(0xFFF3D2D2), width: 1.5),
                      backgroundColor: const Color(0xFFFDF4F4),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildProfileCard(bool isLoggedIn, AppRole role, UserProfile? user) {
    final avatarUrl = user?.avatarUrl;
    final hasAvatar = isLoggedIn && avatarUrl != null && avatarUrl.isNotEmpty;

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(26),
        boxShadow: const [
          BoxShadow(
            color: Color(0x0A000000),
            blurRadius: 18,
            offset: Offset(0, 6),
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
                        ? [const Color(0xFF5B1921), const Color(0xFF862B37)]
                        : isLoggedIn
                            ? [AppColors.primary, const Color(0xFF7A2531)]
                            : [const Color(0xFFDFD9D0), const Color(0xFFC5BDB0)],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: role == AppRole.admin
                          ? const Color(0x445B1921)
                          : const Color(0x22000000),
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
                              color: Colors.white,
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
                            color: Colors.white,
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
                      isLoggedIn ? (user?.fullName ?? 'Cocoloco Member') : 'Welcome!',
                      style: const TextStyle(
                        fontFamily: AppTypography.fontFamily,
                        fontSize: 18,
                        fontWeight: FontWeight.w800,
                        color: AppColors.textDark,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 4),
                    Text(
                      isLoggedIn
                          ? (user?.email ?? 'Clerk Verified Account')
                          : 'Sign in to earn rewards & points',
                      style: const TextStyle(fontSize: 13, color: AppColors.textSecondary),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 8),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                      decoration: BoxDecoration(
                        color: role == AppRole.admin
                            ? const Color(0xFFFDEEEC)
                            : isLoggedIn
                                ? const Color(0xFFEAF8ED)
                                : const Color(0xFFF3EFE8),
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
                              ? const Color(0xFFC53030)
                              : isLoggedIn
                                  ? const Color(0xFF2E7D32)
                                  : const Color(0xFF6A645D),
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
                icon: const Icon(Icons.login_rounded, color: Colors.white, size: 20),
                label: const Text(
                  'Sign In / Register',
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w700,
                    color: Colors.white,
                  ),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
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
          colors: [Color(0xFF2B221E), Color(0xFF1B1513)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(22),
        boxShadow: const [
          BoxShadow(
            color: Color(0x2A000000),
            blurRadius: 14,
            offset: Offset(0, 6),
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
                  Container(
                    padding: const EdgeInsets.all(6),
                    decoration: BoxDecoration(
                      color: const Color(0xFFD4AF37).withValues(alpha: 0.2),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(Icons.coffee_rounded, color: Color(0xFFD4AF37), size: 18),
                  ),
                  const SizedBox(width: 8),
                  const Text(
                    'COCOLOCO REWARDS',
                    style: TextStyle(
                      color: Color(0xFFD4AF37),
                      fontSize: 12,
                      fontWeight: FontWeight.w800,
                      letterSpacing: 0.8,
                    ),
                  ),
                ],
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.12),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: const Text(
                  'GOLD MEMBER',
                  style: TextStyle(color: Colors.white, fontSize: 10, fontWeight: FontWeight.w800),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: const [
                  Text(
                    'Cocoloco Beans Points',
                    style: TextStyle(color: Colors.white70, fontSize: 12),
                  ),
                  SizedBox(height: 2),
                  Text(
                    '180 ☕',
                    style: TextStyle(
                      fontFamily: AppTypography.fontFamily,
                      color: Colors.white,
                      fontSize: 24,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                ],
              ),
              OutlinedButton(
                onPressed: () => _showComingSoon('Redeem Points'),
                style: OutlinedButton.styleFrom(
                  side: const BorderSide(color: Color(0xFFD4AF37), width: 1.2),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                  padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                ),
                child: const Text(
                  'Redeem Now',
                  style: TextStyle(color: Color(0xFFD4AF37), fontSize: 12, fontWeight: FontWeight.w700),
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
        gradient: const LinearGradient(
          colors: [Color(0xFF5B1921), Color(0xFF862B37)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(24),
        boxShadow: const [
          BoxShadow(
            color: Color(0x335B1921),
            blurRadius: 18,
            offset: Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Row(
                children: [
                  Icon(Icons.shield_rounded, color: Colors.white, size: 20),
                  SizedBox(width: 8),
                  Text(
                    'STORE MANAGEMENT',
                    style: TextStyle(
                      color: Colors.white,
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
                  color: Colors.white24,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: const Text(
                  'ADMIN HUB',
                  style: TextStyle(fontSize: 10, fontWeight: FontWeight.w800, color: Colors.white),
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          const Text(
            'You have full permissions to track and manage customer orders across the system.',
            style: TextStyle(color: Colors.white70, fontSize: 13, height: 1.4),
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: SizedBox(
                  height: 46,
                  child: ElevatedButton.icon(
                    onPressed: () => AdminProductsScreen.show(context),
                    icon: const Icon(Icons.inventory_2_outlined, color: Color(0xFF5B1921), size: 18),
                    label: const Text(
                      'Menu Catalog',
                      style: TextStyle(fontWeight: FontWeight.w800, color: Color(0xFF5B1921), fontSize: 13.5),
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.white,
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
                    icon: const Icon(Icons.receipt_long_rounded, color: Color(0xFF5B1921), size: 18),
                    label: const Text(
                      'All Orders',
                      style: TextStyle(fontWeight: FontWeight.w800, color: Color(0xFF5B1921), fontSize: 13.5),
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.white,
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
        style: const TextStyle(
          fontSize: 13,
          fontWeight: FontWeight.w800,
          color: AppColors.textSecondary,
          letterSpacing: 0.3,
        ),
      ),
    );
  }

  Widget _buildMenuCard(List<Widget> children) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(22),
        boxShadow: const [
          BoxShadow(
            color: Color(0x08000000),
            blurRadius: 14,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: Material(
        color: Colors.white,
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
          color: const Color(0xFFF3EFE8),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Icon(icon, color: AppColors.primary, size: 22),
      ),
      title: Row(
        children: [
          Expanded(
            child: Text(
              title,
              style: const TextStyle(
                fontWeight: FontWeight.w700,
                fontSize: 15,
                color: AppColors.textDark,
              ),
            ),
          ),
          if (badge != null)
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
              decoration: BoxDecoration(
                color: badgeColor ?? AppColors.primary,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Text(
                badge,
                style: const TextStyle(fontSize: 10, fontWeight: FontWeight.w800, color: Colors.white),
              ),
            ),
        ],
      ),
      subtitle: subtitle != null
          ? Text(
              subtitle,
              style: const TextStyle(fontSize: 12.5, color: AppColors.textSecondary),
            )
          : null,
      trailing: trailing ?? const Icon(Icons.arrow_forward_ios_rounded, size: 14, color: Color(0xFFB5ADA4)),
    );
  }

  Widget _buildDivider() {
    return const Divider(height: 1, indent: 62, endIndent: 16, color: Color(0xFFF1ECE4));
  }
}
