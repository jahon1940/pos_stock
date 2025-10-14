import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hoomo_pos/core/constants/dictionary.dart';
import 'package:hoomo_pos/core/extensions/context.dart';
import 'package:hoomo_pos/core/extensions/edge_insets_extensions.dart';

import '../../../../../../../../core/constants/app_utils.dart';
import '../../../../../../../../core/styles/colors.dart';
import '../../../../../../../../core/widgets/custom_box.dart';
import '../../../../dialogs/category/bloc/category_bloc.dart';
import '../../widgets/table_title_widget.dart';
import 'widgets/brand_item_widget.dart';
import 'widgets/create_brand_dialog.dart';

class BrandsScreen extends HookWidget {
  const BrandsScreen({
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
      /// todo
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
                  // const BackButtonWidget(),
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
                        builder: (_) => const Center(child: CreateBrandDialog()),
                      ).then((onValue) {
                        if (onValue == true) {
                          showDialog(
                            context: context,
                            builder: (context) => AlertDialog(
                              title: const Text('Успешно'),
                              content: const Text('Бренд создан'),
                              actions: [
                                TextButton(
                                  onPressed: () {},
                                  child: const Text('ОК'),
                                ),
                              ],
                            ),
                          );
                        }
                      }),
                      child: Text(
                        'Создать Бренд',
                        style: TextStyle(fontSize: 13, color: context.onPrimary),
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
                padding: AppUtils.kPaddingAll12.withB0,
                child: Column(
                  children: [
                    ///
                    TableTitleWidget(
                      titles: ['ID', context.tr(Dictionary.name), 'Действия'],
                      columnWidths: _columnWidths,
                    ),

                    ///
                    AppUtils.kGap12,
                    BlocBuilder<CategoryBloc, CategoryState>(
                      // todo
                      builder: (context, state) => Expanded(
                        child: state.status.isLoading && state.categories == null
                            ? const Center(child: CupertinoActivityIndicator())
                            : (state.categories?.results ?? []).isEmpty
                                ? Center(child: Text(context.tr(Dictionary.not_found)))
                                : ListView.separated(
                                    shrinkWrap: true,
                                    padding: AppUtils.kPaddingB12,
                                    itemCount: state.categories?.results.length ?? 0,
                                    separatorBuilder: (_, __) => AppUtils.kGap12,
                                    itemBuilder: (context, index) => BrandItemWidget(
                                      columnWidths: _columnWidths,
                                      brand: state.categories!.results[index],
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
