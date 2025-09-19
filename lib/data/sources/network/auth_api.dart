import 'package:hoomo_pos/data/dtos/auth_dto.dart';
import 'package:hoomo_pos/data/dtos/login_request.dart';

abstract class AuthApi {
  Future<AuthDto> login(LoginRequest request);
}
