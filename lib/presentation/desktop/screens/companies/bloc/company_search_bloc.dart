import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:hoomo_pos/core/enums/states.dart';
import 'package:hoomo_pos/data/dtos/company/company_dto.dart';
import 'package:hoomo_pos/data/dtos/pagination_dto.dart';
import 'package:hoomo_pos/data/dtos/search_request.dart';
import 'package:hoomo_pos/data/dtos/supplies/create_supply_request.dart';
import 'package:hoomo_pos/domain/repositories/companies.dart';
import 'package:injectable/injectable.dart';
import 'package:rxdart/rxdart.dart';
import '../../../../../data/dtos/add_user/add_user_request.dart';

part 'company_search_state.dart';

part 'company_search_event.dart';

part 'company_search_bloc.freezed.dart';

@injectable
class CompanySearchBloc extends Bloc<CompanySearchEvent, CompanySearchState> {
  final CompaniesRepository _companiesRepository;

  CompanySearchBloc(this._companiesRepository) : super(const CompanySearchState()) {
    on<CompanySearchTextChanged>(_onSearchTextChanged,
        transformer: _debounce());
    on<CompanyLoadMore>(_onLoadMore);
    on<CompanyUpdateState>(_onUpdateCompanyState);
    on<CompanySynchronize>(_onSynchronize);

    // Initialize with empty search to load initial data
    // add(CompanySearchTextChanged('', true));
  }

  EventTransformer<T> _debounce<T>() {
    return (events, mapper) => events
        .debounceTime(const Duration(milliseconds: 300))
        .switchMap(mapper);
  }

  Future<void> _onSearchTextChanged(
      CompanySearchTextChanged event, Emitter<CompanySearchState> emit) async {
    if (state.status == StateStatus.loading) return;

    var value = event.value;
    var request = SearchRequest(title: value, orderBy: '-created_at', page: 1);

    emit(state.copyWith(
      status: StateStatus.loading,
    ));

    try {
      final res = await _companiesRepository.search(request);
      emit(state.copyWith(
        status: StateStatus.loaded,
        companies: res,
        request: request,
      ));
    } catch (e) {
      debugPrint('Company search error: $e');
      emit(state.copyWith(
        status: StateStatus.error,
        companies: PaginatedDto(
          results: [],
          pageNumber: 1,
          pageSize: 20,
          totalPages: 0,
          count: 0,
        ),
      ));
    }
  }

  Future<void> _onLoadMore(
      CompanyLoadMore event, Emitter<CompanySearchState> emit) async {
    if (state.status == StateStatus.loading) return;

    // Check if we have more pages to load
    if (state.companies != null &&
        state.request != null &&
        (state.request!.page ?? 1) >= (state.companies!.totalPages)) {
      return; // No more pages to load
    }

    try {
      emit(state.copyWith(status: StateStatus.loading));

      final data = state.companies?.results ?? [];
      final nextPage = (state.request?.page ?? 0) + 1;
      final request = state.request?.copyWith(page: nextPage) ??
          SearchRequest(
              title: state.request?.title ?? "",
              orderBy: '-created_at',
              page: nextPage);

      final res = await _companiesRepository.search(request);

      emit(state.copyWith(
        status: StateStatus.loaded,
        request: request,
        companies: res.copyWith(
          results: [...data, ...res.results],
          pageNumber: res.pageNumber,
          totalPages: res.totalPages,
          count: res.count,
        ),
      ));
    } catch (e) {
      debugPrint('Load more error: $e');
      emit(state.copyWith(status: StateStatus.error));
    }
  }

  void _onUpdateCompanyState(
      CompanyUpdateState event, Emitter<CompanySearchState> emit) {
    final updatedCompanies = state.companies!.results.map((e) {
      return e.id == event.company.id ? event.company : e;
    }).toList();

    emit(state.copyWith(
      companies: state.companies!.copyWith(results: updatedCompanies),
    ));
  }

  Future<void> _onSynchronize(
      CompanySynchronize event, Emitter<CompanySearchState> emit) async {
    try {
      emit(state.copyWith(status: StateStatus.loading));

      final result = await _companiesRepository.synchronize(1);
      final totalPages = result.$2;

      // Fix: Should be i <= totalPages, not i < totalPages
      for (int i = 2; i <= totalPages; i++) {
        await _companiesRepository.synchronize(i);
      }

      emit(state.copyWith(status: StateStatus.loaded));
    } catch (e) {
      debugPrint('Synchronization error: $e');
      emit(state.copyWith(status: StateStatus.error));
    }
  }

  Future<CompanyDto> getCompany(int id) async {
    return await _companiesRepository.getCompany(id);
  }
}
