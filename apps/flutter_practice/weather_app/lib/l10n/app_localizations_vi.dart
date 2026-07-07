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
}
