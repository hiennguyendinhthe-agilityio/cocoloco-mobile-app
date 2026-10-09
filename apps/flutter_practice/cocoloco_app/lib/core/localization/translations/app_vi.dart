import 'package:flutter/material.dart';
import '../app_localizations.dart';

class AppLocalizationsVi extends AppLocalizations {
  const AppLocalizationsVi() : super(const Locale('vi'));

  @override
  String get appTitle => 'Cocoloco - Cà phê & Bánh ngọt Thủ công';

  @override
  String get appTagline => 'Cà phê & Bánh ngọt Thủ công';

  @override
  String get cancel => 'Hủy';

  @override
  String get save => 'Lưu';

  @override
  String get confirm => 'Xác nhận';

  @override
  String get delete => 'Xóa';

  @override
  String get edit => 'Chỉnh sửa';

  @override
  String get close => 'Đóng';

  @override
  String get done => 'Hoàn tất';

  @override
  String get retry => 'Thử lại';

  @override
  String get search => 'Tìm kiếm';

  @override
  String get searchPlaceholder => 'Tìm cà phê, bánh ngọt...';

  @override
  String get comingSoon => 'Sắp ra mắt';

  @override
  String get comingSoonMsg =>
      'Tính năng này đang được phát triển và sẽ sớm ra mắt!';

  @override
  String get ok => 'Đồng ý';

  @override
  String get error => 'Lỗi';

  @override
  String get success => 'Thành công';

  @override
  String get loading => 'Đang tải...';

  // Navigation
  @override
  String get navHome => 'Trang chủ';

  @override
  String get navFavorites => 'Yêu thích';

  @override
  String get navOrders => 'Đơn hàng';

  @override
  String get navChat => 'Hỗ trợ';

  @override
  String get navCart => 'Giỏ hàng';

  // Categories
  @override
  String get categoryAll => 'Tất cả';

  @override
  String get categoryCoffee => '☕ Cà phê';

  @override
  String get categoryBakery => '🥐 Bánh ngọt';

  @override
  String get categoryCombos => '🎁 Combo';

  @override
  String get categorySpecials => '✨ Đặc biệt';

  // Product & Browse
  @override
  String get letsGetThisDayGoing => 'Khởi đầu ngày mới tràn đầy năng lượng';

  @override
  String get aprilSpecial => 'Ưu đãi đặc biệt';

  @override
  String get featuredOffers => 'Ưu đãi nổi bật';

  @override
  String get dailySpecial => 'Món ngon hôm nay';

  @override
  String get bestSellers => 'Bán chạy nhất';

  @override
  String addedToOrder(String item) => 'Đã thêm $item vào giỏ hàng';

  @override
  String get outOfStock => 'Tạm hết';

  @override
  String get available => 'Đang mở bán';

  @override
  String get viewCart => 'Xem giỏ hàng';

  @override
  String get addToOrder => 'Thêm vào giỏ';

  @override
  String get updateCart => 'Cập nhật giỏ';

  @override
  String get cartUpdated => 'Đã cập nhật giỏ hàng';

  @override
  String get orderNow => 'Đặt ngay';

  @override
  String get noProductsFound => 'Không có món nào trong danh mục này';

  @override
  String get noProductsSub =>
      'Thử chọn danh mục khác hoặc xóa từ khóa tìm kiếm.';

  // Product Detail
  @override
  String get customization => 'Tùy chỉnh món';

  @override
  String get size => 'Kích thước';

  @override
  String get regular => 'Vừa (Regular)';

  @override
  String get large => 'Lớn (Large)';

  @override
  String get sweetness => 'Độ ngọt';

  @override
  String get iceLevel => 'Lượng đá';

  @override
  String get milkOption => 'Loại sữa';

  @override
  String get reviews => 'Đánh giá';

  @override
  String get description => 'Mô tả';

  @override
  String get ingredients => 'Thành phần';

  // Cart & Checkout
  @override
  String get cartTitle => 'Giỏ hàng của bạn';

  @override
  String get cartEmptyTitle => 'Giỏ hàng đang trống';

  @override
  String get cartEmptySubtitle =>
      'Khám phá thực đơn cà phê & bánh tươi thơm ngon của Cocoloco ngay!';

