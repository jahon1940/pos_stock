import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hoomo_pos/app/router.gr.dart';
import 'package:hoomo_pos/core/enums/states.dart';
import 'package:hoomo_pos/core/extensions/context.dart';
import 'package:hoomo_pos/core/widgets/product_table_item.dart';
import 'package:hoomo_pos/data/dtos/manager/manager_dto.dart';
import 'package:hoomo_pos/presentation/desktop/screens/stock/screens/add_manager/cubit/add_manager_cubit.dart';
import 'package:hoomo_pos/presentation/desktop/screens/stock/widgets/title_manager.dart';
import '../../../../../../../app/router.dart';
import '../../../../../../../core/constants/spaces.dart';
import '../../../../../../../core/styles/colors.dart';
import '../../../../../../../core/styles/text_style.dart';
import '../../../../../../../core/widgets/custom_box.dart';
import '../../../../../../../core/widgets/text_field.dart';
import '../../../../../../../data/dtos/company_dto.dart';

class Managers extends HookWidget {
  const Managers(
    this.organizations, {
    super.key,
  });
  final CompanyDto organizations;
  @override
  Widget build(BuildContext context) {
    useEffect(() {
      context.read<AddManagerCubit>().getManagers();
      return null;
    }, const []);

    final searchController = useTextEditingController();
    ThemeData themeData = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.all(4),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Container(
            decoration: BoxDecoration(
              color: themeData.cardColor,
              borderRadius: BorderRadius.circular(10),
              boxShadow: [BoxShadow(color: AppColors.stroke, blurRadius: 3)],
            ),
            height: 60,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Expanded(
                    child: DecoratedBox(
                      decoration: BoxDecoration(
                        color: AppColors.primary100.withOpacity(0.3),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: AppTextField(
                        radius: 8,
                        height: 50,
                        hintStyle: AppTextStyles.mType16
                            .copyWith(color: AppColors.primary500),
                        contentPadding: EdgeInsets.all(14),
                        hint: "Поиск сотрудников",
                        fieldController: searchController,
                        suffix: Row(
                          children: [
                            IconButton(
                                icon: Icon(Icons.close), onPressed: () {}),
                          ],
                        ),
                      ),
                    ),
                  ),
                  AppSpace.horizontal12,
                  GestureDetector(
                    onTap: () {
                      router
                          .push(AddManagerRoute(organizations: organizations))
                          .then((_) {
                        context.read<AddManagerCubit>().getManagers();
                      });
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
                          "Добавить",
                          maxLines: 2,
                          style:
                              TextStyle(fontSize: 13, color: context.onPrimary),
                        ),
                      ),
                    ),
                  )
                ],
              ),
            ),
          ),
          AppSpace.vertical12,
          Expanded(
            child: CustomBox(
              child: Column(
                children: [
                  TitleManager(),
                  BlocBuilder<AddManagerCubit, AddManagerState>(
                      builder: (context, state) {
                    if (state.status == StateStatus.loading &&
                        state.managers == null) {
                      return const Center(child: CircularProgressIndicator());
                    }

                    if (state.managers?.isEmpty ?? true) {
                      return Center(child: Text(context.tr("not_found")));
                    }

                    return Expanded(
                      child: ListView.separated(
                        shrinkWrap: true,
                        padding: const EdgeInsets.all(8.0),
                        itemBuilder: (context, index) {
                          ManagerDto manager = state.managers![index];

                          return Material(
                            child: TableProductItem(
                              columnWidths: const {
                                0: FlexColumnWidth(6),
                                1: FlexColumnWidth(4),
                                2: FlexColumnWidth(4),
                                3: FlexColumnWidth(2),
                              },
                              onTap: () async {},
                              children: [
                                SizedBox(
                                  height: 60,
                                  child: Padding(
                                    padding:
                                        const EdgeInsets.fromLTRB(8, 5, 5, 5),
                                    child: Text(manager.name ?? ""),
                                  ),
                                ),
                                SizedBox(
                                  height: 60,
                                  child: Padding(
                                      padding: const EdgeInsets.fromLTRB(
                                          10, 5, 0, 0),
                                      child: Text(manager.phoneNumber ?? "")),
                                ),
                                SizedBox(
                                  height: 60,
                                  child: Center(
                                    child: Padding(
                                      padding: const EdgeInsets.only(top: 5),
                                      child: Text(manager.position ?? ""),
                                    ),
                                  ),
                                ),
                                SizedBox(
                                  height: 60,
                                  child: Padding(
                                    padding: const EdgeInsets.all(8),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        GestureDetector(
                                          onTap: () => router
                                              .push(AddManagerRoute(
                                                  organizations: organizations,
                                                  managerDto: manager))
                                              .then((_) {
                                            context
                                                .read<AddManagerCubit>()
                                                .getManagers();
                                          }),
                                          child: Container(
                                            decoration: BoxDecoration(
                                              color: AppColors.primary500,
                                              borderRadius:
                                                  BorderRadius.circular(10),
                                              boxShadow: [
                                                BoxShadow(
                                                    color: AppColors.stroke,
                                                    blurRadius: 3)
                                              ],
                                            ),
                                            height: 40,
                                            width: 40,
                                            child: Icon(
                                              Icons.edit,
                                              color: Colors.white,
                                            ),
                                          ),
                                        ),
                                        AppSpace.horizontal12,
                                        GestureDetector(
                                          onTap: () async {
                                            final confirm =
                                                await showDialog<bool>(
                                              context: context,
                                              builder: (context) => AlertDialog(
                                                title: Text("Подтверждение"),
                                                content: Text(
                                                    "Вы действительно хотите удалить сотрудника ${manager.name}?"),
                                                actions: [
                                                  TextButton(
                                                    onPressed: () =>
                                                        Navigator.of(context)
                                                            .pop(false),
                                                    child: Text("Отмена"),
                                                  ),
                                                  TextButton(
                                                    onPressed: () =>
                                                        Navigator.of(context)
                                                            .pop(true),
                                                    child: Text("Удалить",
                                                        style: TextStyle(
                                                            color: Colors.red)),
                                                  ),
                                                ],
                                              ),
                                            );

                                            if (confirm == true) {
                                              context
                                                  .read<AddManagerCubit>()
                                                  .deleteManager(manager.cid);
                                            }
                                          },
                                          child: Container(
                                            decoration: BoxDecoration(
                                              color: AppColors.error500,
                                              borderRadius:
                                                  BorderRadius.circular(10),
                                              boxShadow: [
                                                BoxShadow(
                                                    color: AppColors.stroke,
                                                    blurRadius: 3)
                                              ],
                                            ),
                                            height: 40,
                                            width: 40,
                                            child: Icon(
                                              Icons.delete,
                                              color: Colors.white,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          );
                        },
                        separatorBuilder: (context, index) =>
                            AppSpace.vertical12,
                        itemCount: state.managers?.length ?? 0,
                      ),
                    );
                  })
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
