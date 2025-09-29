import 'package:hoomo_pos/data/dtos/manager/manager_dto.dart';

abstract class ManagerRepository {
  Future<List<ManagerDto>?> getManagers();

  Future<void> createManager(ManagerDto manager);

  Future<void> updateManager(ManagerDto manager);

  Future<void> deleteManager(String managerId);
}
