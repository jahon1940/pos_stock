import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:hoomo_pos/app/router.dart';
import 'package:hoomo_pos/core/enums/states.dart';
import 'package:hoomo_pos/data/dtos/supplies_1c/supplies_1c.dart';
import 'package:hoomo_pos/data/dtos/supplies_1c/supplies_1c_conduct.dart';
import 'package:hoomo_pos/data/dtos/supplies/supply_product_dto.dart';
import 'package:hoomo_pos/presentation/desktop/screens/stock/repository/stock_repository.dart';
import 'package:injectable/injectable.dart';

part 'supplies_1c_state.dart';
part 'supplies_1c_cubit.freezed.dart';

@injectable
class Supplies1cCubit extends Cubit<Supplies1cState> {
  Supplies1cCubit(this._stockRepository) : super(Supplies1cState());

  final StockRepository _stockRepository;

  getProducts(int id) async {
    emit(state.copyWith(status: StateStatus.loading));
    try {
      final res = await _stockRepository.getSupply1CProducts(id);
      emit(state.copyWith(
        status: StateStatus.loaded,
        products: res,
      ));
    } catch (e,s) {
      print(e);
      print(s);
      emit(state.copyWith(
        status: StateStatus.error,
      ));
    }
  }

  conduct(Supplies1C data) async {
    emit(state.copyWith(status: StateStatus.loading));
    final request = SuppliesConduct(cid: data.cid, supplyType: data.supplyType);

    try {
      await _stockRepository.conductSupplies1C(request);
      Navigator.pop(router.navigatorKey.currentContext!);
    } catch (e) {
      print(e);
    }
  }
}
