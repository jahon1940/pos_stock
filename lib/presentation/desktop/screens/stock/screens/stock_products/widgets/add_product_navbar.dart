import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hoomo_pos/core/extensions/context.dart';
import 'package:hoomo_pos/core/extensions/edge_insets_extensions.dart';
import 'package:hoomo_pos/presentation/desktop/dialogs/operation_result_dialog.dart';
import 'package:hoomo_pos/presentation/desktop/screens/stock/screens/stock_products/cubit/add_product_cubit.dart';
import 'package:uuid/uuid.dart';

import '../../../../../../../core/constants/app_utils.dart';
import '../../../../../../../core/widgets/custom_box.dart';
import '../../../../../../../data/dtos/add_product/add_product_request.dart';
import '../../../../../../../data/dtos/product_dto.dart';
import '../../../../search/cubit/search_bloc.dart';

class AddProductNavbar extends StatelessWidget {
  const AddProductNavbar({
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
              BlocConsumer<AddProductCubit, AddProductState>(
                listener: (context, state) async {
                  if (state.createProductStatus.isError) {
                    await showDialog(
                      context: context,
                      builder: (context) => const OperationResultDialog(isError: true),
                    );
                  }
                  if (!state.createProductStatus.isSuccess) return;
                  await showDialog(
                    context: context,
                    builder: (context) => AlertDialog(
                      title: const Text('Успешно'),
                      content: const Text(''),
                      actions: [
                        TextButton(
                          onPressed: () => context
                            ..pop()
                            ..searchBloc.add(SearchRemoteTextChangedEvent('')),
                          child: const Text('ОК'),
                        ),
                      ],
                    ),
                  );
                  context.pop(context.addProductBloc.barcodeController.text);
                },
                builder: (context, state) => InkWell(
                  onTap: () {
                    final cubit = context.addProductBloc;
                    if (product == null) {
                      context.addProductBloc.createProductEvent(
                        onCreated: (stockId) => context.searchBloc.add(
                          SearchRemoteTextChangedEvent(
                            context.searchBloc.state.request?.title ?? '',
                            stockId: stockId,
                            clearPrevious: true,
                          ),
                        ),
                      );
                    } else {
                      context.searchBloc.add(
                        UpdateProductEvent(
                          context: context,
                          productId: product!.id,
                          putProductRequest: CreateProductRequest(
                            cid: const Uuid().v4(),
                            title: cubit.titleController.text,
                            vendorCode: cubit.codeController.text,
                            quantity: int.tryParse(cubit.quantityController.text) ?? 0,
                            purchasePrice: cubit.incomeController.text,
                            barcode: cubit.barcodeController.text.isNotEmpty ? [cubit.barcodeController.text] : null,
                            price: cubit.sellController.text,
                            categoryId: context.searchBloc.state.request?.categoryId,
                          ),
                        ),
                      );
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
