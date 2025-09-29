part of 'manager_api.dart';

@LazySingleton(as: ManagerApi)
class ManagerApiImpl extends ManagerApi {
  final DioClient _dioClient;

  ManagerApiImpl(this._dioClient);

  @override
  Future<void> createManager(
    ManagerDto manager,
  ) async =>
      _dioClient.postRequest(NetworkConstants.managers, data: manager.toJson());

  @override
  Future<void> deleteManager(
    String managerId,
  ) async =>
      _dioClient.deleteRequest("${NetworkConstants.managers}/$managerId");

  @override
  Future<List<ManagerDto>?> getManagers() async {
    final res = await _dioClient.getRequest(
      NetworkConstants.managers,
      converter: (response) => List.from(response['results'])
          .map(
            (e) => ManagerDto.fromJson(e),
          )
          .toList(),
    );

    return res;
  }

  @override
  Future<void> updateManager(
    ManagerDto manager,
  ) async =>
      _dioClient.putRequest("${NetworkConstants.managers}/${manager.cid}", data: manager.toJson());
}
