import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:injectable/injectable.dart';
import 'package:rxdart/rxdart.dart';

import '../../../../../core/enums/states.dart';
import '../../../../../data/dtos/pagination_dto.dart';
import '../../../../../data/dtos/supplies_1c/search_supplies.dart';
import '../../../../../data/dtos/supplies_1c/supplies_1c.dart';
import '../../../../../data/dtos/supplies_1c/supplies_1c_products.dart';
import '../../../../../domain/repositories/stock_repository.dart';

part 'supplies_1c_event.dart';

part 'supplies_1c_state.dart';

part 'supplies_1c_bloc.freezed.dart';

@lazySingleton
class Supplies1cBloc extends Bloc<Supplies1cEvent, Supplies1cState> {
  Supplies1cBloc(this._stockRepository)
      : super(
          _Supplies1cState(),
        ) {
    on<SearchTextChanged>(_onSearchTextChanged, transformer: _debounce());
    on<LoadMore>(_onLoadMore);
    on<UpdateState>(_onUpdateCompanyState);
    on<GetSuppliesProducts>(_suppliesProducts);
    on<_ConductSupplies1C>(_conductSupplies1C);

    // Запускаем начальный поиск
    add(SearchTextChanged(''));
  }

  final StockRepository _stockRepository;

  EventTransformer<T> _debounce<T>() {
    return (events, mapper) => events
        .debounceTime(const Duration(milliseconds: 300))
        .switchMap(mapper);
  }

  Future<void> _onSearchTextChanged(
      SearchTextChanged event, Emitter<Supplies1cState> emit) async {
    if (state.status == StateStatus.loading) return;

    var value = event.value;
    var request = state.request?.copyWith(search: value) ??
        SearchSupplies1C(
          search: value,
        );

    request = request.copyWith(page: 1);

    emit(state.copyWith(status: StateStatus.loading));

    try {
      final res = await _stockRepository.getSupplies1C(request);
      emit(state.copyWith(
        status: StateStatus.loaded,
        supplies1C: request.page == 1
            ? res
            : state.supplies1C!.copyWith(
                results: [...state.supplies1C!.results, ...?res?.results],
              ),
        request: request,
      ));
    } catch (e) {
      debugPrint(e.toString());
    }
  }

  Future<void> _onLoadMore(
      LoadMore event, Emitter<Supplies1cState> emit) async {
    if(state.supplies1C?.totalPages == state.request?.page) return;

    if (state.status == StateStatus.loading) return;

    try {
      emit(state.copyWith(status: StateStatus.loading));

      final data = state.supplies1C?.results;
      final nextPage = (state.request?.page ?? 0) + 1;
      final request = state.request?.copyWith(page: nextPage) ??
          SearchSupplies1C(search: state.request?.search ?? "", page: nextPage);

      final res = await _stockRepository.getSupplies1C(request);

      emit(state.copyWith(
        status: StateStatus.loaded,
        request: request,
        supplies1C: res?.copyWith(results: [...?data, ...res.results]),
      ));
    } catch (e) {
      debugPrint(e.toString());
    }
  }

  void _onUpdateCompanyState(UpdateState event, Emitter<Supplies1cState> emit) {
    // final updatedCompanies = state.supplies1C!.results.map((e) {
    //   return e.id == event.address.id ? event.company : e;
    // }).toList();

    // emit(state.copyWith(
    //   companies: state.companies!.copyWith(results: updatedCompanies),
    // ));
  }

  FutureOr<void> _suppliesProducts(
      GetSuppliesProducts event, Emitter<Supplies1cState> emit) async {
    // emit(state.copyWith(status: StateStatus.loading));
    // try {
    //   final res = await _stockRepository.getSuppliesProducts(event.id!);
    //   emit(state.copyWith(
    //       status: StateStatus.initial, supplies1CProducts: res ?? []));
    // } catch (e) {
    //   print(e);
    //   emit(state.copyWith(status: StateStatus.initial));
    // }
  }

  FutureOr<void> _conductSupplies1C(
      _ConductSupplies1C event, Emitter<Supplies1cState> emit) async {
    // emit(state.copyWith(status: StateStatus.loading));
    // final SuppliesConduct request =
    //     SuppliesConduct(cid: event.cid, supplyType: event.type);
    // try {
    //   await _stockRepository.conductSupplies1C(request);

    //   emit(state.copyWith(
    //     status: StateStatus.initial,
    //   ));
    // } catch (e) {
    //   emit(state.copyWith(status: StateStatus.initial));
    // }
  }
}
