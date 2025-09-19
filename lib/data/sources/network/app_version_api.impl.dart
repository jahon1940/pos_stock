import 'package:hoomo_pos/core/constants/network.dart';
import 'package:hoomo_pos/core/network/dio_client.dart';
import 'package:hoomo_pos/data/dtos/app_version_dto.dart';
import 'package:hoomo_pos/data/sources/network/app_version_api.dart';
import 'package:injectable/injectable.dart';

@LazySingleton(as: AppVersionApi)
class AppVersionApiImpl implements AppVersionApi {
  final DioClient _dioClient;

  AppVersionApiImpl(this._dioClient);

  @override
  Future<AppVersionDto> getAppVersion() async {
    try {
      final res = await _dioClient.getRequest(
        NetworkConstants.appVersion,
        converter: (response) => AppVersionDto.fromJson(response),
      );

      return res;
    } catch (e) {
      rethrow;
    }
  }
}
