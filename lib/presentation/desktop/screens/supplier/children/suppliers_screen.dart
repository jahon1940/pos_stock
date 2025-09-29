import 'package:auto_route/auto_route.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hoomo_pos/core/extensions/color_extension.dart';
import 'package:hoomo_pos/core/extensions/context.dart';
import '../../../../../../../../app/router.dart';
import '../../../../../../../../app/router.gr.dart';
import '../../../../../../../../core/constants/app_utils.dart';
import '../../../../../../../../core/styles/colors.dart';
import '../../../../../../../../core/styles/text_style.dart';
import '../../../../../../../../core/widgets/custom_box.dart';
import '../../../../../../../../core/widgets/text_field.dart';
import '../../../../../../../core/widgets/product_table_item.dart';
import '../../../../../../../data/dtos/suppliers/supplier_dto.dart';
import '../../stock/widgets/back_button_widget.dart';
import '../../stock/widgets/title_person.dart';
import 'cubit/supplier_cubit.dart';

@RoutePage()
class SuppliersScreen extends HookWidget {
  const SuppliersScreen({
    super.key,
  });

  @override
  Widget build(
    BuildContext context,
  ) {
    useEffect(() {
      context.supplierBloc.getSuppliers();
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
                boxShadow: [
                  const BoxShadow(color: AppColors.stroke, blurRadius: 3)
                ],
              ),
              child: Row(
                children: [
                  // /// back button
                  // const BackButtonWidget(),

                  /// search field
                  AppUtils.kGap6,
                  Expanded(
                    child: DecoratedBox(
                      decoration: BoxDecoration(
                        color: AppColors.primary100.opcty(.3),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: AppTextField(
                        hintStyle: AppTextStyles.mType16
                            .copyWith(color: AppColors.primary500),
                        contentPadding: const EdgeInsets.all(14),
                        hint: "Поиск поставщиков",
                        fieldController: searchController,
                        suffix: IconButton(
                            icon: const Icon(Icons.close), onPressed: () {}),
                      ),
                    ),
                  ),

                  /// add button
                  AppUtils.kGap12,
                  GestureDetector(
                    onTap: () => router
                        .push(AddSupplierRoute())
                        .then((_) => context.supplierBloc.getSuppliers()),
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

            /// body
            AppUtils.kGap12,
            Expanded(
              child: CustomBox(
                child: Column(
                  children: [
                    const TitlePerson(),
                    BlocBuilder<SupplierCubit, SupplierState>(
                      builder: (context, state) => Expanded(
                        child: state.status.isLoading && state.suppliers == null
                            ? const Center(child: CircularProgressIndicator())
                            : state.suppliers?.isEmpty ?? true
                                ? Center(child: Text(context.tr("not_found")))
                                : ListView.separated(
                                    shrinkWrap: true,
                                    padding: const EdgeInsets.all(8.0),
                                    itemCount: state.suppliers?.length ?? 0,
                                    separatorBuilder: (context, index) =>
                                        AppUtils.kGap12,
                                    itemBuilder: (context, index) {
                                      SupplierDto supplier =
                                          state.suppliers![index];
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
                                                    const EdgeInsets.fromLTRB(
                                                        8, 5, 5, 5),
                                                child:
                                                    Text(supplier.name ?? ""),
                                              ),
                                            ),
                                            SizedBox(
                                              height: 60,
                                              child: Padding(
                                                  padding:
                                                      const EdgeInsets.fromLTRB(
                                                          10, 5, 0, 0),
                                                  child: Text(
                                                      supplier.phoneNumber ??
                                                          "")),
                                            ),
                                            SizedBox(
                                              height: 60,
                                              child: Center(
                                                child: Padding(
                                                  padding:
                                                      const EdgeInsets.only(
                                                          top: 5),
                                                  child:
                                                      Text(supplier.inn ?? ""),
                                                ),
                                              ),
                                            ),
                                            SizedBox(
                                              height: 60,
                                              child: Padding(
                                                padding:
                                                    const EdgeInsets.all(8),
                                                child: Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.center,
                                                  children: [
                                                    GestureDetector(
                                                      onTap: () => router
                                                          .push(
                                                              AddSupplierRoute(
                                                            supplierDto:
                                                                supplier,
                                                          ))
                                                          .then((_) => context
                                                              .supplierBloc
                                                              .getSuppliers()),
                                                      child: Container(
                                                        decoration:
                                                            BoxDecoration(
                                                          color: AppColors
                                                              .primary500,
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(10),
                                                          boxShadow: [
                                                            const BoxShadow(
                                                                color: AppColors
                                                                    .stroke,
                                                                blurRadius: 3)
                                                          ],
                                                        ),
                                                        height: 40,
                                                        width: 40,
                                                        child: const Icon(
                                                          Icons.edit,
                                                          color: Colors.white,
                                                        ),
                                                      ),
                                                    ),
                                                    AppUtils.kGap16,
                                                    GestureDetector(
                                                      onTap: () async {
                                                        final confirm =
                                                            await showDialog<
                                                                bool>(
                                                          context: context,
                                                          builder: (context) =>
                                                              AlertDialog(
                                                            title: const Text(
                                                                "Подтверждение"),
                                                            content: Text(
                                                              "Вы действительно хотите удалить поставщика ${supplier.name}?",
                                                            ),
                                                            actions: [
                                                              TextButton(
                                                                onPressed: () =>
                                                                    Navigator.of(
                                                                            context)
                                                                        .pop(
                                                                            false),
                                                                child: const Text(
                                                                    "Отмена"),
                                                              ),
                                                              TextButton(
                                                                onPressed: () =>
                                                                    Navigator.of(
                                                                            context)
                                                                        .pop(
                                                                            true),
                                                                child:
                                                                    const Text(
                                                                  "Удалить",
                                                                  style: TextStyle(
                                                                      color: Colors
                                                                          .red),
                                                                ),
                                                              ),
                                                            ],
                                                          ),
                                                        );

                                                        if (confirm == true) {
                                                          context.supplierBloc
                                                              .deleteSupplier(
                                                                  supplier.id);
                                                        }
                                                      },
                                                      child: Container(
                                                        decoration:
                                                            BoxDecoration(
                                                          color: AppColors
                                                              .error500,
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(10),
                                                          boxShadow: [
                                                            const BoxShadow(
                                                                color: AppColors
                                                                    .stroke,
                                                                blurRadius: 3),
                                                          ],
                                                        ),
                                                        height: 40,
                                                        width: 40,
                                                        child: const Icon(
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
