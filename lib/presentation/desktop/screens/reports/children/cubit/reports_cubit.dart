import 'package:bloc/bloc.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:hoomo_pos/data/dtos/report/retail_report.dart';
import 'package:hoomo_pos/domain/repositories/reports.dart';
import 'package:injectable/injectable.dart';

import '../../../../../../core/enums/states.dart';
import '../../../../../../data/dtos/products_info/products_info_dto.dart';

part 'reports_state.dart';
part 'reports_cubit.freezed.dart';

@injectable
class ReportsCubit extends Cubit<ReportsState> {
  ReportsCubit(this._reportsRepository) : super(ReportsState());

  final ReportsRepository _reportsRepository;

  void initial() async {
    try {
      emit(state.copyWith(status: StateStatus.loaded, reportTotal: null));
    } catch (e) {
      emit(state.copyWith(status: StateStatus.error));
      print(e);
    }
  }

  void getReports({
    int? categoryId,
    int? supplierId,
  }) async {
    try {
      if (state.status == StateStatus.loading) return;
      emit(state.copyWith(status: StateStatus.loading));

      ProductsInfoDto info = await _reportsRepository.getProductsInfo(
          categoryId: categoryId, supplierId: supplierId);

      emit(state.copyWith(status: StateStatus.loaded, info: info));
    } catch (ex) {
      print(ex);
    }
  }

  void selectFromDate(DateTime value) {
    emit(state.copyWith(
      dateFrom: value,
    ));
  }

  void selectToDate(DateTime value) {
    emit(state.copyWith(
      dateTo: value,
    ));
  }

  void getTotalReport() async {
    try {
      if (state.dateTo == null || state.dateFrom == null) return;

      emit(state.copyWith(status: StateStatus.loading));
      List<RetailReportTotal> totalReports =
          await _reportsRepository.getRetailReportTotal(
        fromDate: DateFormat('yyyy-MM-dd').format(state.dateFrom!),
        toDate: DateFormat('yyyy-MM-dd').format(state.dateTo!),
      );

      emit(state.copyWith(
          status: StateStatus.loaded, reportTotal: totalReports));
    } catch (e) {
      emit(state.copyWith(status: StateStatus.error));
      print(e);
    }
  }
}
