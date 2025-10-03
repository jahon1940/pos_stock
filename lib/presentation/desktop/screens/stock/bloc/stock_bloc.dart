import 'dart:async';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:hoomo_pos/core/enums/states.dart';
import 'package:hoomo_pos/data/dtos/supplies/supply_dto.dart';
import 'package:hoomo_pos/data/dtos/transfers/search_transfers.dart';
import 'package:hoomo_pos/domain/repositories/stock_repository.dart';
import 'package:injectable/injectable.dart';

import '../../../../../data/dtos/pagination_dto.dart';
import '../../../../../data/dtos/stock_dto.dart';
import '../../../../../data/dtos/supplies/search_supplies.dart';
import '../../../../../data/dtos/transfers/transfer_dto.dart';
import '../../../../../data/dtos/write_offs/search_write_off.dart';
import '../../../../../data/dtos/write_offs/write_off_dto.dart';

part 'stock_event.dart';

part 'stock_state.dart';

part 'stock_bloc.freezed.dart';

@lazySingleton
class StockBloc extends Bloc<StockEvent, StockState> {
  StockBloc(
    this._stockRepository,
  ) : super(const _StockState()) {
    on<_GetStocks>(_getStocks);
    on<_SearchSupplies>(_searchSupplies);
    on<_DownloadSupplies>(_downloadSupplies);
    on<_SearchTransfers>(_searchTransfers);
    on<_DownloadTransfers>(_downloadTransfers);
    on<_SearchWriteOffs>(_searchWriteOffs);
    on<_DownloadWriteOffs>(_downloadWriteOffs);
    on<_DeleteSupply>(_onDeleteSupply);
    on<_SelectedSupplier>(_selectedSupplier);
    on<_DateFrom>(_dateFrom);
    on<_DateTo>(_dateTo);
  }

  final StockRepository _stockRepository;

  FutureOr<void> _getStocks(
    _GetStocks event,
    Emitter<StockState> emit,
  ) async {
    emit(state.copyWith(status: StateStatus.loading));
    try {
      final res = await _stockRepository.getStocks(event.id);
      emit(state.copyWith(status: StateStatus.initial, stocks: res ?? []));
    } catch (e) {
      emit(state.copyWith(status: StateStatus.initial));
    }
  }

  Future<void> _searchSupplies(
    _SearchSupplies event,
    Emitter<StockState> emit,
  ) async {
    emit(state.copyWith(status: StateStatus.loading));

    if (event.initial == true) {
      emit(state.copyWith(
        dateFrom: null,
        dateTo: null,
      ));
    }
    final request = SearchSupplies(
      supplierId: state.supplierId,
      stockId: event.stockId,
      fromDate: state.dateFrom == null ? null : DateFormat('yyyy-MM-dd').format(state.dateFrom!),
      toDate: state.dateTo == null ? null : DateFormat('yyyy-MM-dd').format(state.dateTo!),
    );

    try {
      final res = await _stockRepository.search(request);
      emit(state.copyWith(
        status: StateStatus.loaded,
        supplies: res,
      ));
    } catch (e) {
      debugPrint(e.toString());
    }
  }

  Future<void> _searchTransfers(
    _SearchTransfers event,
    Emitter<StockState> emit,
  ) async {
    emit(state.copyWith(status: StateStatus.loading));

    if (event.initial == true) {
      emit(state.copyWith(
        dateFrom: null,
        dateTo: null,
      ));
    }
    final request = SearchTransfers(
      stockId: event.stockId,
      fromDate: state.dateFrom == null ? null : DateFormat('yyyy-MM-dd').format(state.dateFrom!),
      toDate: state.dateTo == null ? null : DateFormat('yyyy-MM-dd').format(state.dateTo!),
    );

    try {
      final res = await _stockRepository.searchTransfers(request);
      emit(state.copyWith(
        status: StateStatus.loaded,
        transfers: res,
      ));
    } catch (e) {
      debugPrint(e.toString());
    }
  }

  Future<void> _searchWriteOffs(
    _SearchWriteOffs event,
    Emitter<StockState> emit,
  ) async {
    emit(state.copyWith(status: StateStatus.loading));

    if (event.initial == true) {
      emit(state.copyWith(
        dateFrom: null,
        dateTo: null,
      ));
    }
    final request = SearchWriteOff(
      stockId: event.stockId,
      fromDate: state.dateFrom == null ? null : DateFormat('yyyy-MM-dd').format(state.dateFrom!),
      toDate: state.dateTo == null ? null : DateFormat('yyyy-MM-dd').format(state.dateTo!),
    );

    try {
      final res = await _stockRepository.searchWriteOff(request);
      emit(state.copyWith(
        status: StateStatus.loaded,
        writeOffs: res,
      ));
    } catch (e) {
      debugPrint(e.toString());
    }
  }

  FutureOr<void> _onDeleteSupply(
    _DeleteSupply event,
    Emitter<StockState> emit,
  ) async {
    emit(state.copyWith(status: StateStatus.loading));
    try {
      await _stockRepository.deleteSupply(event.id);
      emit(state.copyWith(
        status: StateStatus.initial,
      ));
    } catch (e) {
      emit(state.copyWith(status: StateStatus.initial));
    }
  }

  FutureOr<void> _dateFrom(
    _DateFrom event,
    Emitter<StockState> emit,
  ) async {
    emit(state.copyWith(status: StateStatus.loading));
    try {
      emit(state.copyWith(
        status: StateStatus.initial,
        dateFrom: event.dateFrom,
      ));
    } catch (e) {
      emit(state.copyWith(status: StateStatus.initial));
    }
  }

  FutureOr<void> _dateTo(
    _DateTo event,
    Emitter<StockState> emit,
  ) async {
    emit(state.copyWith(status: StateStatus.loading));
    try {
      emit(state.copyWith(
        status: StateStatus.initial,
        dateTo: event.dateTo,
      ));
    } catch (e) {
      emit(state.copyWith(status: StateStatus.initial));
    }
  }

  FutureOr<void> _selectedSupplier(
    _SelectedSupplier event,
    Emitter<StockState> emit,
  ) {
    emit(state.copyWith(supplierId: event.id));
  }

  Future<void> _downloadSupplies(
    _DownloadSupplies event,
    Emitter<StockState> emit,
  ) async {
    emit(state.copyWith(status: StateStatus.loading));
    try {
      await _stockRepository.downloadSupplies(id: event.id);
    } catch (e) {
      debugPrint(e.toString());
    }
    emit(state.copyWith(status: StateStatus.loaded));
  }

  Future<void> _downloadTransfers(
    _DownloadTransfers event,
    Emitter<StockState> emit,
  ) async {
    emit(state.copyWith(status: StateStatus.loading));
    try {
      await _stockRepository.downloadTransfers(id: event.id);
    } catch (e) {
      debugPrint(e.toString());
    }
    emit(state.copyWith(status: StateStatus.loaded));
  }

  Future<void> _downloadWriteOffs(
    _DownloadWriteOffs event,
    Emitter<StockState> emit,
  ) async {
    emit(state.copyWith(status: StateStatus.loading));
    try {
      await _stockRepository.downloadWriteOffs(id: event.id);
    } catch (e) {
      debugPrint(e.toString());
    }
    emit(state.copyWith(status: StateStatus.loaded));
  }
}
