import 'package:hoomo_pos/data/dtos/manager_report/manager_report_dto.dart';
import 'package:hoomo_pos/data/dtos/pagination_dto.dart';
import 'package:hoomo_pos/data/dtos/product_dto.dart';
import 'package:hoomo_pos/data/dtos/products_info/products_info_dto.dart';
import 'package:hoomo_pos/data/sources/network/reports/reports_api.dart';
import 'package:hoomo_pos/domain/repositories/reports.dart';
import 'package:injectable/injectable.dart';

import '../dtos/report/retail_report.dart';

@LazySingleton(as: ReportsRepository)
class ReportsRepositoryImpl implements ReportsRepository {
  final ReportsApi _reportsApi;

  ReportsRepositoryImpl(this._reportsApi);

  @override
  Future<void> downloadManagerReport(
      {required DateTime dateFrom,
      required DateTime dateTo,
      required int managerId,
      required String savePath}) async {
    return await _reportsApi.downloadManagerReport(
        dateFrom: dateFrom,
        dateTo: dateTo,
        managerId: managerId,
        savePath: savePath);
  }

  @override
  Future<void> downloadPosReport(
      {required DateTime dateFrom,
      required DateTime dateTo,
      required String savePath}) async {
    return await _reportsApi.downloadPosReport(
        dateFrom: dateFrom, dateTo: dateTo, savePath: savePath);
  }

  @override
  Future<PaginatedDto<ProductDto>> getLowDemandProducts(
      int page, bool ordering) async {
    return await _reportsApi.getLowDemandProducts(page, ordering);
  }

  @override
  Future<ProductsInfoDto> getProductsInfo({
    int? categoryId,
    int? supplierId,
  }) async {
    return await _reportsApi.getProductsInfo(
        categoryId: categoryId, supplierId: supplierId);
  }

  @override
  Future<PaginatedDto<ProductDto>> getUnsoldProducts(
      int page, bool ordering) async {
    return await _reportsApi.getUnsoldProducts(page, ordering);
  }

  @override
  Future<void> downloadContract(
      String type, int reserveId, String savePath) async {
    return await _reportsApi.downloadContract(type, reserveId, savePath);
  }

  @override
  Future<List<ManagerReportDto>> getManagerReport(
      {required int managerId,
      int? productId,
      required String fromDate,
      required String toDate}) async {
    return await _reportsApi.getManagerReport(
        managerId: managerId,
        fromDate: fromDate,
        toDate: toDate,
        productId: productId);
  }

  @override
  Future<ManagerReportDto> getManagerReportTotal(
      {required int managerId,
      required String fromDate,
      required String toDate}) async {
    return await _reportsApi.getManagerReportTotal(
      managerId: managerId,
      fromDate: fromDate,
      toDate: toDate,
    );
  }

  @override
  Future<List<RetailReportTotal>> getRetailReportTotal(
      {required String fromDate, required String toDate}) async {
    return await _reportsApi.getRetailReportTotal(
      fromDate: fromDate,
      toDate: toDate,
    );
  }
}
