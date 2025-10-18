import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hoomo_pos/core/extensions/context.dart';
import 'package:hoomo_pos/core/extensions/edge_insets_extensions.dart';
import 'package:hoomo_pos/presentation/desktop/dialogs/operation_result_dialog.dart';
import 'package:hoomo_pos/presentation/desktop/screens/stock/screens/stock_products/cubit/product_cubit.dart';

import '../../../../../../../core/constants/app_utils.dart';
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
                builder: (context, state) => InkWell(
                  onTap: () {
                    if (product == null) {
                      context.productBloc.createProduct();
                    } else {
                      context.productBloc.updateProduct(productId: product!.id);
                    }
                  },
                  child: Container(
                    padding: const EdgeInsets.all(5),
                    decoration: BoxDecoration(borderRadius: BorderRadius.circular(8), color: context.primary),
                    height: 50,
                    width: context.width * .1,
                    child: Center(
                      child: state.createProductStatus.isLoading
                          ? const CircularProgressIndicator.adaptive(backgroundColor: Colors.white)
                          : Text(
                              'Сохранить',
                              maxLines: 2,
                              style: TextStyle(fontSize: 13, color: context.onPrimary),
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
