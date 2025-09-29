import 'package:hoomo_pos/core/constants/network.dart';
import 'package:hoomo_pos/core/network/dio_client.dart';
import 'package:hoomo_pos/data/dtos/suppliers/supplier_dto.dart';
import 'package:injectable/injectable.dart';

part 'supplier_api_impl.dart';

abstract class SupplierApi {
  Future<List<SupplierDto>?> getSuppliers();

  Future<void> createSupplier(SupplierDto supplier);

  Future<void> updateSupplier(SupplierDto supplier);

  Future<void> deleteSupplier(int supplierId);
}
