import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hoomo_pos/core/enums/states.dart';
import 'package:hoomo_pos/core/extensions/color_extension.dart';
import 'package:hoomo_pos/core/extensions/context.dart';
import 'package:hoomo_pos/core/widgets/product_table_item.dart';
import 'package:hoomo_pos/data/dtos/suppliers/supplier_dto.dart';
import 'package:hoomo_pos/presentation/desktop/screens/stock/screens/add_contractor/cubit/add_contractor_cubit.dart';

import '../../../../../../../app/router.dart';
import '../../../../../../../app/router.gr.dart';
import '../../../../../../../core/constants/spaces.dart';
import '../../../../../../../core/styles/colors.dart';
import '../../../../../../../core/styles/text_style.dart';
import '../../../../../../../core/widgets/custom_box.dart';
import '../../../../../../../core/widgets/text_field.dart';
import '../../../../../../../data/dtos/company_dto.dart';
import '../../../widgets/title_person.dart';

class ContractorScreen extends HookWidget {
  const ContractorScreen(
    this.organizations, {
    super.key,
  });

  final CompanyDto organizations;

  @override
  Widget build(
    BuildContext context,
  ) {
    useEffect(() {
      context.read<AddContractorCubit>().getSuppliers();
      return null;
    }, const []);

    final searchController = useTextEditingController();
    return Padding(
      padding: const EdgeInsets.all(4),
      child: Column(
        children: [
          Container(
            decoration: BoxDecoration(
              color: context.theme.cardColor,
              borderRadius: BorderRadius.circular(10),
              boxShadow: [BoxShadow(color: AppColors.stroke, blurRadius: 3)],
            ),
            height: 60,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                children: [
                  Expanded(
                    child: DecoratedBox(
                      decoration: BoxDecoration(
                        color: AppColors.primary100.opcty(.3),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: AppTextField(
                        height: 50,
                        hintStyle: AppTextStyles.mType16.copyWith(color: AppColors.primary500),
                        contentPadding: EdgeInsets.all(14),
                        hint: "Поиск поставщиков",
                        fieldController: searchController,
                        suffix: Row(
                          children: [
                            IconButton(icon: Icon(Icons.close), onPressed: () {}),
                          ],
                        ),
                      ),
                    ),
                  ),
                  AppSpace.horizontal12,
                  GestureDetector(
                    onTap: () => router.push(AddContractorRoute(organizations: organizations)).then((_) {
                      context.read<AddContractorCubit>().getSuppliers();
                    }),
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
                  TitlePerson(),
                  BlocBuilder<AddContractorCubit, AddContractorState>(
                    builder: (context, state) {
                      if (state.status == StateStatus.loading && state.suppliers == null) {
                        return const Center(child: CircularProgressIndicator());
                      }
                      if (state.suppliers?.isEmpty ?? true) {
                        return Center(child: Text(context.tr("not_found")));
                      }
                      return Expanded(
                        child: ListView.separated(
                          shrinkWrap: true,
                          padding: const EdgeInsets.all(8.0),
                          itemCount: state.suppliers?.length ?? 0,
                          separatorBuilder: (context, index) => AppSpace.vertical12,
                          itemBuilder: (context, index) {
                            SupplierDto supplier = state.suppliers![index];
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
                                      padding: const EdgeInsets.fromLTRB(8, 5, 5, 5),
                                      child: Text(supplier.name ?? ""),
                                    ),
                                  ),
                                  SizedBox(
                                    height: 60,
                                    child: Padding(
                                        padding: const EdgeInsets.fromLTRB(10, 5, 0, 0),
                                        child: Text(supplier.phoneNumber ?? "")),
                                  ),
                                  SizedBox(
                                    height: 60,
                                    child: Center(
                                      child: Padding(
                                        padding: const EdgeInsets.only(top: 5),
                                        child: Text(supplier.inn ?? ""),
                                      ),
                                    ),
                                  ),
                                  SizedBox(
                                    height: 60,
                                    child: Padding(
                                      padding: const EdgeInsets.all(8),
                                      child: Row(
                                        mainAxisAlignment: MainAxisAlignment.center,
                                        children: [
                                          GestureDetector(
                                            onTap: () => router
                                                .push(AddContractorRoute(
                                                    supplierDto: supplier, organizations: organizations))
                                                .then((_) {
                                              context.read<AddContractorCubit>().getSuppliers();
                                            }),
                                            child: Container(
                                              decoration: BoxDecoration(
                                                color: AppColors.primary500,
                                                borderRadius: BorderRadius.circular(10),
                                                boxShadow: [BoxShadow(color: AppColors.stroke, blurRadius: 3)],
                                              ),
                                              height: 40,
                                              width: 40,
                                              child: Icon(
                                                Icons.edit,
                                                color: Colors.white,
                                              ),
                                            ),
                                          ),
                                          AppSpace.horizontal6,
                                          GestureDetector(
                                            onTap: () async {
                                              final confirm = await showDialog<bool>(
                                                context: context,
                                                builder: (context) => AlertDialog(
                                                  title: Text("Подтверждение"),
                                                  content: Text(
                                                      "Вы действительно хотите удалить поставщика ${supplier.name}?"),
                                                  actions: [
                                                    TextButton(
                                                      onPressed: () => Navigator.of(context).pop(false),
                                                      child: Text("Отмена"),
                                                    ),
                                                    TextButton(
                                                      onPressed: () => Navigator.of(context).pop(true),
                                                      child: Text("Удалить", style: TextStyle(color: Colors.red)),
                                                    ),
                                                  ],
                                                ),
                                              );

                                              if (confirm == true) {
                                                context.read<AddContractorCubit>().deleteSupplier(supplier.id);
                                              }
                                            },
                                            child: Container(
                                              decoration: BoxDecoration(
                                                color: AppColors.error500,
                                                borderRadius: BorderRadius.circular(10),
                                                boxShadow: [BoxShadow(color: AppColors.stroke, blurRadius: 3)],
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
                        ),
                      );
                    },
                  )
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
