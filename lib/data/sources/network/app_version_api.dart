import 'package:hoomo_pos/data/dtos/app_version_dto.dart';

abstract class AppVersionApi {
  Future<AppVersionDto> getAppVersion();
}
