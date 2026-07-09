import 'package:flutter/material.dart';
import 'package:weather_app/core/extensions/l10n_extension.dart';
import 'package:weather_app/theme/theme_context_ext.dart';

class PremiumSearchBar extends StatelessWidget {
  final TextEditingController controller;
  final FocusNode focusNode;
  final VoidCallback onCancel;
  final ValueChanged<String> onChanged;

  const PremiumSearchBar({
    super.key,
    required this.controller,
    required this.focusNode,
    required this.onCancel,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    // Detect if the app is currently in dark mode to adjust Google-style colors
    final isDark = Theme.of(context).brightness == Brightness.dark;

    // Google style colors
    final bgColor = isDark ? const Color(0xFF303134) : Colors.white;
    final textColor = isDark
        ? const Color(0xFFE8EAED)
        : const Color(0xFF202124);
    final hintColor = isDark
        ? const Color(0xFF9AA0A6)
        : const Color(0xFF5F6368);
    final iconColor = isDark
        ? const Color(0xFF9AA0A6)
        : const Color(0xFF5F6368);

    return Row(
      children: [
        Expanded(
          child: Container(
            height: 48, // Google search bars are usually 48px high
            decoration: BoxDecoration(
              color: bgColor,
              borderRadius: BorderRadius.circular(
                24,
              ), // Pill shape is signature Google
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withAlpha(isDark ? 50 : 20),
                  blurRadius: 8,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: TextField(
              controller: controller,
              focusNode: focusNode,
              onChanged: onChanged,
              style: TextStyle(
                color: textColor,
                fontSize: 16,
                fontWeight: FontWeight.w400,
              ),
              decoration: InputDecoration(
                hintText: context.l10n.searchCityPlaceholder,
                hintStyle: TextStyle(color: hintColor, fontSize: 16),
                prefixIcon: Padding(
                  padding: const EdgeInsets.only(left: 8.0),
                  child: Icon(Icons.search, color: iconColor, size: 22),
                ),
                suffixIcon: controller.text.isNotEmpty
                    ? IconButton(
                        icon: Icon(
                          Icons.close, // Google uses 'close' not 'cancel'
                          color: iconColor,
                          size: 20,
                        ),
                        onPressed: () {
                          controller.clear();
                          onChanged('');
                        },
                      )
                    : null,
                border: InputBorder.none,
                contentPadding: const EdgeInsets.symmetric(
                  vertical: 13,
                  horizontal: 16,
                ),
              ),
              cursorColor:
                  context.colors.primary, // Use app primary color for cursor
            ),
          ),
        ),
        const SizedBox(width: 8),
        TextButton(
          onPressed: onCancel,
          style: TextButton.styleFrom(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
            foregroundColor: context
                .glass
                .textPrimary, // Keep cancel button white/glass-matching
          ),
          child: Text(
            context.l10n.cancel,
            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
          ),
        ),
      ],
    );
  }
}
