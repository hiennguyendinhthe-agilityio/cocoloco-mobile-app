import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:weather_app/l10n/app_localizations.dart';
import 'package:weather_app/features/weather/domain/entities/forecast_entity.dart';
import 'package:weather_app/features/weather/presentation/widgets/precipitation_chart.dart';
import 'package:weather_app/features/weather/presentation/widgets/weather_line_chart.dart';

class DailyForecastDetailSheet extends StatefulWidget {
  final ForecastEntity forecast;
  final DateTime initialSelectedDate;

  const DailyForecastDetailSheet({
    super.key,
    required this.forecast,
    required this.initialSelectedDate,
  });

  @override
  State<DailyForecastDetailSheet> createState() =>
      _DailyForecastDetailSheetState();
}

class _DailyForecastDetailSheetState extends State<DailyForecastDetailSheet> {
  late DateTime _selectedDate;
  int _selectedSegment = 0; // 0 for Actual, 1 for Feels Like

  @override
  void initState() {
    super.initState();
    _selectedDate = widget.initialSelectedDate;
  }

  List<ForecastItemEntity> _getHourlyDataForSelectedDay() {
    final selectedDateStr = DateFormat('yyyy-MM-dd').format(_selectedDate);
    return widget.forecast.items.where((item) {
      final itemDateStr = DateFormat('yyyy-MM-dd').format(item.dateTime);
      return itemDateStr == selectedDateStr;
    }).toList();
  }

  List<DateTime> _getUniqueDays() {
    final Set<String> uniqueKeys = {};
    final List<DateTime> days = [];
    for (var item in widget.forecast.items) {
      final key = DateFormat('yyyy-MM-dd').format(item.dateTime);
      if (!uniqueKeys.contains(key)) {
        uniqueKeys.add(key);
        days.add(item.dateTime);
      }
    }
    return days;
  }

  @override
  Widget build(BuildContext context) {
    final uniqueDays = _getUniqueDays();
    final hourlyData = _getHourlyDataForSelectedDay();

    if (hourlyData.isEmpty) return const SizedBox();

    // Prepare chart data
    final temperatures = hourlyData.map((e) {
      return _selectedSegment == 0 ? e.temperature : e.feelsLike;
    }).toList();

    double minTemp = temperatures.isNotEmpty ? temperatures.first : 0;
    double maxTemp = temperatures.isNotEmpty ? temperatures.first : 0;
    for (var t in temperatures) {
      if (t < minTemp) minTemp = t;
      if (t > maxTemp) maxTemp = t;
    }

    final timeLabels = hourlyData
        .map((e) => DateFormat('HH').format(e.dateTime))
        .toList();
    final iconCodes = hourlyData.map((e) => e.iconCode).toList();
    final popPercentages = hourlyData.map((e) => e.pop * 100).toList();

    // Get dominant weather info for header
    final headerTempMax = hourlyData
        .map((e) => _selectedSegment == 0 ? e.maxTemp : e.feelsLike)
        .reduce((a, b) => a > b ? a : b);
    final headerTempMin = hourlyData
        .map((e) => _selectedSegment == 0 ? e.minTemp : e.feelsLike)
        .reduce((a, b) => a < b ? a : b);

    final iconFreq = <String, int>{};
    for (var item in hourlyData) {
      iconFreq[item.iconCode] = (iconFreq[item.iconCode] ?? 0) + 1;
    }
    String dominantIcon = hourlyData.first.iconCode;
    int maxIconCount = 0;
    iconFreq.forEach((icon, count) {
      if (count > maxIconCount) {
        maxIconCount = count;
        dominantIcon = icon;
      }
    });
    
    final colorScheme = Theme.of(context).colorScheme;

    return Container(
      decoration: BoxDecoration(
        color: colorScheme.surface,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
      ),
      child: SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const _SheetHeader(),
            Divider(color: colorScheme.onSurface.withValues(alpha: 0.1), height: 1),
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    _DateSelector(
                      uniqueDays: uniqueDays,
                      selectedDate: _selectedDate,
                      onDateSelected: (day) =>
                          setState(() => _selectedDate = day),
                    ),
                    _FullDateText(date: _selectedDate),
                    const SizedBox(height: 16),
                    Divider(color: colorScheme.onSurface.withValues(alpha: 0.1), height: 1),
                    const SizedBox(height: 16),
                    _WeatherSummary(
                      tempMax: headerTempMax,
                      tempMin: headerTempMin,
                      iconCode: dominantIcon,
                    ),
                    _TemperatureChartContainer(
                      temperatures: temperatures,
                      timeLabels: timeLabels,
                      iconCodes: iconCodes,
                      minTemp: minTemp,
                      maxTemp: maxTemp,
                    ),
                    _SegmentedControl(
                      selectedSegment: _selectedSegment,
                      onChanged: (val) =>
                          setState(() => _selectedSegment = val),
                    ),
                    const SizedBox(height: 16),
                    Divider(color: colorScheme.onSurface.withValues(alpha: 0.1), height: 1),
                    const SizedBox(height: 16),
                    _PrecipitationChartContainer(
                      popPercentages: popPercentages,
                      timeLabels: timeLabels,
                      date: _selectedDate,
                    ),
                    const SizedBox(height: 32),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ─── PRIVATE WIDGETS ─────────────────────────────────────────────────────────

class _SheetHeader extends StatelessWidget {
  const _SheetHeader();

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final l10n = AppLocalizations.of(context)!;
    
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
      child: Stack(
        alignment: Alignment.center,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.cloud_rounded, color: colorScheme.onSurface, size: 20),
              const SizedBox(width: 8),
              Text(
                l10n.weatherConditions,
                style: TextStyle(
                  color: colorScheme.onSurface,
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
          Positioned(
            right: 0,
            child: IconButton(
              icon: Container(
                padding: const EdgeInsets.all(4),
                decoration: BoxDecoration(
                  color: colorScheme.onSurface.withValues(alpha: 0.1),
                  shape: BoxShape.circle,
                ),
                child: Icon(Icons.close, color: colorScheme.onSurface, size: 18),
              ),
              onPressed: () => Navigator.of(context).pop(),
            ),
          ),
        ],
      ),
    );
  }
}

class _DateSelector extends StatelessWidget {
  final List<DateTime> uniqueDays;
  final DateTime selectedDate;
  final ValueChanged<DateTime> onDateSelected;

