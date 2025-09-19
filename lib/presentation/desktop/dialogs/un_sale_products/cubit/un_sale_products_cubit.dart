import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:hoomo_pos/core/enums/states.dart';
import 'package:hoomo_pos/data/dtos/pagination_dto.dart';
import 'package:hoomo_pos/data/dtos/product_dto.dart';
import 'package:hoomo_pos/domain/repositories/reports.dart';
import 'package:injectable/injectable.dart';

part 'un_sale_products_state.dart';
part 'un_sale_products_cubit.freezed.dart';

@injectable
class UnSaleProductsCubit extends Cubit<UnSaleProductsState> {
  UnSaleProductsCubit(this._repository) : super(UnSaleProductsState());

  final ReportsRepository _repository;

  void init(bool value) async {
    try {
      emit(state.copyWith(status: StateStatus.initial));

      final res = await _repository.getUnsoldProducts(1, value);

      emit(state.copyWith(products: res, status: StateStatus.loaded, page: 1));
    } catch (e) {
      emit(state.copyWith(status: StateStatus.error));
    }
  }

  void loadMore(bool value) async {
    try {
      if (state.status == StateStatus.loading) return;

      emit(state.copyWith(status: StateStatus.loading));

      final res = await _repository.getUnsoldProducts(state.page + 1, value);

      emit(state.copyWith(
          products: state.page == 1
              ? res
              : state.products!.copyWith(
            results: [...state.products!.results, ...res.results],
          ),
          page: state.page + 1,
          status: StateStatus.loaded));
    } catch (e) {
      emit(state.copyWith(status: StateStatus.error));
    }
  }
}
