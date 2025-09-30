import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hoomo_pos/core/styles/colors.dart';
import 'package:hoomo_pos/core/widgets/product_table_item.dart';
import 'package:hoomo_pos/core/widgets/text_field.dart';
import '../../../../../../../../../data/dtos/write_offs/write_off_product_request.dart';
import '../cubit/add_write_off_cubit.dart';

class WriteOffProductList extends HookWidget {
  const WriteOffProductList({
    super.key,
    required this.product,
    this.editable = true,
  });

  final WriteOffProductRequest? product;
  final bool editable;

  @override
  Widget build(
    BuildContext context,
  ) {
    if (product == null) return const SizedBox();
    final cubit = context.read<AddWriteOffCubit>();
    return Padding(
      padding: const EdgeInsets.all(5.0),
      child: TableProductItem(
        columnWidths: const {
          0: FlexColumnWidth(5),
          1: FlexColumnWidth(2),
          2: FlexColumnWidth(3),
          3: FlexColumnWidth(),
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
                        onChange: (p0) => cubit.updateQuantity(product?.productId ?? 0, quantity: int.tryParse(p0)),
                      )
                    : Text(product?.quantity.toString() ?? '0')),
          ),
          SizedBox(
            height: 60,
            width: 80,
            child: Padding(
                padding: const EdgeInsets.all(8),
                child: editable
                    ? AppTextField(
                        hint: 'Камментарии',
                        onChange: (p0) => cubit.updateComment(product?.productId ?? 0, comment: p0),
                      )
                    : Text(product?.comment ?? '')),
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
                      boxShadow: [const BoxShadow(color: AppColors.stroke, blurRadius: 3)],
                    ),
                    height: 40,
                    width: 40,
                    child: const Icon(
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
