import 'package:flutter/foundation.dart';
import 'package:injectable/injectable.dart';

import '../../data/dtos/company/company_dto.dart';
import '../../data/sources/network/organization_api/organization_api.dart';

part '../../data/repositories/organization_repository_impl.dart';

abstract class OrganizationRepository {
  Future<List<CompanyDto>?> getOrganizations();
}
