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

import '../../../../../data/dtos/add_currency/add_currency_request.dart';

part 'search_state.dart';

part 'search_event.dart';

part 'search_bloc.freezed.dart';

@injectable
class SearchBloc extends Bloc<SearchEvent, SearchState> {
  SearchBloc(
    this._productRepo,
  ) : super(const SearchState()) {
    on<SearchTextChangedEvent>(onSearchTextChanged, transformer: _debounce());
    on<SearchRemoteTextChangedEvent>(_onSearchRemoteTextChanged, transformer: _debounce());
    on<GetLocalProducts>(_onGetLocalProducts);
    on<GetRemoteProducts>(onGetRemoteProducts);
    on<NullRemoteProducts>(_nullRemoteProducts);
    on<LoadMoreSearch>(_onLoadMore);
    on<AddCurrencyEvent>(_addCurrencyRequest);
    on<DeleteProductEvent>(_deleteProduct);
    on<ExportProducts>(_exportProducts);
    on<ExportInventoryProducts>(_exportInventoryProducts);
    on<ExportProductPrice>(_exportProductPrice);
    on<SelectSupplier>(_onSelectSupplier);
    on<SelectCategory>(_onSelectCategory);
  }

  final ProductsRepository _productRepo;

  EventTransformer<T> _debounce<T>() {
    return (events, mapper) => events.debounceTime(const Duration(milliseconds: 300)).switchMap(mapper);
  }

  Future<void> onSearchTextChanged(
    SearchTextChangedEvent event,
    Emitter<SearchState> emit,
  ) async {
    if (state.status == StateStatus.loading) return;

    final value = event.value;
    var request = state.request?.copyWith(title: value) ?? SearchRequest(title: value, page: 1);

    if (state.products != null && value.isEmpty) {
      request = request.copyWith(page: request.page! + 1);
    } else {
      request = request.copyWith(page: 1);
    }

    emit(state.copyWith(status: StateStatus.loading));

    try {
      final res = await _productRepo.search(request, null);
      emit(state.copyWith(
        status: StateStatus.loaded,
        products:
            request.page == 1 ? res : state.products!.copyWith(results: [...state.products!.results, ...res.results]),
        request: request,
      ));
    } catch (e) {
      debugPrint(e.toString());
    }
  }

  Future<void> _onSearchRemoteTextChanged(
    SearchRemoteTextChangedEvent event,
    Emitter<SearchState> emit,
  ) async {
    final value = event.value;
    var request = SearchRequest(
      title: value,
      orderBy: '-created_at',
      page: 1,
      stockId: event.stockId,
      categoryId: event.categoryId,
      supplierId: event.supplierId,
    );
    request = request.copyWith(page: 1);

    emit(state.copyWith(status: StateStatus.loading));

    try {
      final res = await _productRepo.searchRemote(request);
      emit(state.copyWith(
        status: StateStatus.loaded,
        products:
            request.page == 1 ? res : state.products!.copyWith(results: [...state.products!.results, ...res.results]),
        request: request,
      ));
    } catch (e) {
      debugPrint(e.toString());
    }
  }

  Future<void> _onGetLocalProducts(
    GetLocalProducts event,
    Emitter<SearchState> emit,
  ) async {
    emit(state.copyWith(status: StateStatus.loading));
    try {
      final res = await _productRepo.getLocalProducts(1);
      emit(state.copyWith(status: StateStatus.loaded, products: res));
    } catch (e) {
      debugPrint(e.toString());
    }
  }

  Future<void> onGetRemoteProducts(
    GetRemoteProducts event,
    Emitter<SearchState> emit,
  ) async {
    try {
      emit(
        state.copyWith(
            status: StateStatus.loading,
            products: PaginatedDto<ProductDto>(
              results: [],
              pageNumber: 1,
              pageSize: 100,
              totalPages: 0,
              count: 0,
            )),
      );
      emit(state.copyWith(status: StateStatus.loading));
      final res = await _productRepo.getRemoteProducts(1);
      Future.delayed(const Duration(seconds: 2), () async {});
      emit(state.copyWith(status: StateStatus.loaded, products: res));
    } catch (e, s) {
      debugPrint(s.toString());
    }
  }

