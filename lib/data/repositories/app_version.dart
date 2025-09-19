import 'package:hoomo_pos/data/dtos/app_version_dto.dart';
import 'package:hoomo_pos/data/sources/network/app_version_api.dart';
import 'package:hoomo_pos/domain/repositories/app_version.dart';
import 'package:injectable/injectable.dart';

@LazySingleton(as: AppVersionRepository)
class AppVersionRepositoryImpl implements AppVersionRepository {
  final AppVersionApi _appVersionApi;

  AppVersionRepositoryImpl(this._appVersionApi);

  @override
  Future<AppVersionDto> getAppVersion() async {
    try {
      final res = await _appVersionApi.getAppVersion();

      return res;
    } catch (e) {
      rethrow;
    }
  }
}
