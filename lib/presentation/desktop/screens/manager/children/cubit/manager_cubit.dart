import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart' show AlertDialog, TextButton, TextEditingController, showDialog;
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:hoomo_pos/core/enums/states.dart';
import 'package:hoomo_pos/data/dtos/manager/manager_dto.dart';
import 'package:hoomo_pos/domain/repositories/manager_repository.dart';
import 'package:injectable/injectable.dart';
import 'package:uuid/uuid.dart';

part 'manager_state.dart';

part 'manager_cubit.freezed.dart';

@injectable
class ManagerCubit extends Cubit<ManagerState> {
  ManagerCubit(
    this._managerRepository,
  ) : super(const ManagerState());

  final ManagerRepository _managerRepository;

  final nameController = TextEditingController();
  final positionController = TextEditingController();
  final phoneController = TextEditingController();

  void init(
    ManagerDto? manager,
  ) async {
    if (manager == null) return;
    nameController.text = manager.name ?? '';
    positionController.text = manager.position ?? '';
    phoneController.text = manager.phoneNumber ?? '';
    emit(state.copyWith(manager: manager));
  }

  void getManagers() async {
    emit(state.copyWith(status: StateStatus.loading));
    List<ManagerDto>? managers = await _managerRepository.getManagers();
    emit(state.copyWith(managers: managers, status: StateStatus.loaded));
  }

  void createManager(
    BuildContext context,
  ) async {
    if (nameController.text.isEmpty) {
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text("Заполните все поля"),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text("ОК"),
            ),
          ],
        ),
      );
      return;
    }

    emit(state.copyWith(status: StateStatus.loading));

    final isNew = state.manager == null;

    if (isNew) {
      ManagerDto managerDto = ManagerDto(
        cid: const Uuid().v4(),
        name: nameController.text,
        position: positionController.text,
        phoneNumber: phoneController.text,
      );
      await _managerRepository.createManager(managerDto);
    } else {
      ManagerDto managerDto = state.manager!.copyWith(
        name: nameController.text,
        position: positionController.text,
        phoneNumber: phoneController.text,
      );
      await _managerRepository.updateManager(managerDto);
    }

    // Показываем диалог
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Успешно"),
        content: Text(isNew ? "Сотрудник создан" : "Сотрудник обновлён"),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text("ОК"),
          ),
        ],
      ),
    );
    Navigator.pop(context);
  }

  void deleteManager(
    String managerId,
  ) async {
    emit(state.copyWith(status: StateStatus.loading));
    await _managerRepository.deleteManager(managerId);
    getManagers();
  }
}
