import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hoomo_pos/core/constants/app_utils.dart';
import 'package:hoomo_pos/core/extensions/color_extension.dart';
import 'package:hoomo_pos/core/extensions/context.dart';
import 'package:hoomo_pos/core/extensions/null_extension.dart';
import 'package:hoomo_pos/core/widgets/custom_square_icon_btn.dart';
import 'package:hoomo_pos/data/dtos/brand/brand_dto.dart';
import 'package:hoomo_pos/presentation/desktop/screens/stock/screens/brands/cubit/brand_cubit.dart';
import 'package:hoomo_pos/presentation/desktop/screens/stock/screens/brands/widgets/create_brand_dialog.dart';

import '../../../../../../../core/styles/colors.dart';
import '../../../../../../../core/widgets/text_field.dart';
import '../../../../../dialogs/operation_result_dialog.dart';

class SelectBrandDialog extends StatefulWidget {
  const SelectBrandDialog({
    super.key,
  });

  @override
  State<SelectBrandDialog> createState() => _SelectBrandDialogState();
}

class _SelectBrandDialogState extends State<SelectBrandDialog> {
  List<BrandDto> filteredItems = [];

  @override
  void initState() {
    filteredItems = List.from(context.brandBloc.state.brands?.results ?? []);
    super.initState();
  }

  @override
  Widget build(
    BuildContext context,
  ) =>
      BlocBuilder<BrandCubit, BrandState>(
        builder: (context, state) => AlertDialog(
          shape: const RoundedRectangleBorder(borderRadius: AppUtils.kBorderRadius12),
          contentPadding: AppUtils.kPaddingAll24,
          content: SizedBox(
            width: context.width * .4,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                /// header
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Expanded(
                      child: DecoratedBox(
                        decoration: BoxDecoration(
                          color: AppColors.primary100.opcty(.3),
                          borderRadius: AppUtils.kBorderRadius12,
                        ),
                        child: AppTextField(
                          radius: 12,
                          contentPadding: const EdgeInsets.all(14),
                          hint: 'Поиск',
                          onChange: (value) {
                            if (value.isEmpty) {
                              filteredItems = List.from(state.brands?.results ?? []);
                            } else {
                              filteredItems.removeWhere((e) => !(e.name.toLowerCase().startsWith(value.toLowerCase())));
                            }
                            setState(() {});
                          },
                        ),
                      ),
                    ),

                    /// add category
                    AppUtils.kGap12,
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        fixedSize: Size(context.width * .1, 48),
                        padding: EdgeInsets.zero,
                      ),
                      onPressed: () => showDialog<bool?>(
                        context: context,
                        builder: (context) => const Center(child: CreateBrandDialog()),
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
                      child: const Text(
                        'Добавить',
                        style: TextStyle(fontSize: 11),
                      ),
                    ),

                    /// close button
                    AppUtils.kGap12,
                    CustomSquareIconBtn(
                      Icons.close,
                      size: 48,
                      darkenColors: true,
                      backgrounColor: AppColors.error100,
                      iconColor: AppColors.error600,
                      onTap: () => context.pop(),
                    ),
                  ],
                ),

                /// content
                AppUtils.kGap24,
                Expanded(
                  child: ListView.separated(
                    itemCount: filteredItems.length,
                    separatorBuilder: (_, __) => AppUtils.kGap8,
                    itemBuilder: (ctx, index) {
                      final item = filteredItems.elementAt(index);
                      return SizedBox(
                        height: 50,
                        child: Material(
                          shape: RoundedRectangleBorder(
                            borderRadius: AppUtils.kBorderRadius8,
                            side: BorderSide(color: context.theme.dividerColor, width: 2),
                          ),
                          child: InkWell(
                            borderRadius: AppUtils.kBorderRadius8,
                            onTap: () => context.pop(item),
                            child: Padding(
                              padding: AppUtils.kPaddingAll12,
                              child: Row(
                                children: [
                                  Center(
                                    child: ClipRRect(
                                      borderRadius: AppUtils.kBorderRadius8,
                                      child: SizedBox(
                                        height: 40,
                                        width: 40,
                                        child: item.image.isNotEmpty
                                            ? Image.network(item.imageLink, fit: BoxFit.cover)
                                            : null,
                                      ),
                                    ),
                                  ),
                                  AppUtils.kGap12,
                                  Text(item.name),
                                ],
                              ),
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
      );
}
