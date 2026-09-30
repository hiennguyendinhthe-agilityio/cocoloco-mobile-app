import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../core/theme/app_colors.dart';
import '../core/theme/app_typography.dart';
import '../data/providers/products_provider.dart';
import '../models/product.dart';

class AdminProductFormModal extends ConsumerStatefulWidget {
  final Product? product; // If null: Create mode. If provided: Edit mode.

  const AdminProductFormModal({super.key, this.product});

  static Future<Product?> show(BuildContext context, {Product? product}) {
    return showModalBottomSheet<Product>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
      ),
      builder: (_) => AdminProductFormModal(product: product),
    );
  }

  @override
  ConsumerState<AdminProductFormModal> createState() => _AdminProductFormModalState();
}

class _AdminProductFormModalState extends ConsumerState<AdminProductFormModal> {
  final _formKey = GlobalKey<FormState>();

  late final TextEditingController _nameController;
  late final TextEditingController _priceController;
  late final TextEditingController _descriptionController;
  late final TextEditingController _imageUrlController;

  late String _selectedCategory;
  late bool _isAvailable;
  bool _isSubmitting = false;

  final List<Map<String, String>> _categories = const [
    {'value': 'coffee', 'label': '☕ Coffee'},
    {'value': 'pastry', 'label': '🥐 Bakery'},
    {'value': 'bundle', 'label': '🎁 Combos'},
    {'value': 'seasonal', 'label': '✨ Specials'},
  ];

  @override
  void initState() {
    super.initState();
    final p = widget.product;
    _nameController = TextEditingController(text: p?.name ?? '');
    _priceController = TextEditingController(
      text: p != null ? p.price.toStringAsFixed(2) : '',
    );
    _descriptionController = TextEditingController(text: p?.description ?? '');
    _imageUrlController = TextEditingController(text: p?.imageUrl ?? '');

    final existingCat = p?.category.toLowerCase() ?? 'coffee';
    final isValidCat = _categories.any((c) => c['value'] == existingCat);
    _selectedCategory = isValidCat ? existingCat : 'coffee';
    _isAvailable = p?.isAvailable ?? true;

    _imageUrlController.addListener(() {
      setState(() {});
    });
  }

  @override
  void dispose() {
    _nameController.dispose();
    _priceController.dispose();
    _descriptionController.dispose();
    _imageUrlController.dispose();
    super.dispose();
  }

  bool get _isEditMode => widget.product != null;

