import 'package:dio/dio.dart';
import 'package:hoomo_pos/data/dtos/manager/manager_dto.dart';
import 'package:injectable/injectable.dart';

import '../../core/exceptions/server_exception.dart';
import '../../data/sources/network/manager_api/manager_api.dart';

part '../../data/repositories/manager_repository_impl.dart';

abstract class ManagerRepository {
  Future<List<ManagerDto>?> getManagers();

  Future<void> createManager(ManagerDto manager);

  Future<void> updateManager(ManagerDto manager);

  Future<void> deleteManager(String managerId);
}
