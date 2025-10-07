import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hoomo_pos/app/di.dart';
import 'package:hoomo_pos/core/constants/app_utils.dart';
import 'package:hoomo_pos/core/extensions/context.dart';
import 'package:hoomo_pos/core/extensions/edge_insets_extensions.dart';
import 'package:hoomo_pos/core/widgets/custom_box.dart';
import 'package:hoomo_pos/data/dtos/add_product/add_product_request.dart';
import 'package:hoomo_pos/data/dtos/product_dto.dart';
import 'package:hoomo_pos/presentation/desktop/screens/search/cubit/search_bloc.dart';
import 'package:uuid/uuid.dart';

import '../../../../../../../../app/router.dart';
import '../../../../../../../../core/styles/colors.dart';
import '../../../../../../../../core/styles/text_style.dart';
import '../../../../../../../../data/dtos/company/company_dto.dart';
import '../../../../../../../../data/dtos/stock_dto.dart';
import '../../../../dialogs/category/bloc/category_bloc.dart';
import 'cubit/add_product_cubit.dart';
import 'widgets/details_1c.dart';
import 'widgets/pricing.dart';
import 'widgets/product_images_widget.dart';

@RoutePage()
class AddProductScreen extends HookWidget implements AutoRouteWrapper {
  const AddProductScreen({
    super.key,
    this.product,
    this.organization,
    this.stock,
    this.isDialog = false,
  });

  final ProductDto? product;
  final CompanyDto? organization;
  final StockDto? stock;
  final bool isDialog;

  @override
  Widget build(
    BuildContext context,
  ) {
    useEffect(() {
      context.categoryBloc.add(GetCategory());
      return null;
    }, const []);
    final cubit = context.addProductBloc;
    return Scaffold(
      body: Padding(
        padding: AppUtils.kPaddingAll10.withB0,
        child: Column(
          children: [
            /// title
            Container(
              width: double.infinity,
              height: 60,
              padding: AppUtils.kPaddingAll6,
              decoration: BoxDecoration(
                color: context.theme.cardColor,
                borderRadius: AppUtils.kBorderRadius12,
                boxShadow: [BoxShadow(color: context.theme.dividerColor, blurRadius: 3)],
              ),
              child: Row(
                children: [
                  /// back button
                  InkWell(
                    onTap: () => isDialog ? context.pop() : router.back(),
                    child: Container(
                      width: 48,
                      alignment: Alignment.center,
                      decoration: const BoxDecoration(
                        color: AppColors.primary500,
                        borderRadius: AppUtils.kBorderRadius12,
                        boxShadow: [BoxShadow(color: AppColors.stroke, blurRadius: 3)],
                      ),
                      child: const Icon(
                        Icons.arrow_back_ios_rounded,
                        color: Colors.white,
                      ),
                    ),
                  ),

                  /// label
                  AppUtils.kGap12,
                  Text(
                    'Наменклатура : ${product?.title ?? ""} ${product?.vendorCode ?? ""}',
                    style: AppTextStyles.boldType14.copyWith(fontWeight: FontWeight.w600),
                  ),
                ],
              ),
            ),

            /// body
            AppUtils.kMainObjectsGap,
            Expanded(
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                spacing: AppUtils.mainSpacing,
                children: [
                  Expanded(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Details1C(product, isDialog: isDialog),
                        AppUtils.kMainObjectsGap,
                        const Pricing(),
                        // About(),
                        // AddCategories(),
                        // Characteristics(),
                      ],
                    ),
                  ),
                  const ProductImagesWidget(),
                ],
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: Padding(
        padding: AppUtils.kPaddingAll10,
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
                  context.pop(cubit.barcodeController.text);
                },
                builder: (context, state) => InkWell(
                  onTap: () => product == null
                      ? context.searchBloc.add(AddProduct(
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
                          context))
                      : context.searchBloc.add(PutProduct(
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
                          context)),
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
              )
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget wrappedRoute(
    BuildContext context,
  ) =>
      BlocProvider(
        create: (context) => getIt<AddProductCubit>()..init(product),
        child: this,
      );
}
