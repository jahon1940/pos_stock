import 'package:hoomo_pos/data/dtos/app_version_dto.dart';

abstract class AppVersionRepository {
  Future<AppVersionDto> getAppVersion();
}
