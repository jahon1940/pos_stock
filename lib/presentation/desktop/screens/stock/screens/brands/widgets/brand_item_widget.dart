import 'package:flutter/material.dart';
import 'package:hoomo_pos/core/extensions/context.dart';

import '../../../../../../../core/styles/colors.dart';
import '../../../../../../../core/widgets/product_table_item.dart';
import '../../../../../../../data/dtos/brand/brand_dto.dart';
import '../../../../../dialogs/category/bloc/category_bloc.dart';

class BrandItemWidget extends StatelessWidget {
  const BrandItemWidget({
    super.key,
    required Map<int, FlexColumnWidth> columnWidths,
    required this.brand,
  }) : _columnWidths = columnWidths;

  final Map<int, FlexColumnWidth> _columnWidths;
  final BrandDto brand;

  @override
  Widget build(
    BuildContext context,
  ) =>
      TableProductItem(
        columnWidths: _columnWidths,
        onTap: () async {},
        children: [
          SizedBox(
            height: 50,
            child: Padding(
              padding: const EdgeInsets.fromLTRB(8, 5, 5, 5),
              child: Text('${brand.id}'),
            ),
          ),
          SizedBox(
            child: Padding(padding: const EdgeInsets.fromLTRB(10, 5, 0, 0), child: Text(brand.name ?? '')),
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
                      boxShadow: [const BoxShadow(color: AppColors.stroke, blurRadius: 3)],
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
                  onTap: () => context.categoryBloc.add(DeleteCategoryId(brand.cid)),
                  child: Container(
                    decoration: BoxDecoration(
                      color: AppColors.error500,
                      borderRadius: BorderRadius.circular(10),
                      boxShadow: [const BoxShadow(color: AppColors.stroke, blurRadius: 3)],
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
}
