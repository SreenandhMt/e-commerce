part of 'home_bloc.dart';

@freezed
class HomeState with _$HomeState {
  const factory HomeState.initial({
    @Default(false) bool isLoading,
    @Default([]) List<ProductModel> products,
    @Default(false) bool isFailure,
    @Default(null) String? errorMessage,
  }) = _Initial;
}
