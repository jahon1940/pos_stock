import 'dart:io';

import 'package:dio/dio.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:hoomo_pos/core/enums/states.dart';
import 'package:hoomo_pos/core/logging/app_logger.dart';
import 'package:hoomo_pos/core/mixins/secure_storage_mixin.dart';
import 'package:hoomo_pos/data/dtos/pos_manager_dto.dart';
import 'package:hoomo_pos/data/dtos/receipt_dto.dart';
import 'package:hoomo_pos/data/dtos/receipt_params_dto.dart';
import 'package:hoomo_pos/data/dtos/z_report_info_dto.dart';
import 'package:hoomo_pos/domain/repositories/receipt.dart';
import 'package:hoomo_pos/domain/services/formatter_service.dart';
import 'package:injectable/injectable.dart';
import 'package:path_provider/path_provider.dart';

import '../../../../../app/di.dart';
import '../../../../../data/sources/local/daos/product_dao.dart';
import '../../../../../data/sources/local/daos/product_params_dao.dart';
import '../../../../../domain/repositories/params.dart';
import '../../../../../domain/repositories/pos_manager.dart';
import '../../../../../domain/repositories/products.dart';
import '../../../../../domain/repositories/shift.dart';

part 'shift_state.dart';

part 'shift_cubit.freezed.dart';

@lazySingleton
class ShiftCubit extends Cubit<ShiftState> with SecureStorageMixin{
  ShiftCubit(this._shiftRepository, this._receiptRepository, this.posManagerRepository, this._paramsRepository, this._productsRepository) : super(ShiftState());

  final ShiftRepository _shiftRepository;
  final ReceiptRepository _receiptRepository;
  final PosManagerRepository posManagerRepository;
  final ParamsRepository _paramsRepository;
  final ProductsRepository _productsRepository;

  CancelToken? _cancelToken;

  void loadShiftInfo() async {
    if (state.status == StateStatus.loading) return;
    emit(state.copyWith(status: StateStatus.loading));

    try {
      PosManagerDto posManagerDto = await posManagerRepository.getPosManager();

      if(posManagerDto.pos?.integration_with_1c == false) {
        String? shiftState = await getData(SecureStorageKeys.shift_state);
        if (shiftState != "is_open") {
          throw Exception();
        }
      }

      ZReportInfoDto zReportInfoDto;
      if(posManagerDto.pos?.integration_with_1c == true) {
        zReportInfoDto = await _shiftRepository.getZReport();
      } else {
        zReportInfoDto = await _receiptRepository.getPosReport();
      }

      zReportInfoDto = zReportInfoDto.copyWith(
          companyName: posManagerDto.pos?.stock?.organization?.name,
          companyTin: posManagerDto.pos?.stock?.organization?.inn,
          stockName: posManagerDto.pos?.stock?.name,
          stockAddress: posManagerDto.pos?.stock?.address,
          cashier: posManagerDto.name
      );

      String dateFormat = FormatterService().dateFormatter(zReportInfoDto.openTime);
      int? cashInSum = await _receiptRepository.getOperationSum(dateFormat, "cash_in");
      int? cashOutSum = await _receiptRepository.getOperationSum(dateFormat, "cash_out");
      emit(state.copyWith(zReport: zReportInfoDto, status: StateStatus.loaded, isOpen: zReportInfoDto.openTime != null, cashInSum: cashInSum, cashOutSum: cashOutSum));
    } catch (ex) {
      ZReportInfoDto zReportInfoDto = ZReportInfoDto(number: null,
          count: null,
          totalSaleCount: null,
          totalRefundCount: null,
          totalRefundVAT: null,
          totalRefundCash: null,
          totalRefundCard: null,
          totalSaleCard: null,
          totalSaleCash: null,
          totalSaleVAT: null,
          closeTime: null,
          terminalID: null,
          openTime: null,
          appletVersion: null);
      PosManagerDto posManagerDto = await posManagerRepository.getPosManager();
      zReportInfoDto = zReportInfoDto.copyWith(
          companyName: posManagerDto.pos?.stock?.organization?.name,
          companyTin: posManagerDto.pos?.stock?.organization?.inn,
          stockName: posManagerDto.pos?.stock?.name,
          stockAddress: posManagerDto.pos?.stock?.address,
          cashier: posManagerDto.name
      );
      emit(state.copyWith(zReport: zReportInfoDto, status: StateStatus.loaded, isOpen: false));
    }
  }