  Future<void> _nullRemoteProducts(
    NullRemoteProducts event,
    Emitter<SearchState> emit,
  ) async {
    emit(state.copyWith(status: StateStatus.loading));
    try {
      Future.delayed(const Duration(seconds: 5), () async {
        emit(
          state.copyWith(
              status: StateStatus.loading,
              products: PaginatedDto<ProductDto>(
                results: [],
                pageNumber: 1,
                pageSize: 100,
                totalPages: 0,
                count: 0,
              )),
        );
      });
    } catch (e, s) {
      debugPrint(s.toString());
    }
    emit(state.copyWith(status: StateStatus.loaded));
  }

  Future<void> _onLoadMore(
    LoadMoreSearch event,
    Emitter<SearchState> emit,
  ) async {
    if (state.status == StateStatus.loadingMore) return;

    try {
      emit(state.copyWith(status: StateStatus.loadingMore));
      final data = state.products?.results ?? [];
      final nextPage = (state.products?.pageNumber ?? 0) + 1;
      final res = event.remote
          ? await _productRepo
              .searchRemote(state.request?.copyWith(page: nextPage) ?? SearchRequest(title: '', page: 1))
          : await _productRepo.getLocalProducts(nextPage);

      emit(state.copyWith(
        status: StateStatus.loaded,
        products: res.copyWith(results: [...data, ...res.results]),
      ));
    } catch (e) {
      debugPrint(e.toString());
    }
  }

  Future<void> _deleteProduct(
    DeleteProductEvent event,
    Emitter<SearchState> emit,
  ) async {
    emit(state.copyWith(status: StateStatus.loading));
    try {
      await _productRepo.deleteProduct(event.productId);
    } catch (e) {
      //
    }
    add(SearchRemoteTextChangedEvent(''));
    emit(state.copyWith(status: StateStatus.loaded));
  }

  Future<void> _addCurrencyRequest(
    AddCurrencyEvent event,
    Emitter<SearchState> emit,
  ) async {
    emit(state.copyWith(status: StateStatus.loading));
    try {
      await _productRepo.updateCurrency(event.addCurrencyRequest);
    } catch (e) {
      debugPrint(e.toString());
    }
  }

  Future<void> _exportProducts(
    ExportProducts event,
    Emitter<SearchState> emit,
  ) async {
    emit(state.copyWith(status: StateStatus.loading));
    try {
      await _productRepo.exportProduct();
    } catch (e) {
      debugPrint(e.toString());
    }
    emit(state.copyWith(status: StateStatus.loaded));
  }

  Future<void> _exportInventoryProducts(
    ExportInventoryProducts event,
    Emitter<SearchState> emit,
  ) async {
    emit(state.copyWith(status: StateStatus.loading));
    try {
      await _productRepo.exportInventoryProducts(event.id!, categoryId: state.request?.categoryId);
    } catch (e) {
      debugPrint(e.toString());
    }
    emit(state.copyWith(status: StateStatus.loaded));
  }

  Future<void> _exportProductPrice(
    ExportProductPrice event,
    Emitter<SearchState> emit,
  ) async {
    emit(state.copyWith(status: StateStatus.loading));
    try {
      await _productRepo.exportProductPrice(
        productId: event.productId!,
        quantity: event.quantity!,
      );
    } catch (e) {
      debugPrint(e.toString());
    }
    emit(state.copyWith(status: StateStatus.loaded));
  }

  FutureOr<void> _onSelectSupplier(
    SelectSupplier event,
    Emitter<SearchState> emit,
  ) {
    emit(state.copyWith(status: StateStatus.loading));
    emit(state.copyWith(request: state.request?.copyWith(supplierId: event.id)));
    emit(state.copyWith(status: StateStatus.loaded));
  }

  FutureOr<void> _onSelectCategory(
    SelectCategory event,
    Emitter<SearchState> emit,
  ) {
    emit(state.copyWith(status: StateStatus.loading));
    emit(state.copyWith(request: state.request?.copyWith(categoryId: event.id)));
    emit(state.copyWith(status: StateStatus.loaded));
  }
}