  const _DateSelector({
    required this.uniqueDays,
    required this.selectedDate,
    required this.onDateSelected,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    // We can use Localizations.localeOf(context).languageCode to get 'vi' or 'en'
    final locale = Localizations.localeOf(context).languageCode;
    
    return SizedBox(
      height: 110, // Increased height to prevent overflow with vertical padding
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 16.0),
        itemCount: uniqueDays.length,
        itemBuilder: (context, index) {
          final day = uniqueDays[index];
          final isSelected = DateFormat('yyyy-MM-dd').format(day) ==
              DateFormat('yyyy-MM-dd').format(selectedDate);
          final now = DateTime.now();
          final isToday = day.year == now.year &&
              day.month == now.month &&
              day.day == now.day;

          return GestureDetector(
            onTap: () => onDateSelected(day),
            child: Container(
              margin: const EdgeInsets.only(right: 24),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    DateFormat('EEE', locale).format(day).toUpperCase(),
                    style: TextStyle(
                      color: isSelected
                          ? colorScheme.onSurface
                          : (isToday
                              ? colorScheme.primary
                              : colorScheme.onSurface.withValues(alpha: 0.6)),
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Container(
                    width: 36,
                    height: 36,
                    decoration: BoxDecoration(
                      color: isSelected ? colorScheme.onSurface : Colors.transparent,
                      shape: BoxShape.circle,
                    ),
                    alignment: Alignment.center,
                    child: Text(
                      DateFormat('d').format(day),
                      style: TextStyle(
                        color: isSelected
                            ? colorScheme.surface
                            : (isToday
                                ? colorScheme.primary
                                : colorScheme.onSurface.withValues(alpha: 0.8)),
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}

class _FullDateText extends StatelessWidget {
  final DateTime date;

  const _FullDateText({required this.date});

  String _capitalize(String text) {
    if (text.isEmpty) return text;
    return text[0].toUpperCase() + text.substring(1);
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final locale = Localizations.localeOf(context).languageCode;
    
    // Use intl's built-in localized date format instead of hardcoded strings
    final dateStr = _capitalize(DateFormat.yMMMMEEEEd(locale).format(date));

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: Center(
        child: Text(
          dateStr,
          style: TextStyle(
            color: colorScheme.onSurface.withValues(alpha: 0.9),
            fontSize: 16,
          ),
        ),
      ),
    );
  }
}

class _WeatherSummary extends StatelessWidget {
  final double tempMax;
  final double tempMin;
  final String iconCode;

  const _WeatherSummary({
    required this.tempMax,
    required this.tempMin,
    required this.iconCode,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final l10n = AppLocalizations.of(context)!;
    
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '${tempMax.toStringAsFixed(0)}°',
                    style: TextStyle(
                      color: colorScheme.onSurface,
                      fontSize: 42,
                      height: 1.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    '${tempMin.toStringAsFixed(0)}°',
                    style: TextStyle(
                      color: colorScheme.onSurface.withValues(alpha: 0.5),
                      fontSize: 32,
                      height: 1.0,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
              const SizedBox(width: 8),
              Image.asset(
                'assets/icons/$iconCode.png',
                width: 32,
                height: 32,
                errorBuilder: (context, error, stackTrace) => Icon(
                  Icons.cloud,
                  color: colorScheme.onSurface,
                  size: 32,
                ),
              ),
              const Spacer(),
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: colorScheme.onSurface.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Row(
                  children: [
                    Icon(Icons.cloud_rounded, color: colorScheme.onSurface, size: 16),
                    const SizedBox(width: 4),
                    Icon(
                      Icons.keyboard_arrow_down_rounded,
                      color: colorScheme.onSurface,
                      size: 16,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 4.0),
          child: Text(
            l10n.celsius,
            style: TextStyle(
              color: colorScheme.onSurface.withValues(alpha: 0.6),
              fontSize: 14,
            ),
          ),
        ),
      ],
    );
  }
}

class _TemperatureChartContainer extends StatelessWidget {
  final List<double> temperatures;
  final List<String> timeLabels;
  final List<String> iconCodes;
  final double minTemp;
  final double maxTemp;

  const _TemperatureChartContainer({
    required this.temperatures,
    required this.timeLabels,
    required this.iconCodes,
    required this.minTemp,
    required this.maxTemp,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      decoration: BoxDecoration(
        color: colorScheme.onSurface.withValues(alpha: 0.05),
        borderRadius: BorderRadius.circular(16),
      ),
      child: WeatherLineChart(
        temperatures: temperatures,
        timeLabels: timeLabels,
        iconCodes: iconCodes,
        minTemp: minTemp,
        maxTemp: maxTemp,
      ),
    );
  }
}

class _SegmentedControl extends StatelessWidget {
  final int selectedSegment;
  final ValueChanged<int> onChanged;

  const _SegmentedControl({
    required this.selectedSegment,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final l10n = AppLocalizations.of(context)!;
    
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: CupertinoSlidingSegmentedControl<int>(
            backgroundColor: colorScheme.onSurface.withValues(alpha: 0.1),
            thumbColor: colorScheme.onSurface.withValues(alpha: 0.2),
            groupValue: selectedSegment,
            onValueChanged: (int? value) {
              if (value != null) onChanged(value);
            },
            children: {
              0: Padding(
                padding: const EdgeInsets.symmetric(vertical: 8.0),
                child: Text(
                  l10n.actual, 
                  style: TextStyle(
                    color: selectedSegment == 0 ? colorScheme.onSurface : colorScheme.onSurface.withValues(alpha: 0.7),
                    fontWeight: selectedSegment == 0
                        ? FontWeight.bold
                        : FontWeight.normal,
                  ),
                ),
              ),
              1: Padding(
                padding: const EdgeInsets.symmetric(vertical: 8.0),
                child: Text(
                  l10n.feelsLikeWeather, 
                  style: TextStyle(
                    color: selectedSegment == 1 ? colorScheme.onSurface : colorScheme.onSurface.withValues(alpha: 0.7),
                    fontWeight: selectedSegment == 1
                        ? FontWeight.bold
                        : FontWeight.normal,
                  ),
                ),
              ),
            },
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: Text(
            selectedSegment == 0 ? l10n.actualTempDesc : l10n.feelsLikeTempDesc,
            style: TextStyle(
              color: colorScheme.onSurface.withValues(alpha: 0.6),
              fontSize: 14,
            ),
          ),
        ),
      ],
    );
  }
}

class _PrecipitationChartContainer extends StatelessWidget {
  final List<double> popPercentages;
  final List<String> timeLabels;
  final DateTime date;

  const _PrecipitationChartContainer({
    required this.popPercentages,
    required this.timeLabels,
    required this.date,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final l10n = AppLocalizations.of(context)!;
    final locale = Localizations.localeOf(context).languageCode;
    final dayStr = DateFormat('EEEE', locale).format(date);
    
    // We split(' ').last for Vietnamese because it says 'thứ Hai', we just want 'Hai' to interpolate in 'vào thứ Hai'.
    // In English, it will just say 'Monday', so split(' ').last is still 'Monday'.
    // Wait, the localization string says "Probability of precipitation on {day}: {pop}%".
    // So if dayStr is 'Monday', it says "on Monday". If 'Hai', it says "vào thứ Hai".
    final formattedDay = locale == 'vi' ? dayStr.split(' ').last : dayStr;
    final popString = popPercentages.isNotEmpty ? popPercentages.first.toStringAsFixed(0) : '0';

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: Text(
            l10n.probabilityOfPrecip, 
            style: TextStyle(
              color: colorScheme.onSurface,
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 4.0),
          child: Text(
            l10n.probabilityOnDay(formattedDay, popString),
            style: TextStyle(
              color: colorScheme.onSurface.withValues(alpha: 0.6),
              fontSize: 14,
            ),
          ),
        ),
        Container(
          margin: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 16.0),
          decoration: BoxDecoration(
            color: colorScheme.onSurface.withValues(alpha: 0.05),
            borderRadius: BorderRadius.circular(16),
          ),
          child: PrecipitationChart(
            popPercentages: popPercentages,
            timeLabels: timeLabels,
          ),
        ),
      ],
    );
  }
}
