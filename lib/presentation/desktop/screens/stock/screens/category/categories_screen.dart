import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hoomo_pos/core/constants/dictionary.dart';
import 'package:hoomo_pos/core/extensions/context.dart';
import 'package:hoomo_pos/core/extensions/null_extension.dart';

import '../../../../../../../../core/constants/app_utils.dart';
import '../../../../../../../../core/styles/colors.dart';
import '../../../../../../../../core/widgets/custom_box.dart';
import '../../../../dialogs/category/bloc/category_bloc.dart';
import '../../../../dialogs/operation_result_dialog.dart';
import '../../widgets/table_title_widget.dart';
import 'widgets/category_item_widget.dart';
import 'widgets/create_category_dialog.dart';

class CategoriesScreen extends HookWidget {
  const CategoriesScreen({
    super.key,
  });

  @override
  Widget build(
    BuildContext context,
  ) {
    useEffect(() {
      context.categoryBloc.add(const GetCategoryEvent());
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
                  // const BackButtonWidget(),
                  const Spacer(),

                  ///
                  GestureDetector(
                    onTap: () => showDialog<bool?>(
                      context: context,
                      builder: (context) => const Center(child: CreateCategoryDialog()),
                    ).then((isSuccess) async {
                      if (isSuccess.isNotNull) {
                        await Future.delayed(Durations.medium1);
                        await showDialog(
                          context: context,
                          builder: (context) => OperationResultDialog(
                            label: isSuccess! ? 'Котегория создан' : null,
                            isError: !isSuccess,
                          ),
                        );
                      }
                    }),
                    child: Container(
                      height: 48,
                      width: context.width * .1,
                      decoration: const BoxDecoration(
                        borderRadius: AppUtils.kBorderRadius12,
                        color: AppColors.primary800,
                      ),
                      child: Center(
                        child: Text(
                          'Добавить',
                          style: TextStyle(fontSize: 13, color: context.onPrimary),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),

            /// body
            AppUtils.kMainObjectsGap,
            Expanded(
              child: CustomBox(
                child: Column(
                  children: [
                    ///
                    TableTitleWidget(
                      titles: ['ID', context.tr(Dictionary.name), 'Фото', 'Действия'],
                      columnWidths: {
                        0: const FlexColumnWidth(2),
                        1: const FlexColumnWidth(5),
                        2: const FlexColumnWidth(),
                        3: const FlexColumnWidth(2),
                      },
                    ),

                    ///
                    AppUtils.kGap12,
                    BlocBuilder<CategoryBloc, CategoryState>(
                      builder: (context, state) => Expanded(
                        child: state.status.isLoading && state.categories == null
                            ? const Center(child: CupertinoActivityIndicator())
                            : (state.categories?.results ?? []).isEmpty
                                ? Center(child: Text(context.tr(Dictionary.not_found)))
                                : Material(
                                    child: ListView.separated(
                                      shrinkWrap: true,
                                      padding: AppUtils.kPaddingB12,
                                      itemCount: state.categories?.results.length ?? 0,
                                      separatorBuilder: (_, __) => AppUtils.kGap12,
                                      itemBuilder: (context, index) => CategoryItemWidget(
                                        category: state.categories!.results[index],
                                      ),
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
