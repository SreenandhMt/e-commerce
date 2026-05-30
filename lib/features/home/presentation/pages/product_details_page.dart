import 'package:ecommerce_app/features/favorites/presentation/bloc/favorites_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/theme/app_colors.dart';
import '../../data/models/product_model.dart';

class ProductDetailsPage extends StatelessWidget {
  final ProductModel product;

  const ProductDetailsPage({super.key, required this.product});

  // Dynamically generate high-end mock specifications based on product category
  List<String> _getMockSpecifications(String category) {
    final cat = category.toLowerCase();
    if (cat.contains('clothing')) {
      return [
        'COMPOSITION: 100% Organic Cotton',
        'SOURCE: Ethically manufactured',
        'CARE: Cold gentle machine wash',
      ];
    } else if (cat.contains('jewelery') || cat.contains('jewelry')) {
      return [
        'MATERIALS: 925 Sterling Silver / 18k Plating',
        'DETAIL: Handcrafted by local artisans',
        'CARE: Clean with a soft dry cloth',
      ];
    } else if (cat.contains('electronics')) {
      return [
        'SPECS: Certified premium components',
        'WARRANTY: 1-Year manufacturer coverage',
        'INCLUDES: Standard power accessories',
      ];
    } else {
      return [
        'QUALITY: Inspected for premium grade',
        'PACKAGING: Recyclable sustainable material',
        'DESIGN: Engineered for daily utility',
      ];
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    // Monochrome theme configuration linked to AppColors
    final backgroundColor = theme.scaffoldBackgroundColor;
    final primaryTextColor = isDark ? Colors.white : AppColors.textPrimaryLight;
    final secondaryTextColor = isDark ? AppColors.textSecondaryDark : AppColors.textSecondaryLight;
    final borderColor = isDark ? AppColors.borderDark : AppColors.borderLight;
    final imgBgColor = isDark ? AppColors.imageBgDark : AppColors.imageBgLight;

    final buttonBgColor = isDark ? Colors.white : AppColors.primaryLight;
    final buttonTextColor = isDark ? AppColors.primaryLight : Colors.white;

    final mockSpecs = _getMockSpecifications(product.category);

    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: AppBar(
        backgroundColor: backgroundColor,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: primaryTextColor, size: 20),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: Text(
          'DETAILS',
          style: TextStyle(
            color: primaryTextColor,
            fontSize: 14,
            fontWeight: FontWeight.bold,
            letterSpacing: 4.0,
          ),
        ),
        centerTitle: true,
        actions: [
          BlocBuilder<FavoritesBloc, FavoritesState>(
            builder: (context, state) {
              final isFavorite = state.favoriteIds.contains(product.id);
              return IconButton(
                icon: Icon(
                  isFavorite ? Icons.favorite : Icons.favorite_border,
                  color: isFavorite
                      ? (isDark ? Colors.white : const Color(0xFF111111))
                      : primaryTextColor,
                  size: 20,
                ),
                onPressed: () {
                  context.read<FavoritesBloc>().add(
                    FavoritesEvent.toggleFavorite(productId: product.id),
                  );
                },
              );
            },
          ),
        ],
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(1),
          child: Container(color: borderColor, height: 1),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // 1. Large Aspect-Ratio Product Image Frame
            AspectRatio(
              aspectRatio: 1.1,
              child: Container(
                decoration: BoxDecoration(
                  color: imgBgColor,
                  border: Border(
                    bottom: BorderSide(color: borderColor, width: 0.5),
                  ),
                ),
                padding: const EdgeInsets.symmetric(
                  horizontal: 32.0,
                  vertical: 24.0,
                ),
                child: Image.network(
                  product.image,
                  key: ValueKey(product.image), // Stable key prevents reloading flicker on rebuild
                  fit: BoxFit.contain,
                  width: double.infinity,
                  height: double.infinity,
                  cacheWidth: 600, // Decodes at target width for high density displays
                  loadingBuilder: (context, child, loadingProgress) {
                    if (loadingProgress == null) return child;
                    return Center(
                      child: SizedBox(
                        height: 20,
                        width: 20,
                        child: CircularProgressIndicator(
                          color: primaryTextColor,
                          strokeWidth: 1.0,
                        ),
                      ),
                    );
                  },
                  errorBuilder: (context, error, stackTrace) {
                    return Icon(
                      Icons.image_not_supported_outlined,
                      color: secondaryTextColor,
                      size: 32,
                    );
                  },
                ),
              ),
            ),

            // 2. Product Details Content Block
            Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 24.0,
                vertical: 32.0,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Category Header
                  Text(
                    product.category.toUpperCase(),
                    style: TextStyle(
                      fontSize: 10,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 2.0,
                      color: secondaryTextColor,
                    ),
                  ),
                  const SizedBox(height: 12),

                  // Product Title
                  Text(
                    product.title,
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w400,
                      color: primaryTextColor,
                      height: 1.3,
                    ),
                  ),
                  const SizedBox(height: 16),

                  // Sleek Minimalist Rating Badge
                  Container(
                    padding: const EdgeInsets.symmetric(vertical: 4),
                    child: Row(
                      children: [
                        Text(
                          '${product.rating.rate} ★',
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                            color: primaryTextColor,
                          ),
                        ),
                        Text(
                          '   •   ${product.rating.count} REVIEWS',
                          style: TextStyle(
                            fontSize: 10.5,
                            fontWeight: FontWeight.bold,
                            letterSpacing: 1.5,
                            color: secondaryTextColor,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 28),

                  Container(height: 0.5, color: borderColor),
                  const SizedBox(height: 28),

                  // Description Title
                  Text(
                    'THE STORY',
                    style: TextStyle(
                      fontSize: 10,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 2.0,
                      color: secondaryTextColor,
                    ),
                  ),
                  const SizedBox(height: 12),

                  // Description Body Text
                  Text(
                    product.description,
                    style: TextStyle(
                      fontSize: 14,
                      color: primaryTextColor,
                      height: 1.6,
                      letterSpacing: 0.2,
                    ),
                  ),
                  const SizedBox(height: 28),

                  Container(height: 0.5, color: borderColor),
                  const SizedBox(height: 28),

                  // Specifications Header
                  Text(
                    'SPECIFICATIONS',
                    style: TextStyle(
                      fontSize: 10,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 2.0,
                      color: secondaryTextColor,
                    ),
                  ),
                  const SizedBox(height: 16),

                  // Dynamic Specification Bullets
                  ...mockSpecs.map((spec) {
                    final split = spec.split(':');
                    final label = split[0];
                    final value = split.sublist(1).join(':');

                    return Padding(
                      padding: const EdgeInsets.only(bottom: 12.0),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SizedBox(
                            width: 100,
                            child: Text(
                              label,
                              style: TextStyle(
                                fontSize: 10.5,
                                fontWeight: FontWeight.bold,
                                letterSpacing: 1.0,
                                color: secondaryTextColor,
                              ),
                            ),
                          ),
                          Expanded(
                            child: Text(
                              value.trim(),
                              style: TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.w500,
                                color: primaryTextColor,
                              ),
                            ),
                          ),
                        ],
                      ),
                    );
                  }),
                  const SizedBox(height: 24),
                ],
              ),
            ),
          ],
        ),
      ),

      // 3. Sticky Bottom Action Bar (Price + Add to Bag)
      bottomNavigationBar: Container(
        height: 80,
        decoration: BoxDecoration(
          color: backgroundColor,
          border: Border(top: BorderSide(color: borderColor, width: 0.5)),
        ),
        padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 14.0),
        child: Row(
          children: [
            // Floating Price Label
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'TOTAL PRICE',
                  style: TextStyle(
                    fontSize: 8.5,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 1.5,
                    color: secondaryTextColor,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  '\$${product.price.toStringAsFixed(2)}',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 0.5,
                    color: primaryTextColor,
                  ),
                ),
              ],
            ),
            const SizedBox(width: 24),

            // Solid monochrome Add to Bag button (Sharp edges)
            Expanded(
              child: SizedBox(
                height: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    // Quick feedback stub
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(
                          'Added to cart.',
                          style: TextStyle(
                            color: buttonTextColor,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        backgroundColor: buttonBgColor,
                        behavior: SnackBarBehavior.floating,
                        duration: const Duration(seconds: 1),
                      ),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: buttonBgColor,
                    foregroundColor: buttonTextColor,
                    shape: const RoundedRectangleBorder(
                      borderRadius: BorderRadius.zero,
                    ),
                    elevation: 0,
                  ),
                  child: const Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'ADD TO BAG',
                        style: TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.bold,
                          letterSpacing: 2.0,
                        ),
                      ),
                      SizedBox(width: 8),
                      Icon(Icons.shopping_bag_outlined, size: 16),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
