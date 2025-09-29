import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hoomo_pos/core/constants/spaces.dart';
import 'package:hoomo_pos/core/extensions/context.dart';
import 'package:hoomo_pos/presentation/desktop/screens/stock/screens/supplier/cubit/supplier_cubit.dart';
import '../../../../../../../core/styles/text_style.dart';
import '../../../../../../../core/widgets/custom_box.dart';
import '../../../../../../../core/widgets/text_field.dart';

class SupplierDetailsWidget extends HookWidget {
  const SupplierDetailsWidget({
    super.key,
  });

  @override
  Widget build(
    BuildContext context,
  ) {
    final cubit = context.read<SupplierCubit>();
    return CustomBox(
      child: Padding(
          padding: const EdgeInsets.all(24),
          child: BlocBuilder<SupplierCubit, SupplierState>(builder: (context, state) {
            if (state.status.isLoading) {
              return const Center(child: CircularProgressIndicator());
            }
            return Column(
              children: [
                const Text('Данные Поставщика', style: AppTextStyles.boldType14),
                AppSpace.vertical24,
                AppTextField(
                  prefix: Icon(
                    Icons.person_pin_rounded,
                    color: context.primary,
                  ),
                  fieldController: cubit.nameController,
                  width: double.maxFinite,
                  contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 18),
                  label: 'Название ...',
                  alignLabelWithHint: true,
                  style: AppTextStyles.boldType14.copyWith(fontWeight: FontWeight.w400),
                ),
                AppSpace.vertical24,
                AppTextField(
                  prefix: Icon(
                    Icons.assured_workload,
                    color: context.primary,
                  ),
                  fieldController: cubit.tinController,
                  width: double.maxFinite,
                  contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 18),
                  label: 'ИНН ...',
                  alignLabelWithHint: true,
                  style: AppTextStyles.boldType14.copyWith(fontWeight: FontWeight.w400),
                ),
                AppSpace.vertical24,
                Row(
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
                        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 18),
                        label: 'Номер телефона...',
                        alignLabelWithHint: true,
                        style: AppTextStyles.boldType14.copyWith(fontWeight: FontWeight.w400),
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
