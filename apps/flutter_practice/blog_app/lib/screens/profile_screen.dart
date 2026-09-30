import 'package:flutter/material.dart';
import '../core/services/session_service.dart';
import '../core/theme/app_colors.dart';
import '../core/theme/app_typography.dart';
import '../data/repositories/order_repository.dart';
import '../models/order.dart';
import '../models/user_profile.dart';
import '../widgets/clerk_auth_modal.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
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
                            'Toàn Bộ Đơn Hàng Quán',
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
                        'Chạm nút trạng thái để chuyển nhanh vòng đời đơn hàng',
                        style: TextStyle(fontSize: 13, color: AppColors.textSecondary),
                      ),
                      const Divider(height: 24),
                      Expanded(
                        child: snapshot.connectionState == ConnectionState.waiting
                            ? const Center(child: CircularProgressIndicator(color: AppColors.primary))
                            : orders.isEmpty
                                ? const Center(child: Text('Chưa có đơn hàng nào.'))
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
                  PopupMenuItem(value: 'PENDING', child: Text('⏳ PENDING (Chờ duyệt)')),
                  PopupMenuItem(value: 'CONFIRMED', child: Text('☕ CONFIRMED (Đang pha)')),
                  PopupMenuItem(value: 'COMPLETED', child: Text('✅ COMPLETED (Xong)')),
                  PopupMenuItem(value: 'CANCELLED', child: Text('❌ CANCELLED (Hủy)')),
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

  @override
  Widget build(BuildContext context) {
    final role = _session.role;
    final user = _session.user;

    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          padding: const EdgeInsets.fromLTRB(24, 16, 24, 28),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Screen Title
              Text(
                'Account & Role',
                style: AppTypography.headingLarge,
              ),
              const SizedBox(height: 4),
              const Text(
                'Manage authentication & RBAC permissions',
                style: TextStyle(
                  fontSize: 14,
                  color: AppColors.textSecondary,
                  fontWeight: FontWeight.w500,
                ),
              ),

              const SizedBox(height: 20),

              // User Info Card
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(26),
                  boxShadow: const [
                    BoxShadow(
                      color: Color(0x0A000000),
                      blurRadius: 16,
                      offset: Offset(0, 6),
                    ),
                  ],
                ),
                child: Row(
                  children: [
                    CircleAvatar(
                      radius: 32,
                      backgroundColor: role == AppRole.admin
                          ? const Color(0xFF5B1921)
                          : role == AppRole.user
                              ? AppColors.primaryLight
                              : const Color(0xFFE2DDD5),
                      child: Icon(
                        role == AppRole.admin
                            ? Icons.admin_panel_settings_rounded
                            : role == AppRole.user
                                ? Icons.person_rounded
                                : Icons.person_outline_rounded,
                        size: 32,
                        color: role == AppRole.guest ? AppColors.textDark : Colors.white,
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            user?.fullName ?? 'Khách vãng lai (Guest)',
                            style: const TextStyle(
                              fontFamily: AppTypography.fontFamily,
                              fontSize: 18,
                              fontWeight: FontWeight.w800,
                              color: AppColors.textDark,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            user?.email ?? 'Chưa đăng nhập tài khoản',
                            style: const TextStyle(fontSize: 13, color: AppColors.textSecondary),
                          ),
                          const SizedBox(height: 8),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                            decoration: BoxDecoration(
                              color: role == AppRole.admin
                                  ? const Color(0xFFFDEEEC)
                                  : role == AppRole.user
                                      ? const Color(0xFFEAF8ED)
                                      : const Color(0xFFF3EFE8),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Text(
                              role == AppRole.admin
                                  ? '🛡️ Quản trị viên (ADMIN)'
                                  : role == AppRole.user
                                      ? '⭐ Khách thân thiết (USER)'
                                      : '👤 Khách xem thực đơn (GUEST)',
                              style: TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.w700,
                                color: role == AppRole.admin
                                    ? const Color(0xFFC53030)
                                    : role == AppRole.user
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
              ),

              if (role == AppRole.guest) ...[
                const SizedBox(height: 16),
                SizedBox(
                  width: double.infinity,
                  height: 50,
                  child: ElevatedButton.icon(
                    onPressed: () => ClerkAuthModal.show(context),
                    icon: const Icon(Icons.login_rounded, color: Colors.white, size: 20),
                    label: const Text(
                      'Đăng nhập với Clerk (Google / Email)',
                      style: TextStyle(fontSize: 15, fontWeight: FontWeight.w700, color: Colors.white),
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primary,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(22)),
                      elevation: 0,
                    ),
                  ),
                ),
              ],

              const SizedBox(height: 24),

              // Demo Role Switcher
              Container(
                padding: const EdgeInsets.all(18),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(22),
                  border: Border.all(color: const Color(0xFFECE7DE)),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Row(
                      children: [
                        Icon(Icons.tune_rounded, size: 20, color: AppColors.primary),
                        SizedBox(width: 8),
                        Text(
                          'Mô phỏng Phân Quyền (RBAC Switcher)',
                          style: TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.w700,
                            color: AppColors.textDark,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 6),
                    const Text(
                      'Bấm để chuyển vai trò tức thì và kiểm chứng giao diện thay đổi theo quyền:',
                      style: TextStyle(fontSize: 13, color: AppColors.textSecondary),
                    ),
                    const SizedBox(height: 14),
                    Row(
                      children: [
                        Expanded(
                          child: _buildRoleButton(
                            title: 'Guest',
                            isSelected: role == AppRole.guest,
                            onTap: () => _session.loginAs(AppRole.guest),
                          ),
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: _buildRoleButton(
                            title: 'User',
                            isSelected: role == AppRole.user,
                            onTap: () => _session.loginAs(AppRole.user),
                          ),
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: _buildRoleButton(
                            title: 'Admin',
                            isSelected: role == AppRole.admin,
                            onTap: () => _session.loginAs(AppRole.admin),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),

              // Conditional Section: ADMIN HUB
              if (role == AppRole.admin) ...[
                const SizedBox(height: 24),
                Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      colors: [Color(0xFF5B1921), Color(0xFF862B37)],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    borderRadius: BorderRadius.circular(26),
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
                              Icon(Icons.shield_rounded, color: Colors.white, size: 22),
                              SizedBox(width: 8),
                              Text(
                                'DÀNH CHO QUẢN TRỊ VIÊN',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.w800,
                                  letterSpacing: 0.5,
                                  fontSize: 14,
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
                              'ADMIN ONLY',
                              style: TextStyle(fontSize: 10, fontWeight: FontWeight.w800, color: Colors.white),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),
                      const Text(
                        'Bạn có toàn quyền quản lý cửa hàng: duyệt đơn đặt hàng trực tiếp và quản trị danh mục sản phẩm.',
                        style: TextStyle(color: Colors.white70, fontSize: 13.5, height: 1.4),
                      ),
                      const SizedBox(height: 18),
                      SizedBox(
                        width: double.infinity,
                        height: 48,
                        child: ElevatedButton.icon(
                          onPressed: _openAdminOrdersManager,
                          icon: const Icon(Icons.receipt_long_rounded, color: Color(0xFF5B1921)),
                          label: const Text(
                            'Quản lý Đơn Toàn Quán',
                            style: TextStyle(fontWeight: FontWeight.w700, color: Color(0xFF5B1921)),
                          ),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.white,
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],

              const SizedBox(height: 24),

              // Action tiles
              Material(
                color: Colors.white,
                borderRadius: BorderRadius.circular(24),
                clipBehavior: Clip.antiAlias,
                child: Column(
                  children: [
                    ListTile(
                      leading: const Icon(Icons.history_rounded, color: AppColors.primary),
                      title: const Text('Lịch sử giao dịch', style: TextStyle(fontWeight: FontWeight.w600)),
                      trailing: const Icon(Icons.arrow_forward_ios, size: 14, color: AppColors.textSecondary),
                      onTap: () {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('Vui lòng mở tab Đơn hàng để xem chi tiết hóa đơn!')),
                        );
                      },
                    ),
                    const Divider(height: 1, indent: 56),
                    ListTile(
                      leading: const Icon(Icons.lock_outline_rounded, color: AppColors.primary),
                      title: const Text('Bảo mật & RS256 JWKS', style: TextStyle(fontWeight: FontWeight.w600)),
                      subtitle: const Text('Chứng thực không độ trễ qua Clerk', style: TextStyle(fontSize: 12)),
                      trailing: const Icon(Icons.check_circle_rounded, color: Color(0xFF2E7D32), size: 18),
                    ),
                    if (role != AppRole.guest) ...[
                      const Divider(height: 1, indent: 56),
                      ListTile(
                        leading: const Icon(Icons.logout_rounded, color: Color(0xFFC53030)),
                        title: const Text(
                          'Đăng xuất tài khoản',
                          style: TextStyle(fontWeight: FontWeight.w600, color: Color(0xFFC53030)),
                        ),
                        onTap: () {
                          _session.logout();
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text('Đã đăng xuất về chế độ Khách vãng lai')),
                          );
                        },
                      ),
                    ],
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildRoleButton({
    required String title,
    required bool isSelected,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 180),
        padding: const EdgeInsets.symmetric(vertical: 10),
        decoration: BoxDecoration(
          color: isSelected ? AppColors.primary : const Color(0xFFF4F0E8),
          borderRadius: BorderRadius.circular(16),
        ),
        child: Center(
          child: Text(
            title,
            style: TextStyle(
              fontSize: 13.5,
              fontWeight: isSelected ? FontWeight.w800 : FontWeight.w600,
              color: isSelected ? Colors.white : AppColors.textDark,
            ),
          ),
        ),
      ),
    );
  }
}
