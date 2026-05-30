import 'package:flutter/material.dart';

class ProductShimmer extends StatefulWidget {
  const ProductShimmer({super.key});

  @override
  State<ProductShimmer> createState() => _ProductShimmerState();
}

class _ProductShimmerState extends State<ProductShimmer>
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
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    final baseColor = isDark ? const Color(0xFF1C1C1E) : const Color(0xFFF2F2F7);
    final borderColor = isDark ? const Color(0xFF2C2C2E) : const Color(0xFFE5E5EA);

    return AnimatedBuilder(
      animation: _animation,
      builder: (context, child) {
        return Opacity(
          opacity: _animation.value,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Image container placeholder
              AspectRatio(
                aspectRatio: 1.0,
                child: Container(
                  decoration: BoxDecoration(
                    color: baseColor,
                    borderRadius: BorderRadius.zero,
                    border: Border.all(color: borderColor, width: 0.5),
                  ),
                  width: double.infinity,
                ),
              ),
              const SizedBox(height: 12),

              // Category label placeholder
              Container(
                height: 8,
                width: 50,
                color: baseColor,
              ),
              const SizedBox(height: 8),

              // Title line 1 placeholder
              Container(
                height: 12,
                width: double.infinity,
                color: baseColor,
              ),
              const SizedBox(height: 6),

              // Title line 2 placeholder
              Container(
                height: 12,
                width: 100,
                color: baseColor,
              ),
              const SizedBox(height: 8),

              // Price label placeholder
              Container(
                height: 14,
                width: 40,
                color: baseColor,
              ),
            ],
          ),
        );
      },
    );
  }
}
