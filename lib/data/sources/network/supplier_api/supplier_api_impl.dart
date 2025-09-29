part of 'supplier_api.dart';

@LazySingleton(as: SupplierApi)
class SupplierApiImpl extends SupplierApi {
  SupplierApiImpl(
    this._dioClient,
  );

  final DioClient _dioClient;

  @override
  Future<void> createSupplier(
    SupplierDto supplier,
  ) async =>
      _dioClient.postRequest(NetworkConstants.suppliers, data: supplier.toJson());

  @override
  Future<void> deleteSupplier(
    int supplierId,
  ) async =>
      _dioClient.deleteRequest("${NetworkConstants.suppliers}/$supplierId");

  @override
  Future<List<SupplierDto>?> getSuppliers() async {
    final res = await _dioClient.getRequest(
      NetworkConstants.suppliers,
      converter: (response) => List.from(response['results'])
          .map(
            (e) => SupplierDto.fromJson(e),
          )
          .toList(),
    );
    return res;
  }

  @override
  Future<void> updateSupplier(
    SupplierDto supplier,
  ) async =>
      _dioClient.putRequest("${NetworkConstants.suppliers}/${supplier.id}", data: supplier.toJson());
}
