import 'package:ecommerce_app/features/home/presentation/pages/home_page.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import 'route_names.dart';

final GlobalKey<NavigatorState> rootNavigatorKey = GlobalKey<NavigatorState>();

class AppRouter {
  static final router = GoRouter(
    navigatorKey: rootNavigatorKey,
    initialLocation: RouteNames.home,

    routes: [
      GoRoute(
        path: RouteNames.home,
        name: 'Home',
        builder: (context, state) => const HomePage(),
      ),
    ],
  );
}
