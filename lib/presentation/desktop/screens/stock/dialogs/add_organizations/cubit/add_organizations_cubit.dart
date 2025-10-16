import 'package:bloc/bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

import '../../../../../../../core/enums/states.dart';
import '../../../../../../../data/dtos/add_currency/add_currency_request.dart';
import '../../../../../../../data/dtos/currency_dto.dart';
import '../../../../../../../domain/repositories/products_repository.dart';

part 'add_organizations_state.dart';
part 'add_organizations_cubit.freezed.dart';

class AddOrganizationsCubit extends Cubit<AddOrganizationsState> {
  AddOrganizationsCubit(this._repository) : super(AddOrganizationsState());

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
