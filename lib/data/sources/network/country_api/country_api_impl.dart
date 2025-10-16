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
}
