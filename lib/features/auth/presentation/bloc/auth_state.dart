part of 'auth_bloc.dart';

@freezed
class AuthState with _$AuthState {
  const factory AuthState.initial({
    @Default(false) bool isLoading,
    @Default(false) bool isSuccess,
    @Default(false) bool isFailure,
    @Default(null) String? errorMessage,
  }) = _Initial;
}
