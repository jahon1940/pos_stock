import 'package:hoomo_pos/core/constants/network.dart';
import 'package:hoomo_pos/core/network/dio_client.dart';
import 'package:hoomo_pos/data/dtos/auth_dto.dart';
import 'package:hoomo_pos/data/dtos/login_request.dart';
import 'package:hoomo_pos/data/sources/network/auth_api.dart';
import 'package:injectable/injectable.dart';

@Injectable(as: AuthApi)
class AuthApiImpl implements AuthApi {
  final DioClient _dioClient;

  AuthApiImpl(this._dioClient);

  @override
  Future<AuthDto> login(LoginRequest request) async {
    try {
      final res = await _dioClient.postRequest(
        NetworkConstants.login,
        data: request.toJson(),
        converter: (response) => AuthDto.fromJson(response),
      );

      return res;
    } catch (e) {
      rethrow;
    }
  }
}
