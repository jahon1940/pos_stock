import 'package:hoomo_pos/core/network/dio_client.dart';
import 'package:injectable/injectable.dart';

import '../../../../core/constants/network.dart';
import '../../../dtos/country/country_dto.dart';
import '../../../dtos/pagination_dto.dart';

part 'country_api_impl.dart';

abstract class CountryApi {
  Future<PaginatedDto<CountryDto>?> getCountries();
}
