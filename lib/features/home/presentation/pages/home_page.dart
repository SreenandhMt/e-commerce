import 'package:ecommerce_app/shared/routes/route_names.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../data/repositories/product_repository.dart';
import '../../data/services/product_api_service.dart';
import '../bloc/home_bloc.dart';
import '../widgets/product_item_card.dart';
import '../widgets/product_shimmer.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => HomeBloc(
        productRepository: ProductRepositoryImpl(
          apiService: ProductApiServiceImpl(),
        ),
      )..add(const HomeEvent.fetchProducts()),
      child: const HomeView(),
    );
  }
}

class HomeView extends StatefulWidget {
  const HomeView({super.key});

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  String _selectedCategory = 'ALL';

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    // Monochrome theme configuration
    final backgroundColor = isDark ? const Color(0xFF121212) : Colors.white;
    final primaryTextColor = isDark ? Colors.white : const Color(0xFF111111);
    final secondaryTextColor = isDark ? const Color(0xFF8E8E93) : const Color(0xFF6E6E73);
    final borderColor = isDark ? const Color(0xFF2C2C2E) : const Color(0xFFE5E5EA);

    final buttonBgColor = isDark ? Colors.white : const Color(0xFF111111);
    final buttonTextColor = isDark ? const Color(0xFF111111) : Colors.white;

    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: AppBar(
        backgroundColor: backgroundColor,
        elevation: 0,
        title: Text(
          'STORE',
          style: TextStyle(
            color: primaryTextColor,
            fontSize: 16,
            fontWeight: FontWeight.bold,
            letterSpacing: 4.0,
          ),
        ),
        centerTitle: true,
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(1),
          child: Container(
            color: borderColor,
            height: 1,
          ),
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.shopping_bag_outlined, color: primaryTextColor, size: 20),
            onPressed: () {},
          ),
        ],
      ),
      body: BlocBuilder<HomeBloc, HomeState>(
        builder: (context, state) {
          // 1. Loading Phase
          if (state.isLoading) {
            return Column(
              children: [
                // Shimmer for Category Selector
                _buildCategoryShimmer(baseColor: isDark ? const Color(0xFF1C1C1E) : const Color(0xFFF2F2F7)),
                Expanded(
                  child: GridView.builder(
                    padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
                    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      mainAxisSpacing: 24,
                      crossAxisSpacing: 16,
                      childAspectRatio: 0.55,
                    ),
                    itemCount: 6,
                    itemBuilder: (context, index) => const ProductShimmer(),
                  ),
                ),
              ],
            );
          }

          // 2. Error Phase
          if (state.isFailure) {
            return Padding(
              padding: const EdgeInsets.all(32.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Icon(
                    Icons.error_outline,
                    color: isDark ? const Color(0xFFDC2626) : const Color(0xFFEF4444),
                    size: 32,
                  ),
                  const SizedBox(height: 16),
                  Text(
                    state.errorMessage ?? 'An error occurred while loading products.',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: secondaryTextColor,
                      fontSize: 13,
                      height: 1.5,
                    ),
                  ),
                  const SizedBox(height: 24),
                  Center(
                    child: SizedBox(
                      height: 44,
                      width: 140,
                      child: ElevatedButton(
                        onPressed: () {
                          context.read<HomeBloc>().add(const HomeEvent.fetchProducts());
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: buttonBgColor,
                          foregroundColor: buttonTextColor,
                          shape: const RoundedRectangleBorder(
                            borderRadius: BorderRadius.zero,
                          ),
                          elevation: 0,
                        ),
                        child: const Text(
                          'RETRY',
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                            letterSpacing: 1.5,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            );
          }

          // 3. Success Phase
          final products = state.products;
          if (products.isEmpty) {
            return Center(
              child: Text(
                'No products available.',
                style: TextStyle(color: secondaryTextColor, fontSize: 13),
              ),
            );
          }

          // Extract unique categories from products list dynamically
          final categories = [
            'ALL',
            ...products.map((p) => p.category.toUpperCase()).toSet().toList()
          ];

          // Filter product list locally based on selected category
          final filteredProducts = _selectedCategory == 'ALL'
              ? products
              : products.where((p) => p.category.toUpperCase() == _selectedCategory).toList();

          return Column(
            children: [
              // Premium Category Bar
              Container(
                height: 50,
                decoration: BoxDecoration(
                  border: Border(bottom: BorderSide(color: borderColor, width: 0.5)),
                ),
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  itemCount: categories.length,
                  itemBuilder: (context, index) {
                    final cat = categories[index];
                    final isSelected = _selectedCategory == cat;

                    return GestureDetector(
                      onTap: () {
                        setState(() {
                          _selectedCategory = cat;
                        });
                      },
                      child: Container(
                        alignment: Alignment.center,
                        padding: const EdgeInsets.symmetric(horizontal: 12),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              cat,
                              style: TextStyle(
                                fontSize: 10.5,
                                fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
                                letterSpacing: 1.5,
                                color: isSelected ? primaryTextColor : secondaryTextColor,
                              ),
                            ),
                            if (isSelected) ...[
                              const SizedBox(height: 4),
                              Container(
                                height: 1.5,
                                width: 12,
                                color: primaryTextColor,
                              ),
                            ],
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),

              // Product Catalogue Grid
              Expanded(
                child: RefreshIndicator(
                  color: primaryTextColor,
                  backgroundColor: backgroundColor,
                  onRefresh: () async {
                    context.read<HomeBloc>().add(const HomeEvent.fetchProducts());
                  },
                  child: GridView.builder(
                    padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 24),
                    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      mainAxisSpacing: 24,
                      crossAxisSpacing: 16,
                      childAspectRatio: 0.55,
                    ),
                    itemCount: filteredProducts.length,
                    itemBuilder: (context, index) {
                      final product = filteredProducts[index];
                      return ProductItemCard(
                        product: product,
                        onTap: () {
                          context.push(RouteNames.productDetails, extra: product);
                        },
                      );
                    },
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  // Category Selector Loading Shimmer Box
  Widget _buildCategoryShimmer({required Color baseColor}) {
    return Container(
      height: 50,
      padding: const EdgeInsets.symmetric(horizontal: 24),
      alignment: Alignment.centerLeft,
      child: Row(
        children: List.generate(4, (index) {
          return Container(
            margin: const EdgeInsets.only(right: 20),
            height: 14,
            width: 60,
            decoration: BoxDecoration(
              color: baseColor,
              borderRadius: BorderRadius.circular(2),
            ),
          );
        }),
      ),
    );
  }
}
