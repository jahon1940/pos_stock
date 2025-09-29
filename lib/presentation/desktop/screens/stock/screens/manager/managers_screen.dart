import 'package:auto_route/auto_route.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hoomo_pos/core/extensions/color_extension.dart';
import 'package:hoomo_pos/core/extensions/context.dart';
import 'package:hoomo_pos/core/extensions/edge_insets_extensions.dart';
import 'package:hoomo_pos/presentation/desktop/screens/stock/widgets/table_title_widget.dart';

import '../../../../../../../app/router.dart';
import '../../../../../../../app/router.gr.dart';
import '../../../../../../../core/constants/app_utils.dart';
import '../../../../../../../core/styles/colors.dart';
import '../../../../../../../core/styles/text_style.dart';
import '../../../../../../../core/widgets/custom_box.dart';
import '../../../../../../../core/widgets/text_field.dart';
import '../../../../../../../data/dtos/company_dto.dart';
import '../../../../../../core/widgets/product_table_item.dart';
import '../../../../../../data/dtos/manager/manager_dto.dart';
import '../../widgets/back_button_widget.dart';
import '../add_manager/cubit/add_manager_cubit.dart';

part 'widgets/manager_item_widget.dart';

@RoutePage()
class ManagersScreen extends HookWidget {
  const ManagersScreen({
    super.key,
    required this.organization,
  });

  final CompanyDto organization;
  static const _columnWidths = {
    0: FlexColumnWidth(6),
    1: FlexColumnWidth(4),
    2: FlexColumnWidth(4),
    3: FlexColumnWidth(2),
  };

  @override
  Widget build(
    BuildContext context,
  ) {
    useEffect(() {
      context.managerBloc.getManagers();
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
                        hintStyle: AppTextStyles.mType16.copyWith(color: AppColors.primary500),
                        contentPadding: const EdgeInsets.all(14),
                        hint: "Поиск сотрудников",
                        fieldController: searchController,
                        suffix: IconButton(icon: const Icon(Icons.close), onPressed: () {}),
                      ),
                    ),
                  ),

                  /// add button
                  AppUtils.kGap12,
                  GestureDetector(
                    onTap: () => router
                        .push(AddManagerRoute(organizations: organization))
                        .then((_) => context.managerBloc.getManagers()),
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
            Expanded(
              child: CustomBox(
                padding: AppUtils.kPaddingAll12.withB0,
                child: Column(
                  children: [
                    /// table title
                    TableTitleWidget(
                      columnWidths: _columnWidths,
                      titles: [
                        context.tr("name"),
                        context.tr("phone_number"),
                        context.tr("position"),
                        "Действия",
                      ],
                    ),

                    /// items
                    AppUtils.kGap12,
                    BlocBuilder<AddManagerCubit, AddManagerState>(
                      builder: (context, state) => Expanded(
                        child: state.status.isLoading && state.managers == null
                            ? const Center(child: CircularProgressIndicator())
                            : state.managers?.isEmpty ?? true
                                ? Center(child: Text(context.tr("not_found")))
                                : ListView.separated(
                                    shrinkWrap: true,
                                    padding: const EdgeInsets.symmetric(vertical: 12).withT0,
                                    itemCount: state.managers!.length,
                                    separatorBuilder: (_, __) => AppUtils.kGap12,
                                    itemBuilder: (context, index) => ManagerItemWidget(
                                      organization: organization,
                                      manager: state.managers!.elementAt(index),
                                      columnWidths: _columnWidths,
                                    ),
                                  ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
