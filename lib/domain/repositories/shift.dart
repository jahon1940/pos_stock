import 'package:hoomo_pos/data/dtos/z_report_info_dto.dart';

abstract class ShiftRepository {
  Future<ZReportInfoDto> getZReport();

  Future<String> openZReport();

  Future<String> closeZReport();

  Future<void> downloadReport(String date);
}
