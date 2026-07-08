import 'package:flutter/material.dart';
import 'package:weather_app/features/weather/presentation/widgets/search/premium_search_bar.dart';
import 'package:weather_app/features/weather/presentation/widgets/search/search_active_view.dart';
import 'package:weather_app/features/weather/presentation/widgets/search/search_idle_view.dart';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:weather_app/features/weather/presentation/providers/search_providers.dart';

class WeatherSearchOverlay extends ConsumerStatefulWidget {
  final VoidCallback onCancel;

  const WeatherSearchOverlay({
    super.key,
    required this.onCancel,
  });

  @override
  ConsumerState<WeatherSearchOverlay> createState() => _WeatherSearchOverlayState();
}

class _WeatherSearchOverlayState extends ConsumerState<WeatherSearchOverlay> {
  final TextEditingController _searchController = TextEditingController();
  final FocusNode _searchFocusNode = FocusNode();

  @override
  void initState() {
    super.initState();
    // Auto focus when overlay is opened
    Future.delayed(const Duration(milliseconds: 100), () {
      if (mounted) {
        _searchFocusNode.requestFocus();
      }
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    _searchFocusNode.dispose();
    super.dispose();
  }

  void _onSearchChanged(String value) {
    ref.read(searchQueryProvider.notifier).state = value;
  }

  @override
  Widget build(BuildContext context) {
    final query = ref.watch(searchQueryProvider);

    return SafeArea(
      bottom: false,
      child: Column(
        children: [
          // Search Bar Section
          Padding(
            padding: const EdgeInsets.fromLTRB(24, 16, 24, 16),
            child: PremiumSearchBar(
              controller: _searchController,
              focusNode: _searchFocusNode,
              onCancel: () {
                ref.read(searchQueryProvider.notifier).state = '';
                widget.onCancel();
              },
              onChanged: _onSearchChanged,
            ),
          ),
          
          // Main Content Section
          Expanded(
            child: AnimatedSwitcher(
              duration: const Duration(milliseconds: 300),
              child: query.isEmpty
                  ? SearchIdleView(
                      key: const ValueKey('idle'),
                      onClose: widget.onCancel,
                    )
                  : SearchActiveView(
                      key: const ValueKey('active'),
                      onClose: widget.onCancel,
                    ),
            ),
          ),
        ],
      ),
    );
  }
}
