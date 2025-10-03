import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:hoomo_pos/core/enums/states.dart';
import 'package:hoomo_pos/domain/repositories/stock_repository.dart';
import 'package:injectable/injectable.dart';

import '../../../../../data/dtos/stock_dto.dart';

part 'stock_event.dart';

part 'stock_state.dart';

part 'stock_bloc.freezed.dart';

@lazySingleton
class StockBloc extends Bloc<StockEvent, StockState> {
  StockBloc(
    this._stockRepository,
  ) : super(const _StockState()) {
    on<_GetStocks>(_getStocks);
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
}
