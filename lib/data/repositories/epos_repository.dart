import 'package:dio/dio.dart' show CancelToken;
import 'package:hoomo_pos/data/dtos/receipt_dto.dart';
import 'package:hoomo_pos/data/dtos/z_report_info_dto.dart';
import 'package:hoomo_pos/data/sources/network/epos_api.dart';
import 'package:hoomo_pos/domain/repositories/epos_repository.dart';
import 'package:injectable/injectable.dart';

@LazySingleton(as: EposRepository)
class EposRepositoryImpl implements EposRepository {
  final EposApi _eposApi;

  EposRepositoryImpl(this._eposApi);

  @override
  Future<String> checkStatus() {
    // TODO: implement checkStatus
    throw UnimplementedError();
  }

  @override
  Future<String> closeZReport() async{
    return await _eposApi.closeZReport();
  }

  @override
  Future<ReceiptDto> fiscalOperation(ReceiptDto receipt, CancelToken? cancelToken) async{
    return await _eposApi.fiscalOperation(receipt,cancelToken);
  }

  @override
  Future<ZReportInfoDto> getZReportInfo() async{
    return await _eposApi.getZReportInfo();
  }

  @override
  Future<String> labelValidation(String mark) async{
    return await _eposApi.labelValidation(mark);
  }

  @override
  Future<String> openZReport() async{
    return await _eposApi.openZReport();
  }

  @override
  Future<void> sendReceipt() async{
    return await _eposApi.sendReceipt();
  }
}