import 'dart:io' show File;
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import '../core/theme/app_colors.dart';
import '../core/theme/app_typography.dart';
import '../data/providers/products_provider.dart';
import '../data/repositories/product_repository.dart';
import '../models/product.dart';

class AdminProductFormModal extends ConsumerStatefulWidget {
  final Product? product; // If null: Create mode. If provided: Edit mode.

  const AdminProductFormModal({super.key, this.product});

  static Future<Product?> show(BuildContext context, {Product? product}) {
    return showModalBottomSheet<Product>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Theme.of(context).colorScheme.surface,
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

  final ImagePicker _imagePicker = ImagePicker();
  bool _isUploadingImage = false;
  XFile? _pickedLocalFile;

  final List<Map<String, String>> _presetImages = const [
    {
      'name': 'Cappuccino',
      'category': 'coffee',
      'url': 'https://images.unsplash.com/photo-1572442388796-11668ba67e53?auto=format&fit=crop&w=600&q=80',
    },
    {
      'name': 'Iced Latte',
      'category': 'coffee',
      'url': 'https://images.unsplash.com/photo-1517701604599-bb29b565090c?auto=format&fit=crop&w=600&q=80',
    },
    {
      'name': 'Matcha Cloud',
      'category': 'seasonal',
      'url': 'https://images.unsplash.com/photo-1536256263959-770b48d82b0a?auto=format&fit=crop&w=600&q=80',
    },
    {
      'name': 'French Croissant',
      'category': 'pastry',
      'url': 'https://images.unsplash.com/photo-1555507036-ab1f4038808a?auto=format&fit=crop&w=600&q=80',
    },
    {
      'name': 'Cold Brew Bottle',
      'category': 'coffee',
      'url': 'https://images.unsplash.com/photo-1517256064527-09c73fc73e38?auto=format&fit=crop&w=600&q=80',
    },
    {
      'name': 'Breakfast Bundle',
      'category': 'bundle',
      'url': 'https://images.unsplash.com/photo-1509440159596-0249088772ff?auto=format&fit=crop&w=600&q=80',
    },
    {
      'name': 'Berry Cheesecake',
      'category': 'pastry',
      'url': 'https://images.unsplash.com/photo-1533134242443-d4fd215305ad?auto=format&fit=crop&w=600&q=80',
    },
    {
      'name': 'Artisanal Bread',
      'category': 'pastry',
      'url': 'https://images.unsplash.com/photo-1589367920969-ab8e050bbb04?auto=format&fit=crop&w=600&q=80',
    },
  ];

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

  Future<void> _pickImage(ImageSource source) async {
    try {
      final picked = await _imagePicker.pickImage(
        source: source,
        imageQuality: 85,
        maxWidth: 1200,
        maxHeight: 1200,
      );
      if (picked == null) return;

      setState(() {
        _pickedLocalFile = picked;
        _isUploadingImage = true;
      });

      try {
        final uploadedUrl = await ProductRepository().uploadImage(picked);
        if (mounted) {
          setState(() {
            _imageUrlController.text = uploadedUrl;
            _isUploadingImage = false;
          });
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('✨ Image uploaded to Cocoloco server successfully!'),
              backgroundColor: Color(0xFF2E7D32),
            ),
          );
        }
      } catch (uploadError) {
        if (mounted) {
          setState(() {
            _isUploadingImage = false;
            _imageUrlController.text = picked.path;
          });
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Local image selected ($uploadError)'),
              backgroundColor: const Color(0xFFD97706),
            ),
          );
        }
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Could not access photos: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  void _openPresetLibrary() {
    showModalBottomSheet(
      context: context,
      backgroundColor: Theme.of(context).colorScheme.surface,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (ctx) {
        return Padding(
          padding: const EdgeInsets.fromLTRB(20, 16, 20, 24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Cocoloco Preset Library',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.w800),
                  ),
                  IconButton(
                    icon: const Icon(Icons.close_rounded),
                    onPressed: () => Navigator.pop(ctx),
                  ),
                ],
              ),
              const SizedBox(height: 6),
              const Text(
                'Tap any photo to instantly use it for this product item:',
                style: TextStyle(fontSize: 13, color: Colors.grey),
              ),
              const SizedBox(height: 16),
              SizedBox(
                height: 240,
                child: GridView.builder(
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 4,
                    crossAxisSpacing: 10,
                    mainAxisSpacing: 10,
                    childAspectRatio: 0.82,
                  ),
                  itemCount: _presetImages.length,
                  itemBuilder: (_, index) {
                    final item = _presetImages[index];
                    return InkWell(
                      borderRadius: BorderRadius.circular(12),
                      onTap: () {
                        setState(() {
                          _imageUrlController.text = item['url']!;
                          _pickedLocalFile = null;
                        });
                        Navigator.pop(ctx);
                      },
                      child: Column(
                        children: [
                          Expanded(
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(12),
                              child: Image.network(
                                item['url']!,
                                fit: BoxFit.cover,
                                errorBuilder: (_, __, ___) => Container(
                                  color: Colors.grey[200],
                                  child: const Icon(Icons.broken_image, size: 20),
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            item['name']!,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(fontSize: 10, fontWeight: FontWeight.w600),
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        );
      },
    );
  }

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
              // Header
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    _isEditMode ? 'Edit Product' : 'Add New Product',
                    style: TextStyle(
                      fontFamily: AppTypography.fontFamily,
                      fontSize: 20,
                      fontWeight: FontWeight.w800,
                      color: Theme.of(context).colorScheme.onSurface,
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                    decoration: BoxDecoration(
                      color: Theme.of(context).colorScheme.primary,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      _isEditMode ? 'EDIT MODE' : 'NEW ITEM',
                      style: TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.w800,
                        color: Theme.of(context).colorScheme.onPrimary,
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
                style: TextStyle(fontSize: 13, color: Theme.of(context).colorScheme.onSurfaceVariant),
              ),
              Divider(height: 24, color: Theme.of(context).colorScheme.outlineVariant),

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

              // 3. Product Photo & Multi-Source Picker
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  _buildFieldLabel('Product Image'),
                  if (_imageUrlController.text.isNotEmpty || _pickedLocalFile != null)
                    InkWell(
                      onTap: () {
                        setState(() {
                          _imageUrlController.clear();
                          _pickedLocalFile = null;
                        });
                      },
                      child: const Padding(
                        padding: EdgeInsets.symmetric(horizontal: 4, vertical: 2),
                        child: Text(
                          'Clear Photo',
                          style: TextStyle(fontSize: 12, color: Colors.red, fontWeight: FontWeight.w600),
                        ),
                      ),
                    ),
                ],
              ),
              const SizedBox(height: 2),
              Row(
                children: [
                  Expanded(
                    child: _buildImageSourceButton(
                      icon: Icons.photo_library_rounded,
                      label: 'Gallery',
                      onTap: () => _pickImage(ImageSource.gallery),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: _buildImageSourceButton(
                      icon: Icons.camera_alt_rounded,
                      label: 'Camera',
                      onTap: () => _pickImage(ImageSource.camera),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: _buildImageSourceButton(
                      icon: Icons.collections_rounded,
                      label: 'Presets',
                      onTap: _openPresetLibrary,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 10),

              if (_isUploadingImage)
                Container(
                  margin: const EdgeInsets.only(bottom: 10),
                  padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                  decoration: BoxDecoration(
                    color: const Color(0xFFFBF9F5),
                    borderRadius: BorderRadius.circular(14),
                    border: Border.all(color: AppColors.primary.withValues(alpha: 0.2)),
                  ),
                  child: Row(
                    children: [
                      const SizedBox(
                        width: 16,
                        height: 16,
                        child: CircularProgressIndicator(strokeWidth: 2),
                      ),
                      const SizedBox(width: 10),
                      Text(
                        'Uploading image to server...',
                        style: TextStyle(
                          fontSize: 12.5,
                          fontWeight: FontWeight.w600,
                          color: Theme.of(context).colorScheme.primary,
                        ),
                      ),
                    ],
                  ),
                ),

              if (_pickedLocalFile != null || _imageUrlController.text.trim().isNotEmpty) ...[
                _buildImagePreview(),
                const SizedBox(height: 10),
              ],

              TextFormField(
                controller: _imageUrlController,
                keyboardType: TextInputType.url,
                style: const TextStyle(fontSize: 12.5),
                decoration: _inputDecoration('Or enter image URL (https://...)', Icons.link_rounded),
                validator: (val) {
                  if (val != null && val.trim().isNotEmpty) {
                    final clean = val.trim();
                    if (!clean.startsWith('http://') && !clean.startsWith('https://') && !clean.startsWith('/')) {
                      return 'URL must start with http:// or https://';
                    }
                  }
                  return null;
                },
              ),
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

  Widget _buildImageSourceButton({
    required IconData icon,
    required String label,
    required VoidCallback onTap,
  }) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(14),
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 10),
          decoration: BoxDecoration(
            color: const Color(0xFFFBF9F5),
            borderRadius: BorderRadius.circular(14),
            border: Border.all(color: const Color(0xFFECE7DE)),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon, size: 18, color: AppColors.primary),
              const SizedBox(width: 6),
              Text(
                label,
                style: const TextStyle(
                  fontSize: 12.5,
                  fontWeight: FontWeight.w700,
                  color: AppColors.textDark,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildImagePreview() {
    Widget imageWidget;
    if (_pickedLocalFile != null) {
      if (kIsWeb) {
        imageWidget = Image.network(_pickedLocalFile!.path, fit: BoxFit.cover);
      } else {
        imageWidget = Image.file(File(_pickedLocalFile!.path), fit: BoxFit.cover);
      }
    } else {
      final url = _imageUrlController.text.trim();
      imageWidget = Image.network(
        url,
        fit: BoxFit.cover,
        errorBuilder: (context, error, stackTrace) => const Center(
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(Icons.broken_image_rounded, color: Colors.grey),
              SizedBox(width: 8),
              Text(
                'Unable to preview image',
                style: TextStyle(fontSize: 12, color: Colors.grey),
              ),
            ],
          ),
        ),
      );
    }

    return Stack(
      children: [
        Container(
          height: 130,
          width: double.infinity,
          decoration: BoxDecoration(
            color: const Color(0xFFF3EFE8),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: const Color(0xFFE2DDD5)),
          ),
          clipBehavior: Clip.antiAlias,
          child: imageWidget,
        ),
        Positioned(
          top: 8,
          right: 8,
          child: Material(
            color: Colors.black54,
            shape: const CircleBorder(),
            child: InkWell(
              customBorder: const CircleBorder(),
              onTap: () {
                setState(() {
                  _imageUrlController.clear();
                  _pickedLocalFile = null;
                });
              },
              child: const Padding(
                padding: EdgeInsets.all(5),
                child: Icon(Icons.close_rounded, size: 16, color: Colors.white),
              ),
            ),
          ),
        ),
        Positioned(
          bottom: 8,
          left: 8,
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            decoration: BoxDecoration(
              color: Colors.black.withValues(alpha: 0.65),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  _pickedLocalFile != null ? Icons.photo_rounded : Icons.cloud_done_rounded,
                  size: 12,
                  color: Colors.white,
                ),
                const SizedBox(width: 4),
                Text(
                  _pickedLocalFile != null ? 'LOCAL PHOTO' : 'IMAGE READY',
                  style: const TextStyle(
                    fontSize: 10,
                    fontWeight: FontWeight.w700,
                    color: Colors.white,
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
