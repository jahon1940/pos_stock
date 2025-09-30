import 'package:auto_route/auto_route.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hoomo_pos/core/constants/dictionary.dart';
import 'package:hoomo_pos/core/extensions/context.dart';
import 'package:hoomo_pos/core/extensions/edge_insets_extensions.dart';
import 'package:hoomo_pos/presentation/desktop/screens/stock/widgets/back_button_widget.dart';

import '../../../../../../../../core/constants/app_utils.dart';
import '../../../../../../../../core/styles/colors.dart';
import '../../../../../../../../core/widgets/custom_box.dart';
import '../../../../../../../../core/widgets/product_table_item.dart';
import '../../../../../../../../core/widgets/product_table_title.dart';
import '../../../../../../../../data/dtos/category/category_dto.dart';
import '../../../../../../dialogs/category/bloc/category_bloc.dart';
import '../../../../../../dialogs/create_category/create_category_dialog.dart';

@RoutePage()
class CategoriesScreen extends HookWidget {
  const CategoriesScreen({
    super.key,
  });

  static const _columnWidths = {
    0: FlexColumnWidth(2),
    1: FlexColumnWidth(6),
    2: FlexColumnWidth(2),
  };

  @override
  Widget build(
    BuildContext context,
  ) {
    useEffect(() {
      context.categoryBloc.add(GetCategory());
      return null;
    }, const []);

    return Scaffold(
      body: Padding(
        padding: AppUtils.kPaddingAll10,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            /// header
            Container(
              height: 60,
              padding: AppUtils.kPaddingAll6,
              decoration: BoxDecoration(
                color: context.theme.cardColor,
                borderRadius: AppUtils.kBorderRadius12,
                boxShadow: [BoxShadow(color: context.theme.dividerColor, blurRadius: 3)],
              ),
              child: Row(
                children: [
                  ///
                  const BackButtonWidget(),

                  ///
                  const Spacer(),

                  ///
                  Container(
                    height: 48,
                    width: context.width * .15,
                    alignment: Alignment.center,
                    decoration: const BoxDecoration(
                      borderRadius: AppUtils.kBorderRadius12,
                      color: AppColors.primary800,
                    ),
                    child: TextButton(
                      onPressed: () => showDialog(
                        context: context,
                        builder: (context) => const Center(child: CreateCategoryDialog()),
                      ).then((onValue) {
                        if (onValue == true) {
                          showDialog(
                            context: context,
                            builder: (context) => AlertDialog(
                              title: const Text("Успешно"),
                              content: const Text("Котегория создан"),
                              actions: [
                                TextButton(
                                  onPressed: () {},
                                  child: const Text("ОК"),
                                ),
                              ],
                            ),
                          );
                        }
                      }),
                      child: Text(
                        "Создать Котегорию",
                        style: TextStyle(fontSize: 13, color: context.onPrimary),
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
                    ///
                    TableTitleProducts(
                      fillColor: AppColors.stroke,
                      titles: ["ID", context.tr(Dictionary.name), "Действия"],
                      columnWidths: _columnWidths,
                    ),

                    ///
                    BlocBuilder<CategoryBloc, CategoryState>(
                      builder: (context, state) => Expanded(
                        child: state.status.isLoading && state.categories == null
                            ? const Center(child: CupertinoActivityIndicator())
                            : (state.categories?.results ?? []).isEmpty
                                ? Center(child: Text(context.tr(Dictionary.not_found)))
                                : ListView.separated(
                                    shrinkWrap: true,
                                    padding: const EdgeInsets.all(8.0),
                                    itemCount: state.categories?.results.length ?? 0,
                                    separatorBuilder: (_, __) => AppUtils.kGap12,
                                    itemBuilder: (context, index) {
                                      CategoryDto category = state.categories!.results[index];
                                      return TableProductItem(
                                        columnWidths: _columnWidths,
                                        onTap: () async {},
                                        children: [
                                          SizedBox(
                                            height: 50,
                                            child: Padding(
                                              padding: const EdgeInsets.fromLTRB(8, 5, 5, 5),
                                              child: Text("${category.id}"),
                                            ),
                                          ),
                                          SizedBox(
                                            child: Padding(
                                                padding: const EdgeInsets.fromLTRB(10, 5, 0, 0),
                                                child: Text(category.name ?? "")),
                                          ),
                                          Container(
                                            height: 60,
                                            alignment: Alignment.center,
                                            child: Row(
                                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                              children: [
                                                GestureDetector(
                                                  child: Container(
                                                    decoration: BoxDecoration(
                                                      color: AppColors.primary500,
                                                      borderRadius: BorderRadius.circular(10),
                                                      boxShadow: [
                                                        const BoxShadow(color: AppColors.stroke, blurRadius: 3)
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
                                                GestureDetector(
                                                  onTap: () => context.categoryBloc.add(DeleteCategoryId(category.cid)),
                                                  child: Container(
                                                    decoration: BoxDecoration(
                                                      color: AppColors.error500,
                                                      borderRadius: BorderRadius.circular(10),
                                                      boxShadow: [
                                                        const BoxShadow(color: AppColors.stroke, blurRadius: 3)
                                                      ],
                                                    ),
                                                    height: 40,
                                                    width: 40,
                                                    child: const Icon(Icons.delete, color: Colors.white),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          )
                                        ],
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
