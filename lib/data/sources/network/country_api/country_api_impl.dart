part of 'country_api.dart';

@LazySingleton(as: CountryApi)
class CountryApiImpl implements CountryApi {
  CountryApiImpl({
    required DioClient dioClient,
  }) : _dioClient = dioClient;

  // ignore: unused_field
  final DioClient _dioClient;
}
