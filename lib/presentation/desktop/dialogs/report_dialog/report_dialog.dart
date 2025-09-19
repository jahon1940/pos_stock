import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hoomo_pos/core/constants/spaces.dart';
import 'package:hoomo_pos/core/enums/states.dart';
import 'package:hoomo_pos/core/extensions/context.dart';
import 'package:hoomo_pos/core/styles/colors.dart';
import 'package:hoomo_pos/core/styles/text_style.dart';
import 'package:hoomo_pos/core/widgets/custom_box.dart';
import 'package:hoomo_pos/core/widgets/text_field.dart';
import 'package:hoomo_pos/presentation/desktop/dialogs/report_dialog/cubit/report_manager_cubit.dart';

class ReportManagerDialog extends HookWidget {
  const ReportManagerDialog({super.key});

  @override
  Widget build(BuildContext context) {
    final fromController = useTextEditingController();
    final toController = useTextEditingController();
    final bloc = context.read<ReportManagerCubit>();

    return BlocBuilder<ReportManagerCubit, ReportManagerState>(
      builder: (context, state) {
        return SizedBox(
          width: context.width * 0.4,
          child: CustomBox(
            child: Padding(
              padding: const EdgeInsets.all(12),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    'Скачать отчёт менеджера',
                    style: AppTextStyles.boldType22,
                  ),
                  AppSpace.vertical24,
                  Text(
                    "Выберите менеджера: ",
                    style: AppTextStyles.boldType14,
                  ),
                  AppSpace.vertical12,
                  Padding(
                    padding: const EdgeInsets.only(bottom: 0),
                    child: DropdownButtonHideUnderline(
                      child: Container(
                        width: 300,
                        height: 35,
                        padding: const EdgeInsets.symmetric(
                            horizontal: 12, vertical: 4),
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.grey),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: DropdownButton<int?>(
                          value: state.selectedManager?.id,
                          hint: const Text("Выбрать"),
                          isDense: true,
                          isExpanded: true,
                          icon: const Icon(Icons.arrow_drop_down),
                          items: state.managers.map((manager) {
                            return DropdownMenuItem<int?>(
                              value: manager.id,
                              child: Text(manager.name ??
                                  "Не известно"), // или другой читаемый текст
                            );
                          }).toList(),
                          onChanged: (value) {
                            context
                                .read<ReportManagerCubit>()
                                .selectManager(value);
                          },
                        ),
                      ),
                    ),
                  ),
                  AppSpace.vertical24,
                  Text(
                    "Выберите даты: ",
                    style: AppTextStyles.boldType14,
                  ),
                  AppSpace.vertical12,
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      GestureDetector(
                        onTap: () async {
                          final picked = await showDatePicker(
                            context: context,
                            initialDate: DateTime.now(),
                            firstDate: DateTime(2000),
                            lastDate: DateTime(2100),
                          );
                          if (picked != null) {
                            bloc.selectFromDate(picked);

                            fromController.text =
                                DateFormat("dd.MM.yyyy").format(picked);
                          }
                        },
                        child: AbsorbPointer(
                          child: AppTextField(
                            width: 220,
                            label: "От: ",
                            readOnly: true,
                            enabledBorderWith: 1,
                            enabledBorderColor: AppColors.stroke,
                            focusedBorderColor: AppColors.stroke,
                            focusedBorderWith: 1,
                            fieldController: fromController,
                          ),
                        ),
                      ),
                      AppSpace.horizontal12,
                      GestureDetector(
                        onTap: () async {
                          final picked = await showDatePicker(
                            context: context,
                            initialDate: DateTime.now(),
                            firstDate: DateTime(2000),
                            lastDate: DateTime(2100),
                          );

                          if (picked != null) {
                            bloc.selectToDate(picked);
                            toController.text =
                                DateFormat("dd.MM.yyyy").format(picked);
                          }
                        },
                        child: AbsorbPointer(
                          child: AppTextField(
                            width: 220,
                            label: "До: ",
                            readOnly: true,
                            enabledBorderWith: 1,
                            enabledBorderColor: AppColors.stroke,
                            focusedBorderColor: AppColors.stroke,
                            focusedBorderWith: 1,
                            fieldController: toController,
                          ),
                        ),
                      ),
                    ],
                  ),
                  AppSpace.vertical12,
                  GestureDetector(
                    onTap: () async {
                      bloc.download();
                    },
                    child: Container(
                      padding: const EdgeInsets.all(5),
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(8),
                          color: context.primary),
                      height: 50,
                      width: context.width * .1,
                      child: Center(
                        child: Text(
                          state.status == StateStatus.loading
                              ? 'Скачивается'
                              : "Скачать",
                          maxLines: 2,
                          style:
                              TextStyle(fontSize: 13, color: context.onPrimary),
                        ),
                      ),
                    ),
                  ),
                  AppSpace.vertical24,
                  if (state.status == StateStatus.error)
                    Text('Произошла ошибка',
                        style: AppTextStyles.boldType14.copyWith(
                          color: AppColors.error500,
                        )),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
