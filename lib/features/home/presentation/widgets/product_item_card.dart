import 'package:flutter/material.dart';
import '../../data/models/product_model.dart';

class ProductItemCard extends StatelessWidget {
  final ProductModel product;
  final VoidCallback? onTap;

  const ProductItemCard({
    super.key,
    required this.product,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    final primaryTextColor = isDark ? Colors.white : const Color(0xFF111111);
    final secondaryTextColor = isDark ? const Color(0xFF8E8E93) : const Color(0xFF6E6E73);
    final imgBgColor = isDark ? const Color(0xFF1A1A1A) : const Color(0xFFF7F7F7);
    final borderColor = isDark ? const Color(0xFF262626) : const Color(0xFFE5E5E5);

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
            child: Container(
              width: double.infinity,
              decoration: BoxDecoration(
                color: imgBgColor,
                borderRadius: BorderRadius.zero, // Sharp luxury edges
                border: Border.all(color: borderColor, width: 0.5),
              ),
              padding: const EdgeInsets.all(24.0),
              child: Image.network(
                product.image,
                fit: BoxFit.contain,
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
          ),
          const SizedBox(height: 12),

          // Category tag (Muted, letter-spaced)
          Text(
            product.category.toUpperCase(),
            style: TextStyle(
              fontSize: 9,
              fontWeight: FontWeight.bold,
              letterSpacing: 2.0,
              color: secondaryTextColor,
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
          const SizedBox(height: 4),

          // Title
          Text(
            product.title,
            style: TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w400,
              color: primaryTextColor,
              height: 1.3,
            ),
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
          const SizedBox(height: 6),

          // Price tag
          Text(
            '\$${product.price.toStringAsFixed(2)}',
            style: TextStyle(
              fontSize: 13,
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
