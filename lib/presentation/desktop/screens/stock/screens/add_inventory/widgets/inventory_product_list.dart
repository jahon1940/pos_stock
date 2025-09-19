import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hoomo_pos/core/styles/colors.dart';
import 'package:hoomo_pos/core/widgets/product_table_item.dart';
import 'package:hoomo_pos/core/widgets/text_field.dart';
import '../../../../../../../data/dtos/inventories/inventory_product_request.dart';
import '../cubit/add_inventory_cubit.dart';

class AddInventoryProductList extends HookWidget {
  const AddInventoryProductList({
    super.key,
    required this.product,
    this.editable = true,
  });

  final InventoryProductRequest? product;
  final bool editable;

  @override
  Widget build(BuildContext context) {
    if (product == null) return SizedBox();

    final cubit = context.read<AddInventoryCubit>();

    return Padding(
      padding: const EdgeInsets.all(5.0),
      child: TableProductItem(
        columnWidths: {
          0: FlexColumnWidth(5),
          1: FlexColumnWidth(2),
          if (!editable) 2: FlexColumnWidth(3),
          if (!editable) 3: FlexColumnWidth(2),
          if (editable) 4: FlexColumnWidth(2),
        },
        onTap: () {},
        children: [
          SizedBox(
            height: 60,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                product!.title ?? '',
              ),
            ),
          ),
          SizedBox(
            height: 60,
            width: 80,
            child: Padding(
                padding: const EdgeInsets.all(8),
                child: editable
                    ? AppTextField(
                        hint: 'Количество',
                        onChange: (p0) => cubit.updateQuantity(
                            product?.productId ?? 0, int.tryParse(p0)),
                      )
                    : Center(
                        child: Text(product?.oldQuantity.toString() ?? '0'))),
          ),
          if (!editable)
            SizedBox(
              height: 60,
              width: 80,
              child: Padding(
                  padding: const EdgeInsets.all(8),
                  child: Center(
                      child: Text(product?.realQuantity.toString() ?? '0'))),
            ),
          if (!editable)
            SizedBox(
              height: 60,
              width: 80,
              child: Padding(
                  padding: const EdgeInsets.all(8),
                  child: Center(
                      child: Text(product?.quantityDiff.toString() ?? '0'))),
            ),
          if (editable)
            SizedBox(
              width: 50,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: GestureDetector(
                  onTap: () => cubit.deleteProduct(product!.productId),
                  child: Container(
                    decoration: BoxDecoration(
                      color: AppColors.error500,
                      borderRadius: BorderRadius.circular(10),
                      boxShadow: [
                        BoxShadow(color: AppColors.stroke, blurRadius: 3)
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
              ),
            )
        ],
      ),
    );
  }
}
