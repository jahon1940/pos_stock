import 'package:flutter/material.dart';
import 'package:hoomo_pos/core/constants/app_utils.dart';
import 'package:hoomo_pos/core/extensions/color_extension.dart';
import 'package:hoomo_pos/core/extensions/context.dart';
import 'package:hoomo_pos/core/widgets/custom_square_icon_btn.dart';
import 'package:hoomo_pos/data/dtos/brand/brand_dto.dart';
import 'package:hoomo_pos/data/dtos/category/category_dto.dart';
import 'package:hoomo_pos/data/dtos/country/country_dto.dart';

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
  List<dynamic> filteredItems = [];

  @override
  void initState() {
    filteredItems = [...items];
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
                        onChange: (value) {
                          if (value.isEmpty) {
                            filteredItems = [...items];
                          } else {
                            filteredItems.removeWhere((e) {
                              if (filteredItems.firstOrNull is CategoryDto) {
                                return !(e as CategoryDto).name.toLowerCase().startsWith(value.toLowerCase());
                              } else if (filteredItems.firstOrNull is BrandDto) {
                                return !(e as BrandDto).name.toLowerCase().startsWith(value.toLowerCase());
                              } else if (filteredItems.firstOrNull is CountryDto) {
                                return !((e as CountryDto).name ?? '').toLowerCase().startsWith(value.toLowerCase());
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
                    String name = '';
                    String imageLink = '';
                    if (item is CategoryDto) {
                      name = item.name;
                      imageLink = item.image.isNotEmpty ? item.imageLink : '';
                    }
                    if (item is BrandDto) {
                      name = item.name;
                      imageLink = item.image.isNotEmpty ? item.imageLink : '';
                    }
                    if (item is CountryDto) name = item.name ?? '';
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
                                      child: imageLink.isNotEmpty
                                          ? Image.network(
                                              imageLink,
                                              fit: BoxFit.cover,
                                            )
                                          : null,
                                    ),
                                  ),
                                ),
                                AppUtils.kGap12,
                                Text(name),
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
      );
}
