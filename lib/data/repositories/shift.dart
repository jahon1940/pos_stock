import 'package:file_picker/file_picker.dart';
import 'package:hoomo_pos/data/dtos/z_report_info_dto.dart';
import 'package:hoomo_pos/data/sources/network/epos_api.dart';
import 'package:hoomo_pos/data/sources/network/pos_api.dart';
import 'package:injectable/injectable.dart';

import '../../domain/repositories/shift.dart';

@LazySingleton(as: ShiftRepository)
class ShiftRepositoryImpl implements ShiftRepository {
  final EposApi _eposApi;
  final PosApi _posApi;

  ShiftRepositoryImpl(this._eposApi, this._posApi);

  @override
  Future<String> closeZReport() async {
    return await _eposApi.closeZReport();
  }

  @override
  Future<ZReportInfoDto> getZReport() async {
    return await _eposApi.getZReportInfo();
  }

  @override
  Future<String> openZReport() async {
    return await _eposApi.openZReport();
  }

  @override
  Future<void> downloadReport(String date) async {
    try {
      final directory = await FilePicker.platform.getDirectoryPath();
      if (directory == null) return;
      String savePath = "$directory/sales_report_$date.xlsx";
      await _posApi.downloadReport(date, savePath);
    } catch (_) {
      rethrow;
    }
  }
}
