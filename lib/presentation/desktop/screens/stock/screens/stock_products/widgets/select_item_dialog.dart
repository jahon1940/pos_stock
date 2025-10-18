import 'package:flutter/material.dart';
import 'package:hoomo_pos/core/constants/app_utils.dart';
import 'package:hoomo_pos/core/extensions/color_extension.dart';
import 'package:hoomo_pos/core/extensions/context.dart';
import 'package:hoomo_pos/core/widgets/custom_square_icon_btn.dart';
import 'package:hoomo_pos/data/dtos/category/category_dto.dart';

import '../../../../../../../core/styles/colors.dart';
import '../../../../../../../core/widgets/text_field.dart';

class SelectItemDialog extends StatefulWidget {
  const SelectItemDialog(
    this.items, {
    super.key,
  });

  final List<dynamic> items;

  @override
  State<SelectItemDialog> createState() => _SelectItemDialogState();
}

class _SelectItemDialogState extends State<SelectItemDialog> {
  List<dynamic> get items => widget.items;
  final List<dynamic> filteredItems = [];

  @override
  void initState() {
    filteredItems.addAll(widget.items);
    super.initState();
  }

  @override
  Widget build(
    BuildContext context,
  ) =>
      AlertDialog(
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
                  // const Text(
                  //   'Создания бренд',
                  //   style: AppTextStyles.boldType18,
                  // ),
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
                        // fieldController: searchController,
                        onChange: (value) {
                          if (value.isEmpty) {
                            filteredItems.addAll(items);
                          } else {
                            filteredItems.removeWhere((e) {
                              if (filteredItems.firstOrNull is CategoryDto) {
                                return !(e as CategoryDto).name.toLowerCase().startsWith(value.toLowerCase());
                              }
                              return false;
                            });
                          }
                          setState(() {});
                        },
                      ),
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
                    if (item is CategoryDto) {
                      return Container(
                        padding: AppUtils.kPaddingAll12,
                        decoration: BoxDecoration(
                          borderRadius: AppUtils.kBorderRadius12,
                          border: Border.all(color: context.theme.dividerColor, width: 2),
                        ),
                        child: Text(item.name),
                      );
                    }
                    return const SizedBox();
                  },
                ),
              ),
            ],
          ),
        ),
      );
}
