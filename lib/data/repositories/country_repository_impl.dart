part of '../../domain/repositories/country_repository.dart';

@LazySingleton(as: CountryRepository)
class CountryRepositoryImpl implements CountryRepository {
  CountryRepositoryImpl(
    this._countryApi,
  );

  // ignore: unused_field
  final CountryApi _countryApi;
}
