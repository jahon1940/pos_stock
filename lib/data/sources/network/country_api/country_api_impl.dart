part of 'country_api.dart';

@LazySingleton(as: CountryApi)
class CountryApiImpl implements CountryApi {
  CountryApiImpl({
    required DioClient dioClient,
  }) : _dioClient = dioClient;

  final DioClient _dioClient;

  @override
  Future<PaginatedDto<CountryDto>?> getCountries() async => _dioClient.getRequest(
        NetworkConstants.countryManagers,
        converter: (response) => PaginatedDto.fromJson(
          response,
          (json) => CountryDto.fromJson(json),
        ),
      );

  @override
  Future<void> createCountry({
    required Map<String, dynamic> data,
  }) async =>
      _dioClient.postRequest(NetworkConstants.countryManagers, data: data);

  @override
  Future<void> updateCountry({
    required Map<String, dynamic> data,
    required String countryCid,
  }) async =>
      _dioClient.putRequest('${NetworkConstants.countryManagers}/$countryCid', data: data);
}
