import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hoomo_pos/core/extensions/context.dart';
import 'package:hoomo_pos/core/extensions/edge_insets_extensions.dart';
import 'package:hoomo_pos/presentation/desktop/dialogs/operation_result_dialog.dart';
import 'package:hoomo_pos/presentation/desktop/screens/stock/screens/stock_products/cubit/product_cubit.dart';

import '../../../../../../../core/constants/app_utils.dart';
import '../../../../../../../core/styles/colors.dart';
import '../../../../../../../core/widgets/custom_box.dart';
import '../../../../../../../data/dtos/product_dto.dart';

class CreateProductNavbar extends StatelessWidget {
  const CreateProductNavbar({
    super.key,
    required this.product,
  });

  final ProductDto? product;

  @override
  Widget build(
    BuildContext context,
  ) =>
      Padding(
        padding: AppUtils.kPaddingAll10.withT0,
        child: CustomBox(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              BlocConsumer<ProductCubit, ProductState>(
                listenWhen: (p, c) =>
                    p.createProductStatus != c.createProductStatus &&
                    (c.createProductStatus.isError || c.createProductStatus.isSuccess),
                listener: (context, state) async {
                  await showDialog(
                    context: context,
                    builder: (context) => OperationResultDialog(
                      isError: state.createProductStatus.isError,
                    ),
                  );
                  if (state.createProductStatus.isSuccess) {
                    await Future.delayed(Durations.medium1);
                    context.pop();
                  }
                },
                builder: (context, state) => SizedBox(
                  height: 50,
                  width: context.width * .1,
                  child: Material(
                    borderRadius: AppUtils.kBorderRadius8,
                    color: AppColors.primary500,
                    child: InkWell(
                      onTap: () {
                        if (product == null) {
                          context.productBloc.createProduct();
                        } else {
                          context.productBloc.updateProduct(productId: product!.id);
                        }
                      },
                      hoverColor: AppColors.primary400,
                      highlightColor: AppColors.primary300,
                      splashColor: AppColors.primary300,
                      borderRadius: AppUtils.kBorderRadius8,
                      child: Center(
                        child: Text(
                          'Сохранить',
                          style: TextStyle(fontSize: 13, color: context.onPrimary),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      );
}
