import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

import '../../../home/data/models/product_model.dart';
import '../../data/repositories/favorites_repository.dart';

part 'favorites_event.dart';
part 'favorites_state.dart';
part 'favorites_bloc.freezed.dart';

class FavoritesBloc extends Bloc<FavoritesEvent, FavoritesState> {
  final FavoritesRepository _repository;

  FavoritesBloc({required FavoritesRepository repository})
      : _repository = repository,
        super(const FavoritesState.initial()) {
    on<LoadFavorites>(_onLoadFavorites);
    on<ToggleFavorite>(_onToggleFavorite);
  }

  void _onLoadFavorites(
    LoadFavorites event,
    Emitter<FavoritesState> emit,
  ) {
    final ids = _repository.getFavoriteIds();
    final products = _repository.getFavoriteProducts();
    emit(state.copyWith(
      favoriteIds: ids,
      favoriteProducts: products,
    ));
  }

  Future<void> _onToggleFavorite(
    ToggleFavorite event,
    Emitter<FavoritesState> emit,
  ) async {
    await _repository.toggleFavorite(event.productId);
    final ids = _repository.getFavoriteIds();
    final products = _repository.getFavoriteProducts();
    emit(state.copyWith(
      favoriteIds: ids,
      favoriteProducts: products,
    ));
  }
}
