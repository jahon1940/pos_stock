import 'package:auto_route/auto_route.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hoomo_pos/core/extensions/color_extension.dart';
import 'package:hoomo_pos/core/extensions/context.dart';

import '../../../../../../../app/router.dart';
import '../../../../../../../app/router.gr.dart';
import '../../../../../../../core/constants/app_utils.dart';
import '../../../../../../../core/styles/colors.dart';
import '../../../../../../../core/styles/text_style.dart';
import '../../../../../../../core/widgets/custom_box.dart';
import '../../../../../../../core/widgets/text_field.dart';
import '../../../../../../../data/dtos/company_dto.dart';
import '../../../../../../core/widgets/product_table_item.dart';
import '../../../../../../data/dtos/suppliers/supplier_dto.dart';
import '../../widgets/back_button_widget.dart';
import '../../widgets/title_person.dart';
import '../add_contractor/cubit/add_contractor_cubit.dart';
import '../add_manager/cubit/add_manager_cubit.dart';

@RoutePage()
class ManagersScreen extends HookWidget {
  const ManagersScreen({
    super.key,
    required this.organization,
  });

  final CompanyDto organization;

  @override
  Widget build(
    BuildContext context,
  ) {
    useEffect(() {
      context.read<AddManagerCubit>().getManagers();
      return null;
    }, const []);
    final searchController = useTextEditingController();
    return Scaffold(
      body: Padding(
        padding: AppUtils.kPaddingAll10,
        child: Column(
          children: [
            /// title
            Container(
              padding: AppUtils.kPaddingAll6,
              height: 60,
              decoration: BoxDecoration(
                color: context.theme.cardColor,
                borderRadius: BorderRadius.circular(10),
                boxShadow: [const BoxShadow(color: AppColors.stroke, blurRadius: 3)],
              ),
              child: Row(
                children: [
                  /// back button
                  const BackButtonWidget(),

                  /// search field
                  AppUtils.kGap6,
                  Expanded(
                    child: DecoratedBox(
                      decoration: BoxDecoration(
                        color: AppColors.primary100.opcty(.3),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: AppTextField(
                        height: 50,
                        hintStyle: AppTextStyles.mType16.copyWith(color: AppColors.primary500),
                        contentPadding: const EdgeInsets.all(14),
                        hint: "Поиск сотрудников",
                        fieldController: searchController,
                        suffix: Row(
                          children: [
                            IconButton(icon: const Icon(Icons.close), onPressed: () {}),
                          ],
                        ),
                      ),
                    ),
                  ),

                  /// add button
                  AppUtils.kGap12,
                  GestureDetector(
                    onTap: () {
                      router.push(AddManagerRoute(organizations: organization)).then((_) {
                        context.read<AddManagerCubit>().getManagers();
                      });
                    },
                    child: Container(
                      padding: const EdgeInsets.all(5),
                      decoration: BoxDecoration(borderRadius: BorderRadius.circular(8), color: context.primary),
                      height: 50,
                      width: context.width * .1,
                      child: Center(
                        child: Text(
                          "Добавить",
                          maxLines: 2,
                          style: TextStyle(fontSize: 13, color: context.onPrimary),
                        ),
                      ),
                    ),
                  ),

                ],
              ),
            ),

            /// body
            AppUtils.kGap12,
          ],
        ),
      ),
    );
  }
}