  void openShift(BuildContext context) async {
    if (state.status == StateStatus.loading) return;
    emit(state.copyWith(status: StateStatus.loading));

    try {
      PosManagerDto posManagerDto = await posManagerRepository.getPosManager();

      String result;
      if(posManagerDto.pos?.integration_with_1c == false) {
        result = "SUCCESS";
      } else {
        result = await _shiftRepository.openZReport();
      }

      if(result == 'SUCCESS') {
        // await synchronizeProducts();

        PosManagerDto posManagerDto = await posManagerRepository.getPosManager();
        ZReportInfoDto zReportInfoDto;
        if(posManagerDto.pos?.integration_with_1c == true) {
          zReportInfoDto = await _shiftRepository.getZReport();
        } else {
          zReportInfoDto = await _receiptRepository.getPosReport();
        }

        zReportInfoDto = zReportInfoDto.copyWith(
            companyName: posManagerDto.pos?.stock?.organization?.name,
            companyTin: posManagerDto.pos?.stock?.organization?.inn,
            stockName: posManagerDto.pos?.stock?.name,
            stockAddress: posManagerDto.pos?.stock?.address,
            cashier: posManagerDto.name
        );
        ReceiptDto shiftReceipt = ReceiptDto(
            companyName: state.zReport?.companyName ?? "Kanstik",
            companyAddress: state.zReport?.stockAddress ?? "Tashkent",
            companyINN: state.zReport?.companyTin ?? "305191400",
            receiptType: "open_shift",
            staffName: state.zReport?.cashier ?? "Kassir",
            receiptDateTime: state.zReport?.openTime,
            closeTime: DateFormat("yyyyMMddHHmmss").format(DateTime.now()),
            receiptSeq: state.zReport?.number.toString() ?? "0",
            printerSize: 80,
            isSynced: false,
            sendSoliq: true,
            sendTo1C: false,
            params: ReceiptParamsDto(
                receivedCash: state.zReport?.totalSaleCash ?? 0,
                receivedCard: state.zReport?.totalSaleCard ?? 0,
                receivedVat: state.zReport?.totalSaleVAT ?? 0,
                refundCash: state.zReport?.totalRefundCash ?? 0,
                refundCard: state.zReport?.totalRefundCard ?? 0,
                refundVat: state.zReport?.totalRefundVAT ?? 0,
                salesCount: state.zReport?.totalSaleCount ?? 0,
                refundsCount: state.zReport?.totalRefundCount ?? 0,
                items: []
            )
        );

        try {
          await _receiptRepository.sendReceipt(shiftReceipt);
        } catch(_) {

        }

        await writeData(SecureStorageKeys.shift_state, "is_open");

        String dateFormat = FormatterService().dateFormatter(zReportInfoDto.openTime);
        int? cashInSum = await _receiptRepository.getOperationSum(dateFormat, "cash_in");
        int? cashOutSum = await _receiptRepository.getOperationSum(dateFormat, "cash_out");
        emit(state.copyWith(zReport: zReportInfoDto, status: StateStatus.loaded, isOpen: zReportInfoDto.openTime != null, cashInSum: cashInSum, cashOutSum: cashOutSum, statusText: null));
      } else {
        emit(state.copyWith(errorText: result, status: StateStatus.error));
      }
    } catch (ex) {
      emit(state.copyWith(status: StateStatus.error, errorText: ex.toString()));
    }
  }

