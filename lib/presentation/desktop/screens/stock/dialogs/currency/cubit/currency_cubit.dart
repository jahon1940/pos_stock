import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:hoomo_pos/core/enums/states.dart';
import 'package:hoomo_pos/data/dtos/add_currency/add_currency_request.dart';
import 'package:hoomo_pos/data/dtos/currency_dto.dart';
import 'package:hoomo_pos/domain/repositories/products.dart';
import 'package:injectable/injectable.dart';

part 'currency_state.dart';
part 'currency_cubit.freezed.dart';

@injectable
class CurrencyCubit extends Cubit<CurrencyState> {
  CurrencyCubit(this._repository) : super(CurrencyState());

  final ProductsRepository _repository;

  void init() async {
    try {
      emit(state.copyWith(status: StateStatus.loading));

      final res = await _repository.getCurrency();

      emit(state.copyWith(currency: res, status: StateStatus.loaded));
    } catch (e) {
      emit(state.copyWith(status: StateStatus.error));
    }
  }

  void changeCurrency(String currency) {
    emit(state.copyWith(newCurrency: int.tryParse(currency) ?? 0));
  }

  void saveNewCurrency() async {
    try {
      emit(state.copyWith(status: StateStatus.loading));

      await _repository.updateCurrency(
          AddCurrencyRequest(priceUzsRate: state.newCurrency.toInt()));

      emit(state.copyWith(status: StateStatus.success));
    } catch (e) {
      emit(state.copyWith(status: StateStatus.error));
    }
  }
}
