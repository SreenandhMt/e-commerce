import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

import '../../data/models/product_model.dart';
import '../../data/repositories/product_repository.dart';

part 'home_event.dart';
part 'home_state.dart';
part 'home_bloc.freezed.dart';

class HomeBloc extends Bloc<HomeEvent, HomeState> {
  final ProductRepository _productRepository;

  HomeBloc({required ProductRepository productRepository})
      : _productRepository = productRepository,
        super(const HomeState.initial()) {
    on<FetchProducts>(_onFetchProducts);
  }

  Future<void> _onFetchProducts(
    FetchProducts event,
    Emitter<HomeState> emit,
  ) async {
    emit(state.copyWith(
      isLoading: true,
      isFailure: false,
      errorMessage: null,
    ));

    try {
      final products = await _productRepository.getProducts();
      emit(state.copyWith(
        isLoading: false,
        products: products,
        isFailure: false,
      ));
    } catch (e) {
      emit(state.copyWith(
        isLoading: false,
        isFailure: true,
        errorMessage: e.toString().replaceFirst('Exception: ', ''),
      ));
    }
  }
}
