import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

import '../../data/repositories/auth_repository.dart';

part 'auth_event.dart';
part 'auth_state.dart';
part 'auth_bloc.freezed.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final AuthRepository _authRepository;

  AuthBloc({required AuthRepository authRepository})
      : _authRepository = authRepository,
        super(const AuthState.initial()) {
    on<LoginSubmitted>(_onLoginSubmitted);
  }

  Future<void> _onLoginSubmitted(
    LoginSubmitted event,
    Emitter<AuthState> emit,
  ) async {
    // Set loading state and clear previous errors/success flags
    emit(state.copyWith(
      isLoading: true,
      isSuccess: false,
      isFailure: false,
      errorMessage: null,
    ));

    try {
      await _authRepository.login(
        email: event.email,
        password: event.password,
      );

      // Succeeded
      emit(state.copyWith(
        isLoading: false,
        isSuccess: true,
        isFailure: false,
      ));
    } catch (e) {
      // Failed
      emit(state.copyWith(
        isLoading: false,
        isSuccess: false,
        isFailure: true,
        errorMessage: e.toString().replaceFirst('Exception: ', ''),
      ));
    }
  }
}
