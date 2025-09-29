import 'package:hoomo_pos/data/dtos/manager/manager_dto.dart';
import 'package:injectable/injectable.dart';

import '../../../../core/constants/network.dart';
import '../../../../core/network/dio_client.dart';

part 'manager_api_impl.dart';

abstract class ManagerApi {
  Future<List<ManagerDto>?> getManagers();

  Future<void> createManager(ManagerDto manager);

  Future<void> updateManager(ManagerDto manager);

  Future<void> deleteManager(String managerId);
}
