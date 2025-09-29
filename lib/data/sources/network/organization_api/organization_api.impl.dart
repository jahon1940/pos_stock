part of 'organization_api.dart';

@LazySingleton(as: OrganizationApi)
class OrganizationApiImpl implements OrganizationApi {
  OrganizationApiImpl({
    required DioClient dioClient,
  }) : _dioClient = dioClient;

  final DioClient _dioClient;

  @override
  Future<List<CompanyDto>?> getOrganizations() async {
    try {
      final res = await _dioClient.getRequest(
        NetworkConstants.organizationsStock,
        converter: (response) => List.from(response['results']).map((e) => CompanyDto.fromJson(e)).toList(),
      );
      return res;
    } catch (e) {
      rethrow;
    }
  }
}
