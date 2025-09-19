import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:hoomo_pos/core/enums/states.dart';
import 'package:hoomo_pos/data/dtos/company_bonus_dto.dart';
import 'package:hoomo_pos/data/dtos/pagination_dto.dart';
import 'package:hoomo_pos/data/dtos/search_request.dart';
import 'package:hoomo_pos/domain/repositories/companies.dart';
import 'package:injectable/injectable.dart';
import 'package:rxdart/rxdart.dart';

part 'search_bonuses_event.dart';
part 'search_bonuses_state.dart';
part 'search_bonuses_bloc.freezed.dart';

@injectable
class SearchBonusesBloc extends Bloc<SearchBonusesEvent, SearchBonusesState> {
  SearchBonusesBloc(this._companiesRepository) : super(SearchBonusesState()) {
    on<_Search>(_onSearch, transformer: _debounce());

    add(SearchBonusesEvent.search(null));
  }

  EventTransformer<T> _debounce<T>() {
    return (events, mapper) => events
        .debounceTime(const Duration(milliseconds: 300))
        .switchMap(mapper);
  }

  final CompaniesRepository _companiesRepository;

  FutureOr<void> _onSearch(_Search event, emit) async {


    var value = event.value;
    var request = state.request?.copyWith(title: value) ??
        SearchRequest(title: value, orderBy: '-created_at', page: 1);

    emit(state.copyWith(status: StateStatus.loading));

    try {
      final res = await _companiesRepository.getCompanyBonuses(request);
      emit(state.copyWith(
        status: StateStatus.loaded,
        companies: request.page == 1
            ? res
            : state.companies!.copyWith(
                results: [...state.companies!.results, ...res.results],
              ),
        request: request,
      ));
    } catch (e) {
      debugPrint(e.toString());
    }
  }
}
