import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:hoomo_pos/core/enums/states.dart';
import 'package:hoomo_pos/data/dtos/pagination_dto.dart';
import 'package:hoomo_pos/data/dtos/product_dto.dart';
import 'package:hoomo_pos/data/dtos/search_request.dart';
import 'package:hoomo_pos/domain/repositories/products_repository.dart';
import 'package:injectable/injectable.dart';
import 'package:rxdart/rxdart.dart';

part 'fast_search_state.dart';

part 'fast_search_event.dart';

part 'fast_search_bloc.freezed.dart';

@injectable
class FastSearchBloc extends Bloc<FastSearchEvent, FastSearchState> {
  FastSearchBloc(
    this._productsRepo,
  ) : super(const FastSearchState()) {
    on<SearchTextChanged>(_onSearchTextChanged, transformer: _debounce());
    on<LoadMoreSearch>(_onLoadMore);
    on<UpdateCartState>(_onUpdateCartState);
    on<SetPriceLimit>(_onSetPriceLimit);
    on<SearchInit>(_onInit);
  }

  final ProductsRepository _productsRepo;

  EventTransformer<SearchTextChanged> _debounce<SearchTextChanged>() {
    return (events, mapper) => events.debounceTime(const Duration(milliseconds: 300)).switchMap(mapper);
  }

  Future<void> _onSearchTextChanged(SearchTextChanged event, Emitter<FastSearchState> emit) async {
    final String value = event.value;
    SearchRequest request =
        state.request?.copyWith(title: (value.isEmpty ? '' : value).toLowerCase(), page: value.isEmpty ? 1 : null) ??
            SearchRequest(
                stockId: event.id, title: (value.isEmpty ? '' : value).toLowerCase(), orderBy: '-created_at', page: 1);
    request = request.copyWith(page: 1);

    // final cartBloc = router.navigatorKey.currentContext!.read<CartCubit>();
    emit(state.copyWith(status: StateStatus.loading));

    try {
      final res = state.isLocalSearch
          ? await _productsRepo.search(request, state.priceLimit)
          : await _productsRepo.searchRemote(request.copyWith(priceTo: state.priceLimit));
      emit(state.copyWith(
        status: StateStatus.loaded,
        products: request.page == 1
            ? res
            : state.products!.copyWith(
                results: [...state.products!.results, ...res.results],
              ),
        request: request,
      ));
      // for (CartProductDto p
      //     in cartBloc.state.cartDto?.products?.results ?? []) {
      //   add(UpdateCartState(p.product!));
      // }
    } catch (e) {
      emit(state.copyWith(status: StateStatus.initial));

      debugPrint(e.toString());
    }
  }

  Future<void> _onLoadMore(LoadMoreSearch event, Emitter<FastSearchState> emit) async {
    if (state.status == StateStatus.loading) return;

    try {
      emit(state.copyWith(status: StateStatus.loading));
      final data = state.products?.results;

      final SearchRequest request = state.request?.copyWith(page: (state.request?.page ?? 0) + 1) ??
          SearchRequest(title: state.request?.title ?? '', orderBy: '-created_at', page: 1);

      final res = state.isLocalSearch
          ? await _productsRepo.search(request, state.priceLimit)
          : await _productsRepo.searchRemote(request.copyWith(priceTo: state.priceLimit));
      emit(state.copyWith(
        status: StateStatus.loaded,
        request: request,
        products: res.copyWith(results: [...(data ?? []), ...res.results]),
      ));
    } catch (e) {
      debugPrint(e.toString());
    }
  }

  void _onUpdateCartState(UpdateCartState event, Emitter<FastSearchState> emit) {
    final products = state.products!.results.map((e) {
      if (e.id == event.product.id) {
        return event.product.copyWith(inCart: !(event.product.inCart ?? false));
      }
      return e;
    }).toList();

    emit(state.copyWith(products: state.products!.copyWith(results: products)));
  }

  void _onSetPriceLimit(SetPriceLimit event, Emitter<FastSearchState> emit) {
    emit(state.copyWith(priceLimit: event.value));
    add(SearchTextChanged(state.request?.title ?? ''));
  }

  void _onInit(SearchInit event, Emitter<FastSearchState> emit) {
    emit(state.copyWith(isLocalSearch: event.isLocalSearch));
  }
}
