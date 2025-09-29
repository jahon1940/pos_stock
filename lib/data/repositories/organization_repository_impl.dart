part of '../../domain/repositories/organization_repository.dart';

@LazySingleton(as: OrganizationRepository)
class OrganizationRepositoryImpl implements OrganizationRepository {
  OrganizationRepositoryImpl(
    this._organizationApi,
  );

  final OrganizationApi _organizationApi;

  @override
  Future<List<CompanyDto>?> getOrganizations() async {
    try {
      final res = await _organizationApi.getOrganizations();
      return res;
    } catch (e) {
      debugPrint(e.toString());
      return null;
    }
  }
}
