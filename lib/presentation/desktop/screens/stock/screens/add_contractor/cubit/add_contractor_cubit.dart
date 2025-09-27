import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart' show AlertDialog, TextButton, TextEditingController, showDialog;
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:hoomo_pos/core/enums/states.dart';
import 'package:hoomo_pos/data/dtos/suppliers/supplier_dto.dart';
import 'package:hoomo_pos/domain/repositories/supplier_repository.dart';
import 'package:injectable/injectable.dart';

part 'add_contractor_state.dart';

part 'add_contractor_cubit.freezed.dart';

@injectable
class AddContractorCubit extends Cubit<AddContractorState> {
  AddContractorCubit(
    this._supplierRepository,
  ) : super(AddContractorState());

  final SupplierRepository _supplierRepository;

  final nameController = TextEditingController();
  final tinController = TextEditingController();
  final phoneController = TextEditingController();

  void init(SupplierDto? supplier) async {
    if (supplier == null) return;

    nameController.text = supplier.name ?? '';
    tinController.text = supplier.inn ?? '';
    phoneController.text = supplier.phoneNumber ?? '';

    emit(state.copyWith(supplier: supplier));
  }

  void getSuppliers() async {
    emit(state.copyWith(status: StateStatus.loading));
    List<SupplierDto>? suppliers = await _supplierRepository.getSuppliers();

    emit(state.copyWith(
      suppliers: suppliers,
      status: StateStatus.loaded,
    ));
  }

  void createContractor(BuildContext context) async {
    if (nameController.text.isEmpty) {
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: Text("Заполните все поля"),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text("ОК"),
            ),
          ],
        ),
      );
      return;
    }

    emit(state.copyWith(status: StateStatus.loading));

    final isNew = state.supplier == null;

    if (isNew) {
      SupplierDto supplierDto = SupplierDto(
        id: 0,
        name: nameController.text,
        inn: tinController.text,
        phoneNumber: phoneController.text,
      );
      await _supplierRepository.createSupplier(supplierDto);
    } else {
      SupplierDto supplierDto = state.supplier!.copyWith(
        name: nameController.text,
        inn: tinController.text,
        phoneNumber: phoneController.text,
      );
      await _supplierRepository.updateSupplier(supplierDto);
    }

    // Показываем диалог
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text("Успешно"),
        content: Text(isNew ? "Поставщик создан" : "Поставщик обновлён"),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: Text("ОК"),
          ),
        ],
      ),
    );
    Navigator.pop(context);
  }

  void deleteSupplier(int supplierId) async {
    emit(state.copyWith(status: StateStatus.loading));
    await _supplierRepository.deleteSupplier(supplierId);
    getSuppliers();
  }
}
