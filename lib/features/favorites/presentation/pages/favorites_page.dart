import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../bloc/favorites_bloc.dart';
import '../../../../shared/routes/route_names.dart';

class FavoritesPage extends StatelessWidget {
  const FavoritesPage({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    final backgroundColor = isDark ? const Color(0xFF121212) : Colors.white;
    final primaryTextColor = isDark ? Colors.white : const Color(0xFF111111);
    final secondaryTextColor = isDark ? const Color(0xFF8E8E93) : const Color(0xFF6E6E73);
    final borderColor = isDark ? const Color(0xFF2C2C2E) : const Color(0xFFE5E5EA);
    final imgBgColor = isDark ? const Color(0xFF1A1A1A) : const Color(0xFFF7F7F7);

    final buttonBgColor = isDark ? Colors.white : const Color(0xFF111111);
    final buttonTextColor = isDark ? const Color(0xFF111111) : Colors.white;

    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: AppBar(
        backgroundColor: backgroundColor,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: primaryTextColor, size: 20),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: BlocBuilder<FavoritesBloc, FavoritesState>(
          builder: (context, state) {
            final count = state.favoriteIds.length;
            return Text(
              'FAVORITES ${count > 0 ? "($count)" : ""}',
              style: TextStyle(
                color: primaryTextColor,
                fontSize: 14,
                fontWeight: FontWeight.bold,
                letterSpacing: 4.0,
              ),
            );
          },
        ),
        centerTitle: true,
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(1),
          child: Container(
            color: borderColor,
            height: 1,
          ),
        ),
      ),
      body: BlocBuilder<FavoritesBloc, FavoritesState>(
        builder: (context, state) {
          final favoriteProducts = state.favoriteProducts;

          if (favoriteProducts.isEmpty) {
            return Center(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 40.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.favorite_border_outlined,
                      color: secondaryTextColor.withOpacity(0.5),
                      size: 48,
                    ),
                    const SizedBox(height: 16),
                    Text(
                      'YOUR WISHLIST IS EMPTY',
                      style: TextStyle(
                        color: primaryTextColor,
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 2.0,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Explore our collection and save your favorite items here for quick access.',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: secondaryTextColor,
                        fontSize: 12,
                        height: 1.5,
                      ),
                    ),
                    const SizedBox(height: 32),
                    SizedBox(
                      height: 48,
                      width: 180,
                      child: ElevatedButton(
                        onPressed: () => Navigator.of(context).pop(),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: buttonBgColor,
                          foregroundColor: buttonTextColor,
                          shape: const RoundedRectangleBorder(
                            borderRadius: BorderRadius.zero,
                          ),
                          elevation: 0,
                        ),
                        child: const Text(
                          'DISCOVER',
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                            letterSpacing: 2.0,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            );
          }

          return ListView.separated(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 24),
            itemCount: favoriteProducts.length,
            separatorBuilder: (context, index) => Container(
              height: 0.5,
              color: borderColor,
              margin: const EdgeInsets.symmetric(vertical: 20),
            ),
            itemBuilder: (context, index) {
              final product = favoriteProducts[index];

              return InkWell(
                onTap: () {
                  context.push(RouteNames.productDetails, extra: product);
                },
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Product image frame
                    Container(
                      width: 90,
                      height: 90,
                      decoration: BoxDecoration(
                        color: imgBgColor,
                        border: Border.all(color: borderColor, width: 0.5),
                      ),
                      padding: const EdgeInsets.all(12),
                      child: Image.network(
                        product.image,
                        key: ValueKey(product.image), // Stable key prevents reloading flicker on rebuild
                        fit: BoxFit.contain,
                        width: double.infinity,
                        height: double.infinity,
                        cacheWidth: 200, // Decodes at target width for fast rendering and low memory footprint
                        errorBuilder: (context, error, stackTrace) => Icon(
                          Icons.image_not_supported_outlined,
                          color: secondaryTextColor,
                          size: 16,
                        ),
                      ),
                    ),
                    const SizedBox(width: 16),

                    // Product descriptions & actions
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    // Category tag
                                    Text(
                                      product.category.toUpperCase(),
                                      style: TextStyle(
                                        fontSize: 8.5,
                                        fontWeight: FontWeight.bold,
                                        letterSpacing: 1.5,
                                        color: secondaryTextColor,
                                      ),
                                    ),
                                    const SizedBox(height: 4),

                                    // Product Title
                                    Text(
                                      product.title,
                                      maxLines: 2,
                                      overflow: TextOverflow.ellipsis,
                                      style: TextStyle(
                                        fontSize: 13,
                                        fontWeight: FontWeight.w400,
                                        color: primaryTextColor,
                                        height: 1.3,
                                      ),
                                    ),
                                    const SizedBox(height: 6),

                                    // Price
                                    Text(
                                      '\$${product.price.toStringAsFixed(2)}',
                                      style: TextStyle(
                                        fontSize: 13,
                                        fontWeight: FontWeight.bold,
                                        color: primaryTextColor,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              const SizedBox(width: 8),

                              // Remove button
                              GestureDetector(
                                onTap: () {
                                  context.read<FavoritesBloc>().add(
                                        FavoritesEvent.toggleFavorite(
                                            productId: product.id),
                                      );
                                },
                                child: Padding(
                                  padding: const EdgeInsets.all(4.0),
                                  child: Icon(
                                    Icons.close,
                                    color: secondaryTextColor,
                                    size: 18,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 12),

                          // Quick Add to Bag
                          SizedBox(
                            height: 34,
                            width: 120,
                            child: ElevatedButton(
                              onPressed: () {
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
                                padding: const EdgeInsets.symmetric(horizontal: 12),
                              ),
                              child: const Text(
                                'ADD TO BAG',
                                style: TextStyle(
                                  fontSize: 10.5,
                                  fontWeight: FontWeight.bold,
                                  letterSpacing: 1.0,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              );
            },
          );
        },
      ),
    );
  }
}
