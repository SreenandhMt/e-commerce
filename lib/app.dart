import 'package:ecommerce_app/core/theme/app_theme.dart';
import 'package:ecommerce_app/shared/routes/app_router.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'features/favorites/data/repositories/favorites_repository.dart';
import 'features/favorites/presentation/bloc/favorites_bloc.dart';
import 'features/home/data/repositories/product_repository.dart';
import 'features/home/data/services/product_api_service.dart';
import 'features/home/presentation/bloc/home_bloc.dart';

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiRepositoryProvider(
      providers: [
        RepositoryProvider<ProductRepository>(
          create: (context) => ProductRepositoryImpl(
            apiService: ProductApiServiceImpl(),
          ),
        ),
        RepositoryProvider<FavoritesRepository>(
          create: (context) => FavoritesRepositoryImpl(),
        ),
      ],
      child: MultiBlocProvider(
        providers: [
          BlocProvider<HomeBloc>(
            create: (context) => HomeBloc(
              productRepository: context.read<ProductRepository>(),
            )..add(const HomeEvent.fetchProducts()),
          ),
          BlocProvider<FavoritesBloc>(
            create: (context) => FavoritesBloc(
              repository: context.read<FavoritesRepository>(),
            )..add(const FavoritesEvent.loadFavorites()),
          ),
        ],
        child: MaterialApp.router(
          debugShowCheckedModeBanner: false,
          routerConfig: AppRouter.router,
          theme: AppTheme.lightTheme,
          darkTheme: AppTheme.darkTheme,
        ),
      ),
    );
  }
}
