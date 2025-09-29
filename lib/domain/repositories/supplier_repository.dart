import 'package:dio/dio.dart';
import 'package:hoomo_pos/core/exceptions/server_exception.dart';
import 'package:hoomo_pos/data/dtos/suppliers/supplier_dto.dart';
import 'package:injectable/injectable.dart';

import '../../data/sources/network/supplier_api/supplier_api.dart';

part '../../data/repositories/supplier_repository_impl.dart';

abstract class SupplierRepository {
  Future<List<SupplierDto>?> getSuppliers();

  Future<void> createSupplier(SupplierDto supplier);

  Future<void> updateSupplier(SupplierDto supplier);

  Future<void> deleteSupplier(int supplierId);
}
