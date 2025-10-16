part of '../../domain/repositories/country_repository.dart';

@LazySingleton(as: CountryRepository)
class CountryRepositoryImpl implements CountryRepository {
  CountryRepositoryImpl(
    this._api,
  );

  final CountryApi _api;

  @override
  Future<PaginatedDto<CountryDto>?> getCountries() async => _api.getCountries();

  @override
  Future<void> createCountry({
    required Map<String, dynamic> data,
  }) =>
      _api.createCountry(data: data);
}
