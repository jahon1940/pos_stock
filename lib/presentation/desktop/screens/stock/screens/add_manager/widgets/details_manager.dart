import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hoomo_pos/core/constants/spaces.dart';
import 'package:hoomo_pos/core/enums/states.dart';
import 'package:hoomo_pos/core/extensions/context.dart';
import 'package:hoomo_pos/presentation/desktop/screens/stock/screens/add_manager/cubit/add_manager_cubit.dart';
import '../../../../../../../core/styles/text_style.dart';
import '../../../../../../../core/widgets/custom_box.dart';
import '../../../../../../../core/widgets/text_field.dart';

class DetailsManager extends HookWidget {
  const DetailsManager({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final cubit = context.read<AddManagerCubit>();

    return CustomBox(
      child: Padding(
          padding: const EdgeInsets.all(24),
          child: BlocBuilder<AddManagerCubit, AddManagerState>(
              builder: (context, state) {
                if (state.status == StateStatus.loading) {
                  return const Center(
                      child: CircularProgressIndicator());
                }
            return Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                const Text('Данные Сотрудника',
                    style: AppTextStyles.boldType14),
                AppSpace.vertical24,
                AppTextField(
                  prefix: Icon(
                    Icons.person_pin_rounded,
                    color: context.primary,
                  ),
                  fieldController: cubit.nameController,
                  width: double.maxFinite,
                  contentPadding:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 18),
                  label: 'Название ...',
                  alignLabelWithHint: true,
                  maxLines: 1,
                  textInputType: TextInputType.text,
                  style: AppTextStyles.boldType14
                      .copyWith(fontWeight: FontWeight.w400),
                ),
                AppSpace.vertical24,
                AppTextField(
                  prefix: Icon(
                    Icons.emoji_flags_rounded,
                    color: context.primary,
                  ),
                  fieldController: cubit.positionController,
                  width: double.maxFinite,
                  contentPadding:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 18),
                  label: 'Должность ...',
                  alignLabelWithHint: true,
                  maxLines: 1,
                  textInputType: TextInputType.text,
                  style: AppTextStyles.boldType14
                      .copyWith(fontWeight: FontWeight.w400),
                ),
                AppSpace.vertical24,
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Expanded(
                      flex: 2,
                      child: AppTextField(
                        prefix: Icon(
                          Icons.call,
                          color: context.primary,
                        ),
                        fieldController: cubit.phoneController,
                        width: double.maxFinite,
                        contentPadding: const EdgeInsets.symmetric(
                            horizontal: 16, vertical: 18),
                        label: 'Номер телефона...',
                        alignLabelWithHint: true,
                        maxLines: 1,
                        textInputType: TextInputType.text,
                        style: AppTextStyles.boldType14
                            .copyWith(fontWeight: FontWeight.w400),
                      ),
                    ),
                  ],
                ),
              ],
            );
          })),
    );
  }
}
