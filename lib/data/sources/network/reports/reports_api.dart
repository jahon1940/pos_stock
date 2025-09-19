import 'package:hoomo_pos/data/dtos/manager_report/manager_report_dto.dart';
import 'package:hoomo_pos/data/dtos/pagination_dto.dart';
import 'package:hoomo_pos/data/dtos/product_dto.dart';
import 'package:hoomo_pos/data/dtos/products_info/products_info_dto.dart';

import '../../../dtos/report/retail_report.dart';

abstract class ReportsApi {
  Future<void> downloadPosReport(
      {required DateTime dateFrom,
      required DateTime dateTo,
      required String savePath});

  Future<void> downloadManagerReport(
      {required DateTime dateFrom,
      required DateTime dateTo,
      required int managerId,
      required String savePath});

  Future<void> downloadContract(String type, int reserveId, String savePath);

  Future<PaginatedDto<ProductDto>> getUnsoldProducts(int page, bool ordering);

  Future<PaginatedDto<ProductDto>> getLowDemandProducts(
      int page, bool ordering);

  Future<ProductsInfoDto> getProductsInfo({
    int? categoryId,
    int? supplierId,
  });

  Future<List<ManagerReportDto>> getManagerReport(
      {required int managerId,
      int? productId,
      required String fromDate,
      required String toDate});

  Future<ManagerReportDto> getManagerReportTotal(
      {required int managerId,
      required String fromDate,
      required String toDate});

  Future<List<RetailReportTotal>> getRetailReportTotal(
      {required String fromDate, required String toDate});
}
