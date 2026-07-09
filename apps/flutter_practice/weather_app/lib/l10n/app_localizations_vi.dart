// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Vietnamese (`vi`).
class AppLocalizationsVi extends AppLocalizations {
  AppLocalizationsVi([String locale = 'vi']) : super(locale);

  @override
  String get searchCityHint => 'Sẵn sàng kiểm tra thời tiết chưa?';

  @override
  String get searchCityPlaceholder => 'Tìm kiếm thành phố...';

  @override
  String get cancel => 'Hủy';

  @override
  String get feelsLike => 'Cảm giác như';

  @override
  String get humidity => 'Độ ẩm';

  @override
  String get wind => 'Gió';

  @override
  String get low => 'Thấp';

  @override
  String get high => 'Cao';

  @override
  String get noWeatherSearchPrompt =>
      'Chưa có dữ liệu. Vui lòng tìm kiếm một thành phố.';

  @override
  String get tryAnotherSearch => 'Thử tìm kiếm khác.';

  @override
  String get home => 'Trang chủ';

  @override
  String get profile => 'Hồ sơ';

  @override
  String get settings => 'Cài đặt';

  @override
  String get logout => 'Đăng xuất';

  @override
  String get language => 'Ngôn ngữ';

  @override
  String get theme => 'Giao diện tối';

  @override
  String get unknown => 'Không rõ';

  @override
  String get weatherToday => 'Thời tiết hôm nay';

  @override
  String get tapToSearch => 'Nhấn 🔍 để tìm kiếm\nthành phố của bạn';

  @override
  String get locations => 'Địa điểm';

  @override
  String get weatherAlerts => 'Cảnh báo thời tiết';

  @override
  String get helpSupport => 'Trợ giúp & Hỗ trợ';

  @override
  String get goPremium => 'Nâng cấp Premium';

  @override
  String get premiumSubtitle =>
      'Mở khóa thông tin thời tiết nâng cao & trải nghiệm không quảng cáo';

  @override
  String get currentLocation => 'VỊ TRÍ HIỆN TẠI';

  @override
  String get recentSearches => 'TÌM KIẾM GẦN ĐÂY';

  @override
  String get popularCities => 'THÀNH PHỐ PHỔ BIẾN';

  @override
  String get clearBtn => 'XÓA';

  @override
  String get noResultsFound => 'Không tìm thấy kết quả';

  @override
  String get locating => 'Đang định vị...';

  @override
  String get tapToFindLocation => 'Nhấn để tìm vị trí của bạn';

  @override
  String couldNotAccessLocation(String error) {
    return 'Không thể lấy vị trí: $error';
  }

  @override
  String get noInternetConnection =>
      'Không có kết nối mạng. Vui lòng kiểm tra lại.';

  @override
  String get searchCityBtn => 'Tìm kiếm';

  @override
  String get viewAll => 'Xem tất cả';

  @override
  String get couldNotLoadForecast => 'Không thể tải dự báo thời tiết';

  @override
  String get sevenDayForecast => 'Dự báo 7 ngày';

  @override
  String get now => 'Bây giờ';

  @override
  String get appTitle => 'Thời tiết';

  @override
  String get london => 'Luân Đôn';

  @override
  String get tokyo => 'Tokyo';

  @override
  String get newYork => 'New York';
}
