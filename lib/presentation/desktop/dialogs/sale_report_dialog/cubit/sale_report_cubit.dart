import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:hoomo_pos/app/router.dart';
import 'package:hoomo_pos/core/enums/states.dart';
import 'package:hoomo_pos/domain/repositories/reports.dart';
import 'package:injectable/injectable.dart';

part 'sale_report_state.dart';
part 'sale_report_cubit.freezed.dart';

@injectable
class SaleReportCubit extends Cubit<SaleReportState> {
  SaleReportCubit(this._reportsRepository) : super(SaleReportState());

  final ReportsRepository _reportsRepository;

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

  void download() async {
    final directory = await FilePicker.platform.getDirectoryPath();

    if (directory == null) return;

    try {
      emit(state.copyWith(status: StateStatus.loading));
      await _reportsRepository.downloadPosReport(
        dateFrom: state.dateFrom!,
        dateTo: state.dateTo!,
        savePath: directory,
      );
      Navigator.pop(router.navigatorKey.currentContext!);
    } catch (e) {
      emit(state.copyWith(status: StateStatus.error));
      print(e);
    }
  }
}
