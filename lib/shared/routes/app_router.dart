import 'package:ecommerce_app/features/auth/presentation/pages/login_page.dart';
import 'package:ecommerce_app/features/home/data/models/product_model.dart';
import 'package:ecommerce_app/features/home/presentation/pages/home_page.dart';
import 'package:ecommerce_app/features/home/presentation/pages/product_details_page.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import 'route_names.dart';

final GlobalKey<NavigatorState> rootNavigatorKey = GlobalKey<NavigatorState>();

class AppRouter {
  static final router = GoRouter(
    navigatorKey: rootNavigatorKey,
    initialLocation: RouteNames.login,

    routes: [
      GoRoute(
        path: RouteNames.login,
        name: 'Login',
        builder: (context, state) => const LoginPage(),
      ),
      GoRoute(
        path: RouteNames.home,
        name: 'Home',
        builder: (context, state) => const HomePage(),
      ),
      GoRoute(
        path: RouteNames.productDetails,
        name: 'ProductDetails',
        builder: (context, state) {
          final product = state.extra as ProductModel;
          return ProductDetailsPage(product: product);
        },
      ),
    ],
  );
}