  void closeShift() async {
    if (state.status == StateStatus.loading) return;
    emit(state.copyWith(status: StateStatus.loading));

    try {

      PosManagerDto posManagerDto = await posManagerRepository.getPosManager();

      String result;
      if(posManagerDto.pos?.integration_with_1c == false) {
        result = "SUCCESS";
      } else {
        result = await _shiftRepository.closeZReport();
      }

      if(result == 'SUCCESS') {
        ReceiptDto shiftReceipt = ReceiptDto(
            companyName: state.zReport?.companyName ?? "Kanstik",
            companyAddress: state.zReport?.stockAddress ?? "Tashkent",
            companyINN: state.zReport?.companyTin ?? "305191400",
            receiptType: "close_shift",
            staffName: state.zReport?.cashier ?? "Kassir",
            receiptDateTime: DateFormat("yyyyMMddHHmmss").format(DateTime.now()),
            closeTime: DateFormat("yyyyMMddHHmmss").format(DateTime.now()),
            receiptSeq: state.zReport?.number.toString() ?? "0",
            printerSize: 80,
            isSynced: false,
            sendSoliq: true,
            sendTo1C: false,
            params: ReceiptParamsDto(
                receivedCash: state.zReport?.totalSaleCash ?? 0,
                receivedCard: state.zReport?.totalSaleCard ?? 0,
                receivedVat: state.zReport?.totalSaleVAT ?? 0,
                refundCash: state.zReport?.totalRefundCash ?? 0,
                refundCard: state.zReport?.totalRefundCard ?? 0,
                refundVat: state.zReport?.totalRefundVAT ?? 0,
                salesCount: state.zReport?.totalSaleCount ?? 0,
                refundsCount: state.zReport?.totalRefundCount ?? 0,
                items: []
            )
        );

        try {
          await _receiptRepository.sendReceipt(shiftReceipt);

          String date = DateFormat("yyyy-MM-dd").format(DateTime.now());
          await _shiftRepository.downloadReport(date);
        } catch(_) {

        }

        await writeData(SecureStorageKeys.shift_state, "is_close");

        emit(state.copyWith(
            zReport: null, status: StateStatus.loaded, isOpen: false));
      } else {
        emit(state.copyWith(errorText: result, status: StateStatus.error));
      }
    } catch (ex) {
      emit(state.copyWith(status: StateStatus.error, errorText: ex.toString()));
    }
  }

  void downloadReport(String date) async {
    emit(state.copyWith(status: StateStatus.loading));
    await _shiftRepository.downloadReport(date);
    // openWindowsPath();
    emit(state.copyWith(status: StateStatus.loaded));
  }

  void changeCashIn(int amount) {
    emit(state.copyWith(cashInSum: (state.cashInSum ?? 0) + amount));
  }

  void changeCashOut(int amount) {
    emit(state.copyWith(cashOutSum: (state.cashOutSum ?? 0) + amount));
  }

  Future<void> synchronizeProducts() async {
    emit(state.copyWith(statusText: "Синхронизация номенклатуры"));
    appLogger.i("SYNCHRONIZE...");
    await getIt<ProductParamsDao>().deleteAllProductInStoks();
    await getIt<ProductsDao>().deleteAllProducts();

    _cancelToken?.cancel();
    _cancelToken = CancelToken();

    double totalSteps = 0;
    double currentStep = 0;

    // Получаем количество страниц для всех запросов
    final regions = await _paramsRepository.getRegions(1);
    final stocks = await _paramsRepository.getStocks(1);
    final brands = await _paramsRepository.getBrands(1);
    final categories = await _paramsRepository.getCategories(1);
    final organizations = await _paramsRepository.getOrganizations(1);
    final productStocks = await _paramsRepository.getProductInStocks(1);
    final syncRes = await _productsRepository.synchronize(1,
        cancelToken: _cancelToken); // выполняем сразу

    // Считаем общее количество шагов
    totalSteps = (regions.$2 +
        stocks.$2 +
        brands.$2 +
        categories.$2 +
        organizations.$2 +
        productStocks.$2 +
        syncRes.$2)
        .toDouble();

    void updateProgress() {
      _updateProgress((currentStep / totalSteps) * 100);
    }

    Future<void> runPaged(int totalPages, Future<void> Function(int page) call,
        {int start = 1}) async {
      for (var i = start; i <= totalPages; i++) {
        await call(i);
        currentStep++;
        updateProgress();
      }
    }

    await runPaged(regions.$2, _paramsRepository.getRegions);
    await runPaged(stocks.$2, _paramsRepository.getStocks);
    await runPaged(brands.$2, _paramsRepository.getBrands);
    await runPaged(categories.$2, _paramsRepository.getCategories);
    await runPaged(organizations.$2, _paramsRepository.getOrganizations);
    await runPaged(productStocks.$2, _paramsRepository.getProductInStocks);

    currentStep++; // уже был вызван synchronize(1)
    updateProgress();

    await runPaged(syncRes.$2, _productsRepository.synchronize,
        start: 2); // начиная со 2й страницы

    _updateProgress(100);
    final date = DateTime.now();
    await _productsRepository.setLastSynchronizationTime(date);
  }

  void _updateProgress(double value) {
    emit(state.copyWith(progress: value.ceil()));
  }

  void openWindowsPath() async {
    final directory = await getApplicationDocumentsDirectory();
    String path = "${directory.path}/";
    if (Platform.isWindows) {
      await Process.run('explorer', [path]);
    }
  }
}
