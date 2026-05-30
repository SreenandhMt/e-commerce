import 'package:flutter/material.dart';
import 'package:ecommerce_app/core/theme/app_colors.dart';
import 'package:ecommerce_app/features/home/data/models/product_model.dart';

class ProductItemCard extends StatelessWidget {
  final ProductModel product;
  final bool isFavorite;
  final VoidCallback? onFavoriteTap;
  final VoidCallback? onTap;

  const ProductItemCard({
    super.key,
    required this.product,
    this.isFavorite = false,
    this.onFavoriteTap,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    final primaryTextColor = isDark ? Colors.white : AppColors.textPrimaryLight;
    final secondaryTextColor = isDark ? AppColors.textSecondaryDark : AppColors.textSecondaryLight;
    final imgBgColor = isDark ? AppColors.imageBgDark : AppColors.imageBgLight;
    final borderColor = isDark ? AppColors.borderDark : AppColors.borderLight;

    return InkWell(
      onTap: onTap,
      splashColor: Colors.transparent,
      highlightColor: Colors.transparent,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Elegant Image Wrapper
          AspectRatio(
            aspectRatio: 1.0,
            child: Stack(
              children: [
                Container(
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: imgBgColor,
                    borderRadius: BorderRadius.zero, // Sharp luxury edges
                    border: Border.all(color: borderColor, width: 0.5),
                  ),
                  padding: const EdgeInsets.all(16.0), // Reduced from 24.0 for a larger, clearer image
                  child: Image.network(
                    product.image,
                    key: ValueKey(product.image), // Stable key prevents reloading flicker on rebuild
                    fit: BoxFit.contain,
                    width: double.infinity,
                    height: double.infinity,
                    cacheWidth: 300, // Decodes at target width for instant loading and low memory usage
                    loadingBuilder: (context, child, loadingProgress) {
                      if (loadingProgress == null) return child;
                      // Return a pulsing monochrome shimmer while loading
                      return const _ImageLoadingShimmer();
                    },
                    errorBuilder: (context, error, stackTrace) {
                      return Icon(
                        Icons.image_not_supported_outlined,
                        color: secondaryTextColor,
                        size: 20,
                      );
                    },
                  ),
                ),
                Positioned(
                  top: 8,
                  right: 8,
                  child: GestureDetector(
                    onTap: onFavoriteTap,
                    behavior: HitTestBehavior.opaque,
                    child: Container(
                      padding: const EdgeInsets.all(6),
                      color: Colors.transparent,
                      child: Icon(
                        isFavorite ? Icons.favorite : Icons.favorite_border,
                        size: 18,
                        color: isFavorite
                            ? (isDark ? Colors.white : const Color(0xFF111111))
                            : secondaryTextColor,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 8),

          // Category tag (Muted, letter-spaced)
          Text(
            product.category.toUpperCase(),
            style: TextStyle(
              fontSize: 8.5,
              fontWeight: FontWeight.bold,
              letterSpacing: 2.0,
              color: secondaryTextColor,
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
          const SizedBox(height: 3),

          // Title
          Text(
            product.title,
            style: TextStyle(
              fontSize: 12.5,
              fontWeight: FontWeight.w400,
              color: primaryTextColor,
              height: 1.25,
            ),
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
          const SizedBox(height: 5),

          // Price tag
          Text(
            '\$${product.price.toStringAsFixed(2)}',
            style: TextStyle(
              fontSize: 12.5,
              fontWeight: FontWeight.bold,
              letterSpacing: 0.5,
              color: primaryTextColor,
            ),
          ),
        ],
      ),
    );
  }
}

// Minimalist animating shimmer for image downloads
class _ImageLoadingShimmer extends StatefulWidget {
  const _ImageLoadingShimmer();

  @override
  State<_ImageLoadingShimmer> createState() => _ImageLoadingShimmerState();
}

class _ImageLoadingShimmerState extends State<_ImageLoadingShimmer>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1000),
    )..repeat(reverse: true);
    _animation = Tween<double>(begin: 0.3, end: 0.7).animate(_controller);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final shimmerColor = isDark ? const Color(0xFF2C2C2E) : const Color(0xFFE5E5EA);

    return AnimatedBuilder(
      animation: _animation,
      builder: (context, child) {
        return Opacity(
          opacity: _animation.value,
          child: Container(
            color: shimmerColor,
            width: double.infinity,
            height: double.infinity,
          ),
        );
      },
    );
  }
}
