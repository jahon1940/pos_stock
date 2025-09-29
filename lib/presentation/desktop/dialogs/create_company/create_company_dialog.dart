import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hoomo_pos/core/extensions/context.dart';
import 'package:hoomo_pos/core/styles/colors.dart';
import 'package:hoomo_pos/core/styles/text_style.dart';
import 'package:hoomo_pos/core/widgets/text_field.dart';
import 'package:hoomo_pos/data/dtos/company/company_dto.dart';
import 'package:hoomo_pos/presentation/desktop/dialogs/create_company/cubit/create_company_cubit.dart';

class CreateCompany extends StatefulWidget {
  const CreateCompany({
    super.key, this.companyDto
  });

  final CompanyDto? companyDto;

  @override
  State<CreateCompany> createState() => _CreateCompanyState();
}

class _CreateCompanyState extends State<CreateCompany> {
  @override
  Widget build(BuildContext context) {
    final width = (context.width * 0.5) / 3;

    var cubit = context.read<CreateCompanyCubit>();
    cubit.init(widget.companyDto);

    return Material(
      borderRadius: BorderRadius.circular(12),
      child: SizedBox(
        width: context.width * 0.4,
        height: context.height * 0.5,
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(12),
              child: Text("Создания клиента", style: AppTextStyles.boldType18),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: AppTextField(
                    width: width,
                    label: "Название",
                    enabledBorderWith: 1,
                    enabledBorderColor: AppColors.stroke,
                    focusedBorderColor: AppColors.stroke,
                    focusedBorderWith: 1,
                    fieldController: cubit.nameController,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: AppTextField(
                    width: width,
                    label: "ИНН",
                    enabledBorderWith: 1,
                    enabledBorderColor: AppColors.stroke,
                    focusedBorderColor: AppColors.stroke,
                    focusedBorderWith: 1,
                    fieldController: cubit.tinController,
                  ),
                ),
              ],
            ),
            // Организация и ИНН
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: AppTextField(
                    width: width,
                    label: "Номер телефона",
                    enabledBorderWith: 1,
                    enabledBorderColor: AppColors.stroke,
                    focusedBorderColor: AppColors.stroke,
                    focusedBorderWith: 1,
                    fieldController: cubit.phoneController
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: GestureDetector(
                    onTap: () async {
                      final picked = await showDatePicker(
                        context: context,
                        initialDate: DateTime.now(),
                        firstDate: DateTime(2000),
                        lastDate: DateTime(2100),
                      );
                      if (picked != null) {
                        cubit.birthController.text = DateFormat("dd.MM.yyyy").format(picked);
                      }
                    },
                    child: AbsorbPointer(
                      child: AppTextField(
                        width: width,
                        label: "Дата рождения",
                        readOnly: true,
                        enabledBorderWith: 1,
                        enabledBorderColor: AppColors.stroke,
                        focusedBorderColor: AppColors.stroke,
                        focusedBorderWith: 1,
                        fieldController: cubit.birthController,
                      ),
                    ),
                  ),
                ),
              ],
            ),
            //выбор даты и тип договора
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: SizedBox(
                    width: width,
                    child: DropdownButtonFormField<String>(
                      decoration: InputDecoration(
                        labelText: "Тип клиента",
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide(color: AppColors.stroke),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide(color: AppColors.stroke),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide(color: AppColors.stroke),
                        ),
                      ),
                      value: cubit.companyType,
                      items: ["individual", "company"]
                          .map((type) => DropdownMenuItem(
                        value: type,
                        child: Text(context.tr(type)),
                      ))
                          .toList(),
                      onChanged: (value) {
                        setState(() {
                          cubit.companyType = value ?? "";
                        });
                      },
                    ),
                  ),
                ),
                Container(
                  height: 50,
                  margin: const EdgeInsets.all(10),
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.success600,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    onPressed: () {
                      cubit.createCompany(context);
                    },
                    child: Text(cubit.isUpdate() ? "Обновить клиента" : "Создать клиента",
                      style: AppTextStyles.boldType16,
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
