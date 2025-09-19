import 'package:easy_localization/easy_localization.dart';
import 'package:hoomo_pos/core/constants/network.dart';
import 'package:hoomo_pos/core/network/dio_client.dart';
import 'package:hoomo_pos/data/dtos/manager_report/manager_report_dto.dart';
import 'package:hoomo_pos/data/dtos/pagination_dto.dart';
import 'package:hoomo_pos/data/dtos/product_dto.dart';
import 'package:hoomo_pos/data/dtos/products_info/products_info_dto.dart';
import 'package:hoomo_pos/data/dtos/report/retail_report.dart';
import 'package:hoomo_pos/data/sources/network/reports/reports_api.dart';
import 'package:injectable/injectable.dart';

@LazySingleton(as: ReportsApi)
class ReportsApiImpl implements ReportsApi {
  final DioClient _dioClient;

  ReportsApiImpl(this._dioClient);

  @override
  Future<void> downloadManagerReport(
      {required DateTime dateFrom,
      required DateTime dateTo,
      required int managerId,
      required String savePath}) async {
    String fromDate = DateFormat('yyyy-MM-dd').format(dateFrom);
    String toDate = DateFormat('yyyy-MM-dd').format(dateTo);

    try {
      await _dioClient.downloadRequest(
        "${NetworkConstants.posUrl}/managers/$managerId/reports/download-excel",
        queryParameters: {
          "from_date": fromDate,
          "to_date": toDate,
        },
        '$savePath/${managerId}_report_$fromDate-$toDate.xlsx',
      );
    } catch (_) {
      rethrow;
    }
  }

  @override
  Future<void> downloadPosReport(
      {required DateTime dateFrom,
      required DateTime dateTo,
      required String savePath}) async {
    String fromDate = DateFormat('yyyy-MM-dd').format(dateFrom);
    String toDate = DateFormat('yyyy-MM-dd').format(dateTo);

    try {
      await _dioClient.downloadRequest(
          NetworkConstants.posReports,
          queryParameters: {"from_date": fromDate, "to_date": toDate},
          "$savePath/sales_report_${fromDate}_$toDate.xlsx");
    } catch (_) {}
  }

  @override
  Future<PaginatedDto<ProductDto>> getLowDemandProducts(
      int page, bool ordering) async {
    final res = await _dioClient.getRequest<PaginatedDto<ProductDto>>(
      NetworkConstants.productsLowDemand,
      queryParameters: {
        "page": page,
        "page_size": 50,
        "ordering": ordering ? "quantity" : "-quantity"
      },
      converter: (response) => PaginatedDto.fromJson(
        response,
        (json) => ProductDto.fromJson(json),
      ),
    );
    return res;
  }

  @override
  Future<ProductsInfoDto> getProductsInfo({
    int? categoryId,
    int? supplierId,
  }) async {
    try {
      final res = await _dioClient.getRequest<ProductsInfoDto>(
        "${NetworkConstants.productsInfo}?category_id=${categoryId ?? ''}&supplier_id=${supplierId ?? ''}",
        converter: (response) => ProductsInfoDto.fromJson(response),
      );
      return res;
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<PaginatedDto<ProductDto>> getUnsoldProducts(
      int page, bool ordering) async {
    final res = await _dioClient.getRequest<PaginatedDto<ProductDto>>(
      NetworkConstants.productsUnsold,
      queryParameters: {
        "page": page,
        "page_size": 50,
        "ordering": ordering ? "sale_count" : "-sale_count"
      },
      converter: (response) => PaginatedDto.fromJson(
        response,
        (json) => ProductDto.fromJson(json),
      ),
    );
    return res;
  }

  @override
  Future<void> downloadContract(
      String type, int reserveId, String savePath) async {
    try {
      await _dioClient.downloadRequest(
          "${NetworkConstants.reserve}/$reserveId/contract-invoices/download-excel",
          queryParameters: {
            "contract_type": type,
            "reserve_id": reserveId,
          },
          "$savePath/contract_${type}_$reserveId.xlsx");
    } catch (_) {}
  }

  @override
  Future<List<ManagerReportDto>> getManagerReport(
      {required int managerId,
      int? productId,
      required String fromDate,
      required String toDate}) async {
    return await _dioClient.getRequest(
        "${NetworkConstants.posManager}/$managerId/reports",
        queryParameters: {
          "from_date": fromDate,
          "to_date": toDate,
          "product_id": productId,
          "page_size": 200,
        }, converter: (response) {
      try {
        final List<dynamic> jsonList = response['results'] as List<dynamic>;
        return jsonList.map((json) => ManagerReportDto.fromJson(json)).toList();
      } catch (ex, s) {
        print(ex);
        print(s);
        rethrow;
      }
    });
  }

  @override
  Future<ManagerReportDto> getManagerReportTotal(
      {required int managerId,
      required String fromDate,
      required String toDate}) async {
    return await _dioClient.getRequest(
        "${NetworkConstants.posManager}/$managerId/reports/total",
        queryParameters: {
          "from_date": fromDate,
          "to_date": toDate,
        }, converter: (response) {
      try {
        return ManagerReportDto.fromJson(response);
      } catch (ex, s) {
        print(ex);
        print(s);
        rethrow;
      }
    });
  }

  @override
  Future<List<RetailReportTotal>> getRetailReportTotal(
      {required String fromDate, required String toDate}) async {
    return await _dioClient
        .getRequest("${NetworkConstants.stockReports}/total", queryParameters: {
      "from_date": fromDate,
      "to_date": toDate,
    }, converter: (response) {
      try {
        return List.from(response)
            .map((e) => RetailReportTotal.fromJson(e))
            .toList();
      } catch (ex, s) {
        print(ex);
        print(s);
        rethrow;
      }
    });
  }
}
