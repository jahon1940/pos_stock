import 'package:hoomo_pos/data/dtos/suppliers/supplier_dto.dart';

abstract class SupplierRepository {
  Future<List<SupplierDto>?> getSuppliers();

  Future<void> createSupplier(SupplierDto supplier);

  Future<void> updateSupplier(SupplierDto supplier);

  Future<void> deleteSupplier(int supplierId);
}
