import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hoomo_pos/core/extensions/context.dart';
import 'package:hoomo_pos/core/extensions/edge_insets_extensions.dart';
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
              BlocConsumer<SearchBloc, SearchState>(
                listener: (context, state) async {
                  if (!state.status.isSuccess) return;
                  await showDialog(
                    context: context,
                    builder: (context) => AlertDialog(
                      title: const Text('Успешно'),
                      content: const Text(''),
                      actions: [
                        TextButton(
                          onPressed: () => context
                            ..pop()
                            ..searchBloc.add(SearchRemoteTextChanged('')),
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
                      context.searchBloc.add(
                        AddProductEvent(
                          AddProductRequest(
                            cid: const Uuid().v4(),
                            title: cubit.titleController.text,
                            vendorCode: cubit.codeController.text,
                            quantity: int.tryParse(cubit.quantityController.text) ?? 0,
                            purchasePrice: cubit.incomeController.text,
                            barcode: cubit.barcodeController.text.isNotEmpty ? [cubit.barcodeController.text] : null,
                            price: cubit.sellController.text,
                            categoryId: cubit.state.categoryId,
                          ),
                        ),
                      );
                    } else {
                      context.searchBloc.add(
                        PutProduct(
                          AddProductRequest(
                            cid: const Uuid().v4(),
                            title: cubit.titleController.text,
                            vendorCode: cubit.codeController.text,
                            quantity: int.tryParse(cubit.quantityController.text) ?? 0,
                            purchasePrice: cubit.incomeController.text,
                            barcode: cubit.barcodeController.text.isNotEmpty ? [cubit.barcodeController.text] : null,
                            price: cubit.sellController.text,
                            categoryId: context.searchBloc.state.request?.categoryId,
                          ),
                          product!.id,
                          context,
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
                      child: Text(
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