  @override
  String get subtotal => 'Tạm tính';

  @override
  String get deliveryFee => 'Phí giao hàng';

  @override
  String get total => 'Tổng thanh toán';

  @override
  String get freeDelivery => 'Miễn phí';

  @override
  String get checkout => 'Tiến hành đặt hàng';

  @override
  String get checkoutProcessing => 'Đang xử lý đơn...';

  @override
  String get clearCart => 'Xóa giỏ hàng';

  @override
  String get clearCartConfirm => 'Bạn có chắc chắn muốn làm trống giỏ hàng?';

  @override
  String get orderFailed =>
      'Không thể hoàn tất đơn hàng. Vui lòng kiểm tra lại kết nối mạng.';

  // Order Success
  @override
  String get orderedTitle => 'Đã đặt hàng!';

  @override
  String get orderedSubtitle => 'Món ăn & đồ uống sẽ sẵn sàng trong 3 phút.';

  @override
  String get okayGotIt => 'Đã hiểu!';

  // Orders Screen
  @override
  String get yourOrders => 'Đơn hàng của bạn';

  @override
  String get trackReceipts => 'Theo dõi đồ uống & hoá đơn';

  @override
  String get allOrders => 'Tất cả đơn';

  @override
  String get pending => 'Chờ xác nhận';

  @override
  String get brewing => 'Đang pha chế';

  @override
  String get completed => 'Hoàn thành';

  @override
  String get cancelled => 'Đã hủy';

  @override
  String get reorder => 'Đặt lại món';

  @override
  String get noOrdersYet => 'Chưa có đơn hàng nào';

  @override
  String get noOrdersSubtitle =>
      'Các đơn hàng và tiến trình pha chế đồ uống sẽ xuất hiện tại đây.';

  @override
  String get loginToViewOrders => 'Đăng nhập để xem đơn';

  @override
  String get loginPromptSubtitle =>
      'Đăng nhập để xem lịch sử mua hàng và cập nhật pha chế trực tiếp.';

  @override
  String ordersCount(int count) => '$count đơn hàng';

  // Profile & Settings
  @override
  String get cocolocoAccount => 'Tài khoản Cocoloco';

  @override
  String get signInPrompt => 'Đăng nhập để tích điểm';

  @override
  String get signInSubtitle => 'Tích hạt beans, lưu địa chỉ & theo dõi đơn';

  @override
  String get signInButton => 'Đăng nhập với Clerk';

  @override
  String get goldMember => 'Hội viên Vàng Cocoloco';

  @override
  String get memberId => 'Mã hội viên';

  @override
  String get cocolocoBeans => 'Hạt Beans tích luỹ';

  @override
  String get redeemGifts => 'Đổi đồ uống & bánh ngọt';

  @override
  String get ordersAndTransactions => 'Đơn hàng & Giao dịch';

  @override
  String get orderHistory => 'Lịch sử đơn hàng';

  @override
  String get orderHistorySub => 'Theo dõi đơn hàng và trạng thái giao nhận';

  @override
  String get savedAddresses => 'Sổ địa chỉ đã lưu';

  @override
  String get savedAddressesSub => 'Quản lý địa chỉ giao nhận cà phê & bánh';

  @override
  String get paymentMethods => 'Phương thức thanh toán';

  @override
  String get paymentMethodsSub => 'Thẻ tín dụng, Apple Pay, Tiền mặt';

  @override
  String get vouchersAndOffers => 'Kho ưu đãi & Voucher';

  @override
  String get vouchersSub => 'Bạn đang có 2 mã giảm giá 20%';

  @override
  String get settingsAndUtilities => 'Cài đặt & Tiện ích';

  @override
  String get pushNotifications => 'Thông báo đẩy';

  @override
  String get notificationsSub => 'Nhận cập nhật trạng thái đơn hàng tức thì';

  @override
  String get accountSecurity => 'Bảo mật tài khoản';

  @override
  String get securitySub => 'Xác thực chuẩn Clerk RS256 JWKS';

  @override
  String get secure => 'An toàn';

  @override
  String get displayLanguage => 'Ngôn ngữ hiển thị';

  @override
  String get currentLanguageName => 'Tiếng Việt';

  @override
  String get selectLanguage => 'Chọn ngôn ngữ hiển thị';

