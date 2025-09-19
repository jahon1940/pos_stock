
import 'package:flutter/material.dart';
import 'package:hoomo_pos/core/extensions/context.dart';
import 'package:hoomo_pos/core/styles/colors.dart';
import 'package:hoomo_pos/core/styles/text_style.dart';
import 'package:hoomo_pos/core/widgets/text_field.dart';
import 'package:hoomo_pos/data/dtos/company_dto.dart';
import 'package:hoomo_pos/data/dtos/pos_manager_dto.dart';
import 'package:hoomo_pos/domain/services/formatter_service.dart';
import 'package:hoomo_pos/presentation/desktop/dialogs/contract/cubit/contract_bloc.dart';
import 'package:intl/intl.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class CreateContract extends StatefulWidget {
  const CreateContract({
    super.key,
    required this.companyDto,
    required this.posManagerDto,
  });

  final CompanyDto companyDto;
  final PosManagerDto posManagerDto;

  @override
  State<CreateContract> createState() => _CreateContractState();
}

class _CreateContractState extends State<CreateContract> {
  @override
  Widget build(BuildContext context) {
    final width = (context.width * 0.5) / 2;
    final bloc = context.read<ContractBloc>();

    return Column(
      children: [
        // Название и номер договора
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: AppTextField(
            label: "Номер договора",
            enabledBorderWith: 1,
            enabledBorderColor: AppColors.stroke,
            focusedBorderColor: AppColors.stroke,
            focusedBorderWith: 1,
            fieldController: bloc.contractNumber,
          ),
        ),
        // Организация и ИНН
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: AppTextField(
                width: width,
                label: "Организация",
                readOnly: true,
                enabledBorderWith: 1,
                enabledBorderColor: AppColors.stroke,
                focusedBorderColor: AppColors.stroke,
                focusedBorderWith: 1,
                fieldController: TextEditingController(
                  text: widget.posManagerDto.pos?.stock?.organization?.name,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: AppTextField(
                width: width,
                label: "ИНН организации",
                readOnly: true,
                enabledBorderWith: 1,
                enabledBorderColor: AppColors.stroke,
                focusedBorderColor: AppColors.stroke,
                focusedBorderWith: 1,
                fieldController: TextEditingController(
                  text: widget.posManagerDto.pos?.stock?.organization?.inn,
                ),
              ),
            ),
          ],
        ),
        // Клиент и ИНН клиента
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: AppTextField(
                width: width,
                label: "Клиент",
                readOnly: true,
                enabledBorderWith: 1,
                enabledBorderColor: AppColors.stroke,
                focusedBorderColor: AppColors.stroke,
                focusedBorderWith: 1,
                fieldController: TextEditingController(
                  text: widget.companyDto.name,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: AppTextField(
                width: width,
                label: "ИНН клиента",
                readOnly: true,
                enabledBorderWith: 1,
                enabledBorderColor: AppColors.stroke,
                focusedBorderColor: AppColors.stroke,
                focusedBorderWith: 1,
                fieldController: TextEditingController(
                  text: widget.companyDto.inn,
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
              child: GestureDetector(
                onTap: () async {
                  final picked = await showDatePicker(
                    context: context,
                    initialDate: DateTime.now(),
                    firstDate: DateTime(2000),
                    lastDate: DateTime(2100),
                  );
                  if (picked != null) {
                    bloc.contractDate.text = DateFormat("dd.MM.yyyy").format(picked);
                    bloc.generateContractNumber();
                  }
                },
                child: AbsorbPointer(
                  child: AppTextField(
                    width: width,
                    label: "Дата",
                    readOnly: true,
                    enabledBorderWith: 1,
                    enabledBorderColor: AppColors.stroke,
                    focusedBorderColor: AppColors.stroke,
                    focusedBorderWith: 1,
                    fieldController: bloc.contractDate,
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: SizedBox(
                width: width,
                child: DropdownButtonFormField<String>(
                  decoration: InputDecoration(
                    labelText: "Тип договора",
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
                  value: bloc.contractType,
                  items: ["Годовая", "Разовая"]
                      .map((type) => DropdownMenuItem(
                    value: type,
                    child: Text(type),
                  ))
                      .toList(),
                  onChanged: (value) {
                    setState(() {
                      bloc.contractType = value;
                    });
                  },
                ),
              ),
            ),
          ],
        ),
        // Кнопка
        Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
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
                  if (bloc.contractNumber.text.isEmpty ||
                      bloc.contractType == null) {
                    return;
                  }

                  context.read<ContractBloc>().add(
                    CreateContractEvent(
                      bloc.contractNumber.text,
                      FormatterService().datePosFormatter(
                        bloc.contractDate.text,
                      ),
                      widget.companyDto.id,
                      bloc.contractId
                    ),
                  );
                },
                child: Text(
                  bloc.contractId == null ? "Создать договор" : "Обновить договор",
                  style: AppTextStyles.boldType16,
                  textAlign: TextAlign.center,
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}
