part of 'favorites_bloc.dart';

@freezed
class FavoritesEvent with _$FavoritesEvent {
  const factory FavoritesEvent.loadFavorites() = LoadFavorites;
  const factory FavoritesEvent.toggleFavorite({required int productId}) = ToggleFavorite;
}