  Future<void> _handleSubmit() async {
    if (!_formKey.currentState!.validate()) return;

    final price = double.tryParse(_priceController.text.trim());
    if (price == null || price <= 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please enter a valid price (> 0 USD)'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    setState(() => _isSubmitting = true);

    final payload = <String, dynamic>{
      'name': _nameController.text.trim(),
      'price': price.toStringAsFixed(2),
      'category': _selectedCategory,
      'is_available': _isAvailable,
    };

    final desc = _descriptionController.text.trim();
    if (desc.isNotEmpty) {
      payload['description'] = desc;
    }

    final img = _imageUrlController.text.trim();
    if (img.isNotEmpty) {
      payload['image_url'] = img;
    }

    try {
      Product result;
      if (_isEditMode) {
        result = await ref
            .read(productsProvider.notifier)
            .editProduct(widget.product!.id, payload);
      } else {
        result = await ref
            .read(productsProvider.notifier)
            .addProduct(payload);
      }

      if (mounted) {
        Navigator.pop(context, result);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Row(
              children: [
                const Icon(Icons.check_circle_rounded, color: Colors.white),
                const SizedBox(width: 10),
                Text(
                  _isEditMode
                      ? 'Updated "${result.name}" successfully!'
                      : 'Added "${result.name}" successfully!',
                ),
              ],
            ),
            backgroundColor: const Color(0xFF2E7D32),
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        setState(() => _isSubmitting = false);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error: ${e.toString().replaceAll('Exception: ', '')}'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final bottomInset = MediaQuery.of(context).viewInsets.bottom;

    return Padding(
      padding: EdgeInsets.fromLTRB(20, 16, 20, 20 + bottomInset),
      child: Form(
        key: _formKey,
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              // Grab handle
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

              // Header
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    _isEditMode ? 'Edit Product' : 'Add New Product',
                    style: const TextStyle(
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
                    child: Text(
                      _isEditMode ? 'EDIT MODE' : 'NEW ITEM',
                      style: const TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.w800,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 6),
              Text(
                _isEditMode
                    ? 'Update price, description, or availability status'
                    : 'Enter product details to make it available on the menu',
                style: const TextStyle(fontSize: 13, color: AppColors.textSecondary),
              ),
              const Divider(height: 24),

              // 1. Product Name
              _buildFieldLabel('Product Name *'),
              TextFormField(
                controller: _nameController,
                decoration: _inputDecoration('e.g., Royal Salt Cream Coffee', Icons.coffee_rounded),
                validator: (val) {
                  if (val == null || val.trim().isEmpty) {
                    return 'Product name cannot be empty';
                  }
                  if (val.trim().length < 2) {
                    return 'Product name must be at least 2 characters';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 14),

              // 2. Price & Category
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    flex: 4,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _buildFieldLabel('Price (USD) *'),
                        TextFormField(
                          controller: _priceController,
                          keyboardType: const TextInputType.numberWithOptions(decimal: true),
                          decoration: _inputDecoration('3.50', Icons.attach_money_rounded),
                          validator: (val) {
                            if (val == null || val.trim().isEmpty) {
                              return 'Price required';
                            }
                            final numVal = double.tryParse(val.trim());
                            if (numVal == null || numVal <= 0) {
                              return 'Price > 0';
                            }
                            return null;
                          },
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    flex: 6,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _buildFieldLabel('Category *'),
                        DropdownButtonFormField<String>(
                          initialValue: _selectedCategory,
                          decoration: _inputDecoration('', Icons.category_rounded),
                          items: _categories.map((c) {
                            return DropdownMenuItem<String>(
                              value: c['value'],
                              child: Text(
                                c['label']!,
                                style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600),
                              ),
                            );
                          }).toList(),
                          onChanged: (val) {
                            if (val != null) {
                              setState(() => _selectedCategory = val);
                            }
                          },
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 14),

              // 3. Image URL & Live Preview
              _buildFieldLabel('Image URL'),
              TextFormField(
                controller: _imageUrlController,
                keyboardType: TextInputType.url,
                decoration: _inputDecoration('https://images.unsplash.com/...', Icons.image_rounded),
                validator: (val) {
                  if (val != null && val.trim().isNotEmpty) {
                    final clean = val.trim();
                    if (!clean.startsWith('http://') && !clean.startsWith('https://')) {
                      return 'URL must start with http:// or https://';
                    }
                  }
                  return null;
                },
              ),
              if (_imageUrlController.text.trim().isNotEmpty) ...[
                const SizedBox(height: 8),
                _buildImagePreview(_imageUrlController.text.trim()),
              ],
              const SizedBox(height: 14),

              // 4. Description
              _buildFieldLabel('Description & Flavor Notes'),
              TextFormField(
                controller: _descriptionController,
                maxLines: 2,
                decoration: _inputDecoration(
                  'Rich, aromatic espresso blended with creamy salt foam...',
                  Icons.description_rounded,
                ),
              ),
              const SizedBox(height: 14),

              // 5. Availability Status (is_available)
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                decoration: BoxDecoration(
                  color: const Color(0xFFFBF9F5),
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: const Color(0xFFECE7DE)),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        Icon(
                          _isAvailable ? Icons.check_circle_rounded : Icons.pause_circle_rounded,
                          color: _isAvailable ? const Color(0xFF2E7D32) : const Color(0xFFC53030),
                        ),
                        const SizedBox(width: 10),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              _isAvailable ? 'Available' : 'Unavailable',
                              style: TextStyle(
                                fontWeight: FontWeight.w700,
                                fontSize: 14,
                                color: _isAvailable ? const Color(0xFF2E7D32) : const Color(0xFFC53030),
                              ),
                            ),
                            Text(
                              _isAvailable
                                  ? 'Customers can view and order this item'
                                  : 'Item will be hidden from customer menu',
                              style: const TextStyle(fontSize: 12, color: AppColors.textSecondary),
                            ),
                          ],
                        ),
                      ],
                    ),
                    Switch.adaptive(
                      value: _isAvailable,
                      activeTrackColor: AppColors.primary,
                      onChanged: (val) {
                        setState(() => _isAvailable = val);
                      },
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),

              // 6. Action Button
              SizedBox(
                width: double.infinity,
                height: 52,
                child: ElevatedButton.icon(
                  onPressed: _isSubmitting ? null : _handleSubmit,
                  icon: _isSubmitting
                      ? const SizedBox(
                          width: 20,
                          height: 20,
                          child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2),
                        )
                      : Icon(
                          _isEditMode ? Icons.save_rounded : Icons.add_circle_rounded,
                          color: Colors.white,
                        ),
                  label: Text(
                    _isSubmitting
                        ? 'Saving to server...'
                        : (_isEditMode ? 'Save Changes' : 'Add to Menu'),
                    style: const TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w700,
                      color: Colors.white,
                    ),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
                    elevation: 0,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildFieldLabel(String label) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 6),
      child: Text(
        label,
        style: const TextStyle(
          fontSize: 13,
          fontWeight: FontWeight.w700,
          color: AppColors.textDark,
        ),
      ),
    );
  }

  InputDecoration _inputDecoration(String hint, IconData icon) {
    return InputDecoration(
      hintText: hint,
      hintStyle: const TextStyle(fontSize: 13, color: Color(0xFFA8A096)),
      prefixIcon: Icon(icon, size: 20, color: AppColors.primary),
      filled: true,
      fillColor: const Color(0xFFFBF9F5),
      contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(16),
        borderSide: const BorderSide(color: Color(0xFFECE7DE)),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(16),
        borderSide: const BorderSide(color: Color(0xFFECE7DE)),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(16),
        borderSide: const BorderSide(color: AppColors.primary, width: 1.5),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(16),
        borderSide: const BorderSide(color: Colors.red),
      ),
    );
  }

  Widget _buildImagePreview(String url) {
    return Container(
      height: 120,
      width: double.infinity,
      decoration: BoxDecoration(
        color: const Color(0xFFF3EFE8),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFE2DDD5)),
      ),
      clipBehavior: Clip.antiAlias,
      child: Image.network(
        url,
        fit: BoxFit.cover,
        errorBuilder: (context, error, stackTrace) => const Center(
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(Icons.broken_image_rounded, color: Colors.grey),
              SizedBox(width: 8),
              Text(
                'Unable to load image from this URL',
                style: TextStyle(fontSize: 12, color: Colors.grey),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
