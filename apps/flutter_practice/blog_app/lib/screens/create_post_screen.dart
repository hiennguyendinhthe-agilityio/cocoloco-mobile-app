import 'package:flutter/material.dart';
import '../core/constants/mock_data.dart';
import '../core/theme/app_colors.dart';
import '../core/theme/app_typography.dart';
import '../widgets/app_button.dart';

class CreatePostScreen extends StatefulWidget {
  final VoidCallback? onPostCreated;

  const CreatePostScreen({super.key, this.onPostCreated});

  @override
  State<CreatePostScreen> createState() => _CreatePostScreenState();
}

class _CreatePostScreenState extends State<CreatePostScreen> {
  final _titleController = TextEditingController();
  final _contentController = TextEditingController();
  final Set<String> _selectedCategoryIds = {};
  bool _isLoading = false;

  @override
  void dispose() {
    _titleController.dispose();
    _contentController.dispose();
    super.dispose();
  }

  void _handlePublish() async {
    final title = _titleController.text.trim();
    final content = _contentController.text.trim();

    if (title.isEmpty || content.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter both title and story content.')),
      );
      return;
    }

    setState(() => _isLoading = true);
    await Future.delayed(const Duration(milliseconds: 800)); // Simulate async save
    setState(() => _isLoading = false);

    // Show Success Modal / Dialog
    if (!mounted) return;
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return Dialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
          backgroundColor: AppColors.surface,
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: 72,
                  height: 72,
                  decoration: const BoxDecoration(
                    color: AppColors.accentSoft,
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(Icons.check_circle_rounded, color: AppColors.primary, size: 40),
                ),
                const SizedBox(height: 18),
                Text('Published!', style: AppTypography.displaySmall.copyWith(fontSize: 22)),
                const SizedBox(height: 8),
                Text(
                  'Your story is now live and viewable by the community.',
                  textAlign: TextAlign.center,
                  style: AppTypography.bodyMedium,
                ),
                const SizedBox(height: 24),
                AppButton(
                  label: 'Back to Feed',
                  onPressed: () {
                    Navigator.pop(context); // Close dialog
                    _titleController.clear();
                    _contentController.clear();
                    widget.onPostCreated?.call();
                  },
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: Text('New Story', style: AppTypography.displaySmall.copyWith(fontSize: 20)),
        centerTitle: true,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(20, 12, 20, 100),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Title Field
              TextField(
                controller: _titleController,
                style: AppTypography.displayMedium.copyWith(fontSize: 24),
                decoration: InputDecoration(
                  hintText: 'Story Title...',
                  hintStyle: AppTypography.displayMedium.copyWith(
                    fontSize: 24,
                    color: AppColors.textTertiary,
                  ),
                  border: InputBorder.none,
                ),
                maxLines: null,
              ),
              const SizedBox(height: 16),

              // Categories Selector
              Text('Select Categories', style: AppTypography.labelLarge),
              const SizedBox(height: 8),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: MockData.categories.where((c) => c.slug != 'all').map((cat) {
                  final isSelected = _selectedCategoryIds.contains(cat.id);
                  return FilterChip(
                    label: Text(cat.name),
                    selected: isSelected,
                    onSelected: (selected) {
                      setState(() {
                        if (selected) {
                          _selectedCategoryIds.add(cat.id);
                        } else {
                          _selectedCategoryIds.remove(cat.id);
                        }
                      });
                    },
                    selectedColor: AppColors.primary,
                    checkmarkColor: Colors.white,
                    labelStyle: AppTypography.labelSmall.copyWith(
                      color: isSelected ? Colors.white : AppColors.textSecondary,
                    ),
                    backgroundColor: AppColors.surface,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                      side: BorderSide(
                        color: isSelected ? AppColors.primary : AppColors.border,
                      ),
                    ),
                  );
                }).toList(),
              ),
              const SizedBox(height: 24),

              // Content Field
              TextField(
                controller: _contentController,
                style: AppTypography.bodyLarge.copyWith(height: 1.6),
                decoration: InputDecoration(
                  hintText: 'Tell your story...',
                  hintStyle: AppTypography.bodyLarge.copyWith(color: AppColors.textTertiary),
                  border: InputBorder.none,
                ),
                maxLines: null,
                minLines: 8,
              ),
              const SizedBox(height: 32),

              // Publish CTA Button
              AppButton(
                label: 'Publish Story',
                isLoading: _isLoading,
                icon: Icons.send_rounded,
                onPressed: _handlePublish,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
