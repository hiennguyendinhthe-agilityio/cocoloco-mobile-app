import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../core/localization/app_localizations.dart';
import '../core/theme/app_theme.dart';
import '../data/providers/products_provider.dart';
import '../data/repositories/product_repository.dart';
import '../models/product.dart';
import '../widgets/admin_product_form_modal.dart';

class AdminProductsScreen extends ConsumerStatefulWidget {
  const AdminProductsScreen({super.key});

  static Future<void> show(BuildContext context) {
    return showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Theme.of(context).colorScheme.surface,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
      ),
      builder: (_) => const AdminProductsScreen(),
    );
  }

  @override
  ConsumerState<AdminProductsScreen> createState() => _AdminProductsScreenState();
}

class _AdminProductsScreenState extends ConsumerState<AdminProductsScreen> {
  final TextEditingController _searchController = TextEditingController();

  List<Map<String, String>> _getCategories(BuildContext context) {
    final l10n = context.l10n;
    return [
      {'id': 'all', 'label': l10n.categoryAll},
      {'id': 'coffee', 'label': l10n.categoryCoffee},
      {'id': 'pastry', 'label': l10n.categoryBakery},
      {'id': 'bundle', 'label': l10n.categoryCombos},
      {'id': 'seasonal', 'label': l10n.categorySpecials},
    ];
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _confirmDelete(Product product) {
    final l10n = context.l10n;
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
        backgroundColor: context.colorScheme.surface,
        title: Row(
          children: [
            const Icon(Icons.delete_forever_rounded, color: Color(0xFFC53030), size: 24),
            const SizedBox(width: 10),
            Text(
              l10n.delete,
              style: TextStyle(
                fontFamily: AppTypography.fontFamily,
                fontWeight: FontWeight.w800,
                fontSize: 18,
                color: context.colorScheme.onSurface,
              ),
            ),
          ],
        ),
        content: Text(
          '${l10n.deleteProductConfirm(product.name)}\n\n${l10n.deleteProductWarning}',
          style: TextStyle(fontSize: 14, color: context.colorScheme.onSurfaceVariant, height: 1.4),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: Text(l10n.cancel, style: const TextStyle(color: Color(0xFF7A7067))),
          ),
          ElevatedButton(
            onPressed: () async {
              Navigator.pop(ctx);
              await _executeDelete(product);
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFFC53030),
              elevation: 0,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
            ),
            child: Text(l10n.delete, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w700)),
          ),
        ],
      ),
    );
  }

  Future<void> _executeDelete(Product product) async {
    try {
      await ref.read(productsProvider.notifier).removeProduct(product.id);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Row(
              children: [
                const Icon(Icons.check_circle_rounded, color: Colors.white),
                const SizedBox(width: 10),
                Text('Deleted "${product.name}" successfully!'),
              ],
            ),
            backgroundColor: const Color(0xFF2E7D32),
          ),
        );
      }
    } on ProductConflictException {
      if (mounted) {
        _showConflictResolutionDialog(product);
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error: ${e.toString().replaceAll('Exception: ', '')}'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  void _showConflictResolutionDialog(Product product) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
        backgroundColor: context.colorScheme.surface,
        title: Row(
          children: [
            const Icon(Icons.shield_outlined, color: Color(0xFFE65100), size: 24),
            const SizedBox(width: 10),
            Text(
              'Item Has Existing Orders',
              style: TextStyle(
                fontFamily: AppTypography.fontFamily,
                fontWeight: FontWeight.w800,
                fontSize: 17,
                color: context.colorScheme.onSurface,
              ),
            ),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Item "${product.name}" is present in customer order history and cannot be hard-deleted to preserve accounting data integrity.\n\nWould you like to set its status to "Unavailable" (hidden from customer menu) instead?',
              style: TextStyle(fontSize: 13.5, color: context.colorScheme.onSurfaceVariant, height: 1.45),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: Text('Close', style: TextStyle(color: context.colorScheme.onSurfaceVariant)),
          ),
          ElevatedButton.icon(
            onPressed: () async {
              Navigator.pop(ctx);
              await ref.read(productsProvider.notifier).editProduct(product.id, {
                'is_available': false,
              });
              if (mounted) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('Hidden "${product.name}" from customer menu!'),
                    backgroundColor: const Color(0xFF2E7D32),
                  ),
                );
              }
            },
            icon: const Icon(Icons.visibility_off_rounded, color: Colors.white, size: 18),
            label: const Text('Make Unavailable', style: TextStyle(color: Colors.white, fontWeight: FontWeight.w700)),
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFFE65100),
              elevation: 0,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final productsState = ref.watch(productsProvider);
    final filtered = productsState.filteredProducts;

    return DraggableScrollableSheet(
      initialChildSize: 0.88,
      maxChildSize: 0.96,
      minChildSize: 0.5,
      expand: false,
      builder: (_, scrollController) {
        return Padding(
          padding: const EdgeInsets.fromLTRB(20, 8, 20, 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header Row
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Expanded(
                    child: Text(
                      context.l10n.adminProductsTitle,
                      style: const TextStyle(
                        fontFamily: AppTypography.fontFamily,
                        fontSize: 20,
                        fontWeight: FontWeight.w800,
                        color: AppColors.textDark,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  const SizedBox(width: 10),
                  ElevatedButton.icon(
                    onPressed: () => AdminProductFormModal.show(context),
                    icon: const Icon(Icons.add_rounded, size: 16, color: Colors.white),
                    label: Text(
                      context.l10n.addProduct,
                      style: const TextStyle(
                        fontSize: 12.5,
                        fontWeight: FontWeight.w700,
                        color: Colors.white,
                      ),
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primary,
                      elevation: 0,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                      minimumSize: const Size(0, 36),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 6),
              Text(
                context.l10n.adminProductsSubtitle,
                style: const TextStyle(fontSize: 13, color: AppColors.textSecondary),
              ),
              const SizedBox(height: 14),

              // Search Box
              TextField(
                controller: _searchController,
                onChanged: (val) {
                  ref.read(productsProvider.notifier).setSearchQuery(val);
                },
                decoration: InputDecoration(
                  hintText: context.l10n.searchPlaceholder,
                  hintStyle: const TextStyle(fontSize: 13, color: Color(0xFFA8A096)),
                  prefixIcon: const Icon(Icons.search_rounded, size: 20, color: AppColors.primary),
                  suffixIcon: _searchController.text.isNotEmpty
                      ? IconButton(
                          icon: const Icon(Icons.clear, size: 18),
                          onPressed: () {
                            _searchController.clear();
                            ref.read(productsProvider.notifier).setSearchQuery('');
                          },
                        )
                      : null,
                  filled: true,
                  fillColor: const Color(0xFFFBF9F5),
                  contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(16),
                    borderSide: const BorderSide(color: Color(0xFFECE7DE)),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(16),
                    borderSide: const BorderSide(color: Color(0xFFECE7DE)),
                  ),
                ),
              ),
              const SizedBox(height: 10),

              // Category Filter Chips
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                physics: const BouncingScrollPhysics(),
                child: Row(
                  children: _getCategories(context).map((c) {
                    final isSelected = productsState.selectedCategory == c['id'];
                    return Padding(
                      padding: const EdgeInsets.only(right: 8),
                      child: ChoiceChip(
                        label: Text(
                          c['label']!,
                          style: TextStyle(
                            fontSize: 12.5,
                            fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
                            color: isSelected ? Colors.white : AppColors.textDark,
                          ),
                        ),
                        selected: isSelected,
                        selectedColor: AppColors.primary,
                        backgroundColor: const Color(0xFFF3EFE8),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                        onSelected: (_) {
                          ref.read(productsProvider.notifier).setCategory(c['id']!);
                        },
                      ),
                    );
                  }).toList(),
                ),
              ),
              const Divider(height: 20),

              // Product List
              Expanded(
                child: productsState.isLoading
                    ? const Center(child: CircularProgressIndicator(color: AppColors.primary))
                    : filtered.isEmpty
                        ? Center(
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                const Icon(Icons.inventory_2_outlined, size: 48, color: Color(0xFFC5BDB0)),
                                const SizedBox(height: 10),
                                const Text(
                                  'No items found.',
                                  style: TextStyle(fontSize: 15, fontWeight: FontWeight.w700, color: AppColors.textDark),
                                ),
                                const SizedBox(height: 4),
                                const Text(
                                  'Click "Add Item" to add your first menu item',
                                  style: TextStyle(fontSize: 13, color: AppColors.textSecondary),
                                ),
                              ],
                            ),
                          )
                        : NotificationListener<ScrollNotification>(
                            onNotification: (scrollInfo) {
                              if (scrollInfo.metrics.pixels >=
                                  scrollInfo.metrics.maxScrollExtent - 150) {
                                ref
                                    .read(productsProvider.notifier)
                                    .loadMoreProducts();
                              }
                              return false;
                            },
                            child: ListView.separated(
                              controller: scrollController,
                              itemCount: filtered.length +
                                  (productsState.isLoadingMore ? 1 : 0),
                              separatorBuilder: (_, _) =>
                                  const SizedBox(height: 12),
                              itemBuilder: (context, index) {
                                if (index == filtered.length) {
                                  return const Center(
                                    child: Padding(
                                      padding:
                                          EdgeInsets.symmetric(vertical: 16),
                                      child: SizedBox(
                                        width: 24,
                                        height: 24,
                                        child: CircularProgressIndicator(
                                          strokeWidth: 2.5,
                                          color: AppColors.primary,
                                        ),
                                      ),
                                    ),
                                  );
                                }
                                final product = filtered[index];
                                return _buildProductRow(product);
                              },
                            ),
                          ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildProductRow(Product product) {
    final hasNetworkImg = product.imageUrl != null && product.imageUrl!.isNotEmpty;

    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: const Color(0xFFFBF9F5),
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: const Color(0xFFECE7DE)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // Thumbnail Image
          ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: SizedBox(
              width: 56,
              height: 56,
              child: hasNetworkImg
                  ? Image.network(
                      product.imageUrl!,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) => Image.asset(product.imageAsset, fit: BoxFit.cover),
                    )
                  : Image.asset(product.imageAsset, fit: BoxFit.cover),
            ),
          ),
          const SizedBox(width: 12),

          // Name, Category, Price
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        product.name,
                        style: const TextStyle(
                          fontWeight: FontWeight.w800,
                          fontSize: 15,
                          color: AppColors.textDark,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 4),
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                      decoration: BoxDecoration(
                        color: const Color(0xFFECE7DE),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                        product.category,
                        style: const TextStyle(fontSize: 10.5, fontWeight: FontWeight.w700, color: Color(0xFF5A524C)),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Text(
                      '\$${product.price.toStringAsFixed(2)}',
                      style: const TextStyle(
                        fontFamily: AppTypography.fontFamily,
                        fontWeight: FontWeight.w800,
                        fontSize: 14,
                        color: AppColors.primary,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),

          // Action Buttons: Toggle Switch, Edit, Delete
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Availability Toggle
              IconButton(
                tooltip: product.isAvailable ? 'Available' : 'Unavailable',
                icon: Icon(
                  product.isAvailable ? Icons.check_circle_rounded : Icons.pause_circle_rounded,
                  color: product.isAvailable ? const Color(0xFF2E7D32) : const Color(0xFFC53030),
                  size: 22,
                ),
                onPressed: () async {
                  await ref.read(productsProvider.notifier).toggleAvailability(product);
                },
              ),

              // Edit Button
              IconButton(
                tooltip: 'Edit item',
                icon: const Icon(Icons.edit_outlined, color: AppColors.primary, size: 20),
                onPressed: () {
                  AdminProductFormModal.show(context, product: product);
                },
              ),

              // Delete Button
              IconButton(
                tooltip: 'Delete item',
                icon: const Icon(Icons.delete_outline_rounded, color: Color(0xFFC53030), size: 20),
                onPressed: () => _confirmDelete(product),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