  @override
  String get english => 'English (Tiếng Anh)';

  @override
  String get vietnamese => 'Tiếng Việt';

  @override
  String get infoAndSupport => 'Thông tin & Hỗ trợ';

  @override
  String get customerSupport => 'Tổng đài chăm sóc khách hàng';

  @override
  String get hotlineSub => 'Hotline 1900 6868 (8:00 - 22:00)';

  @override
  String get termsAndPolicies => 'Điều khoản & Chính sách';

  @override
  String get termsSub => 'Bảo vệ quyền lợi người dùng';

  @override
  String get appVersion => 'Phiên bản ứng dụng';

  @override
  String get signOut => 'Đăng xuất';

  @override
  String get signOutConfirm =>
      'Bạn có chắc chắn muốn đăng xuất khỏi tài khoản?';

  @override
  String get signedOutSuccessfully => 'Đã đăng xuất thành công.';

  // Admin Hub & Products Management
  @override
  String get adminDashboard => 'Bảng điều khiển Admin';

  @override
  String get adminProductsTitle => 'Quản lý thực đơn';

  @override
  String get adminProductsSubtitle =>
      'Quản lý danh sách món và tình trạng mở bán';

  @override
  String get addProduct => 'Thêm món mới';

  @override
  String get editProduct => 'Chỉnh sửa món';

  @override
  String deleteProductConfirm(String name) =>
      'Bạn có chắc chắn muốn xóa món $name?';

  @override
  String get deleteProductWarning => 'Thao tác này không thể hoàn tác.';

  @override
  String get productConflictError =>
      'Không thể xóa: món này đã phát sinh đơn hàng trong hệ thống.';

  @override
  String get productName => 'Tên món';

  @override
  String get productPrice => 'Đơn giá (\$)';

  @override
  String get productCategory => 'Danh mục';

  @override
  String get productDescription => 'Mô tả món';

  @override
  String get productImageUrl => 'Đường dẫn ảnh (URL)';

  @override
  String get isAvailable => 'Mở bán cho khách';

  // Auth & Clerk Sync
  @override
  String get welcomeToCocoloco => 'Chào mừng đến Cocoloco';

  @override
  String get signInSubtitleModal => 'Cà phê & Bánh ngọt Thủ công';

  @override
  String get continueWithGoogle => 'Tiếp tục với Google';

  @override
  String get orWithEmail => 'Hoặc tiếp tục với email';

  @override
  String get enterEmailAddress => 'Nhập địa chỉ email của bạn';

  @override
  String get sendOtpCode => 'Gửi mã xác thực';

  @override
  String get guestCheckoutPrompt => 'Đăng nhập để hoàn tất đơn hàng';

  @override
  String get guestCheckoutSubtext =>
      'Đăng nhập để theo dõi đơn hàng thời gian thực, tích hạt đậu thưởng và lưu lịch sử hóa đơn.';

  @override
  String get guestBenefitTracking =>
      'Cập nhật tiến độ pha chế & giao hàng trực tiếp';

  @override
  String get guestBenefitRewards => 'Tích hạt đậu thưởng & đổi quà thành viên';

  @override
  String get guestBenefitReceipt =>
      'Lưu hóa đơn điện tử & đặt lại nhanh 1 chạm';

  @override
  String get maybeLater => 'Để sau';

  @override
  String get syncingWithBackend => 'Đang đồng bộ với hệ thống Cocoloco...';

  @override
  String get signedInSuccessfully => 'Đăng nhập & đồng bộ thành công!';

  @override
  String get syncFailed => 'Đồng bộ thất bại. Vui lòng thử lại.';

  // Theme Modes
  @override
  String get themeModeTitle => 'Giao diện ứng dụng';

  @override
  String get themeLight => 'Chế độ Sáng';

  @override
  String get themeDark => 'Chế độ Tối';

  @override
  String get themeSystem => 'Theo hệ thống';

  @override
  String get themeLightSubtitle => 'Sắc kem ấm & bordeaux vang đỏ';

  @override
  String get themeDarkSubtitle => 'Sắc cà phê rang đậm về đêm';

  @override
  String get themeSystemSubtitle => 'Tự động đồng bộ theo cài đặt thiết bị';
}
