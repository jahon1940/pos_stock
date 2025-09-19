import 'package:easy_localization/easy_localization.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:hoomo_pos/app/router.dart';
import 'package:hoomo_pos/core/enums/states.dart';
import 'package:hoomo_pos/data/dtos/manager/manager_dto.dart';
import 'package:hoomo_pos/data/dtos/manager_report/manager_report_dto.dart';
import 'package:hoomo_pos/data/dtos/product_dto.dart';
import 'package:hoomo_pos/domain/repositories/manager.dart';
import 'package:hoomo_pos/domain/repositories/reports.dart';
import 'package:injectable/injectable.dart';


part 'report_manager_state.dart';
part 'report_manager_cubit.freezed.dart';

@injectable
class ReportManagerCubit extends Cubit<ReportManagerState> {
  ReportManagerCubit(this._managerRepository, this._reportsRepository)
      : super(ReportManagerState()) {
    _init();
  }

  final ManagerRepository _managerRepository;
  final ReportsRepository _reportsRepository;

  void _init() async {
    try {
      emit(state.copyWith(status: StateStatus.loading));
      final managers = await _managerRepository.getManagers();
      emit(state.copyWith(
        status: StateStatus.initial,
        managers: [
          ManagerDto(cid: '0', id: 0, name: 'Отчет по всем'),
          ...(managers ?? [])
        ],
      ));
    } catch (e) {
      emit(state.copyWith(status: StateStatus.initial));
    }
  }

  void selectManager(int? value) {
    final manager = state.managers.firstWhere((e) => e.id == value);

    emit(state.copyWith(
      selectedManager: manager,
    ));
  }

  void selectProduct(ProductDto? value) {
    emit(state.copyWith(
      selectedProduct: value,
    ));
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

  void download() async {
    final directory = await FilePicker.platform.getDirectoryPath();

    if (directory == null) return;

    try {
      emit(state.copyWith(status: StateStatus.loading));
      await _reportsRepository.downloadManagerReport(
        dateFrom: state.dateFrom!,
        dateTo: state.dateTo!,
        managerId: state.selectedManager!.id!,
        savePath: directory,
      );
      Navigator.pop(router.navigatorKey.currentContext!);
    } catch (e) {
      emit(state.copyWith(status: StateStatus.error));
      print(e);
    }
  }

  void getReport() async {
    try {
      if (state.dateTo == null || state.dateFrom == null) return;

      emit(state.copyWith(status: StateStatus.loading));
      List<ManagerReportDto> managerReports =
          await _reportsRepository.getManagerReport(
        fromDate: DateFormat('yyyy-MM-dd').format(state.dateFrom!),
        toDate: DateFormat('yyyy-MM-dd').format(state.dateTo!),
        productId: state.selectedProduct?.id,
        managerId: state.selectedManager?.id ?? 0,
      );

      ManagerReportDto managerReportsTotal =
          await _reportsRepository.getManagerReportTotal(
        fromDate: DateFormat('yyyy-MM-dd').format(state.dateFrom!),
        toDate: DateFormat('yyyy-MM-dd').format(state.dateTo!),
        managerId: state.selectedManager?.id ?? 0,
      );

      emit(state.copyWith(
          status: StateStatus.loaded,
          managerReports: managerReports,
          managerReportsTotal: managerReportsTotal));
    } catch (e) {
      emit(state.copyWith(status: StateStatus.error));
      print(e);
    }
  }
}
