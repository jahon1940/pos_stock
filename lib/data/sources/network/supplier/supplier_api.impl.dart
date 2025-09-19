import 'package:hoomo_pos/core/constants/network.dart';
import 'package:hoomo_pos/core/network/dio_client.dart';
import 'package:hoomo_pos/data/dtos/suppliers/supplier_dto.dart';
import 'package:injectable/injectable.dart';

import '../../../dtos/transfers/create_transfers.dart';
import 'supplier_api.dart';

@LazySingleton(as: SupplierApi)
class SupplierApiImpl extends SupplierApi {
  final DioClient _dioClient;

  SupplierApiImpl(this._dioClient);

  @override
  Future<void> createSupplier(SupplierDto supplier) async {
    await _dioClient.postRequest(NetworkConstants.suppliers,
        data: supplier.toJson());
  }

  @override
  Future<void> deleteSupplier(int supplierId) async {
    await _dioClient.deleteRequest("${NetworkConstants.suppliers}/$supplierId");
  }

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
  Future<void> updateSupplier(SupplierDto supplier) async {
    await _dioClient.putRequest("${NetworkConstants.suppliers}/${supplier.id}",
        data: supplier.toJson());
  }
}
