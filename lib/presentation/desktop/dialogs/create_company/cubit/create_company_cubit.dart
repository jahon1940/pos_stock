import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart'
    show AlertDialog, TextButton, TextEditingController, showDialog;
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:hoomo_pos/core/enums/states.dart';
import 'package:hoomo_pos/data/dtos/company_dto.dart';
import 'package:hoomo_pos/data/dtos/create_company/create_company_request.dart';
import 'package:hoomo_pos/domain/repositories/create_company.dart';
import 'package:injectable/injectable.dart';

part 'create_company_state.dart';
part 'create_company_cubit.freezed.dart';

@injectable
class CreateCompanyCubit extends Cubit<CreateCompanyState> {
  CreateCompanyCubit(this._createCompanyRepository)
      : super(CreateCompanyState());

  final CreateCompanyRepository _createCompanyRepository;

  final nameController = TextEditingController();
  final tinController = TextEditingController();
  final phoneController = TextEditingController();
  final birthController = TextEditingController();
  String companyType = "individual";

  void init(CompanyDto? company) async {
    // if (company == null) return;

    nameController.text = company?.name ?? '';
    tinController.text = company?.inn ?? '';
    phoneController.text = company?.phoneNumbers?.first ?? '';

    emit(state.copyWith(company: company));
  }

  void createCompany(BuildContext context) async {
    if (nameController.text.isEmpty || phoneController.text.isEmpty) {
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

    final isNew = state.company == null;

    if (isNew) {
      CreateCompanyRequest request = CreateCompanyRequest(
          name: nameController.text,
          birthDay: birthController.text,
          inn: tinController.text.isEmpty ? null : tinController.text,
          companyType: companyType,
          phoneNumber: phoneController.text);

      try {
        await _createCompanyRepository.createCompany(request);
        Navigator.pop(context, true);
      } catch (ex) {
        if (ex is DioException) {
          if (context.mounted) {
            showDialog(
              context: context,
              builder: (context) => AlertDialog(
                title: Text("Ошибка"),
                content: Text(
                    ex.response?.data.toString() ?? "Ошибка при обработке"),
                actions: [
                  TextButton(
                    onPressed: () => Navigator.of(context).pop(),
                    child: Text("ОК"),
                  ),
                ],
              ),
            );
          } else {
            print("Context not mounted — can't show dialog");
          }
        } else {
          print("Не DioException");
        }
      }
    } else {
      CreateCompanyRequest request = CreateCompanyRequest(
          name: nameController.text,
          birthDay: birthController.text,
          inn: tinController.text.isEmpty ? null : tinController.text,
          companyType: companyType,
          phoneNumber: phoneController.text);
      try {
        await _createCompanyRepository.updateCompany(
            state.company!.id, request);
        Navigator.pop(context, true);
      } catch (ex) {
        if (ex is DioException) {
          if (context.mounted) {
            showDialog(
              context: context,
              builder: (context) => AlertDialog(
                title: Text("Ошибка"),
                content: Text(
                    ex.response?.data.toString() ?? "Ошибка при обработке"),
                actions: [
                  TextButton(
                    onPressed: () => Navigator.of(context).pop(),
                    child: Text("ОК"),
                  ),
                ],
              ),
            );
          } else {
            print("Context not mounted — can't show dialog");
          }
        } else {
          print("Не DioException");
        }
      }
    }

    tinController.clear();
    nameController.clear();
    phoneController.clear();
    birthController.clear();
  }

  void deleteCompany(int companyId) async {
    emit(state.copyWith(status: StateStatus.loading));
    await _createCompanyRepository.deleteCompany(companyId);
  }

  bool isUpdate() {
    return state.company != null;
  }
}
