import 'package:hoomo_pos/core/constants/network.dart';
import 'package:hoomo_pos/core/network/dio_client.dart';
import 'package:injectable/injectable.dart';

import '../../../dtos/company/company_dto.dart';

part 'organization_api_impl.dart';

abstract class OrganizationApi {
  Future<List<CompanyDto>?> getOrganizations();
}
