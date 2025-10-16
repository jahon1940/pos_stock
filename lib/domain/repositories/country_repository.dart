import 'package:injectable/injectable.dart';

import '../../data/dtos/country/country_dto.dart';
import '../../data/dtos/pagination_dto.dart';
import '../../data/sources/network/country_api/country_api.dart';

part '../../data/repositories/country_repository_impl.dart';

abstract class CountryRepository {
  Future<PaginatedDto<CountryDto>?> getCountries();
}
