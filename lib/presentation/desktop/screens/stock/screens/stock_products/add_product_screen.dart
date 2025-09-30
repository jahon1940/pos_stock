import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hoomo_pos/app/di.dart';
import 'package:hoomo_pos/core/constants/spaces.dart';
import 'package:hoomo_pos/core/enums/states.dart';
import 'package:hoomo_pos/core/extensions/context.dart';
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
import 'widgets/images.dart';
import 'widgets/pricing.dart';

@RoutePage()
class AddProductScreen extends HookWidget implements AutoRouteWrapper {
  const AddProductScreen({
    super.key,
    this.product,
    this.organization,
    this.stock,
    this.isDialog,
  });

  final ProductDto? product;
  final CompanyDto? organization;
  final StockDto? stock;
  final bool? isDialog;

  @override
  Widget build(BuildContext context) {
    useEffect(() {
      context.categoryBloc.add(GetCategory());
      return null;
    }, const []);
    final SearchBloc searchBloc = BlocProvider.of<SearchBloc>(context);
    final cubit = context.read<AddProductCubit>();
    ThemeData themeData = Theme.of(context);
    return Scaffold(
        backgroundColor: AppColors.softGrey,
        body: Padding(
          padding: const EdgeInsets.all(12),
          child: Column(
            children: [
              Container(
                decoration: BoxDecoration(
                  color: themeData.cardColor,
                  borderRadius: BorderRadius.circular(10),
                  boxShadow: [const BoxShadow(color: AppColors.stroke, blurRadius: 3)],
                ),
                height: 60,
                child: Row(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(4),
                      child: Container(
                          decoration: BoxDecoration(
                            color: AppColors.primary500,
                            borderRadius: BorderRadius.circular(10),
                            boxShadow: [const BoxShadow(color: AppColors.stroke, blurRadius: 3)],
                          ),
                          child: InkWell(
                            onTap: () => isDialog == true ? Navigator.pop(context) : router.back(),
                            child: const Padding(
                              padding: EdgeInsets.fromLTRB(16, 12, 10, 12),
                              child: Icon(
                                Icons.arrow_back_ios,
                                color: Colors.white,
                              ),
                            ),
                          )),
                    ),
                    AppSpace.horizontal12,
                    Text('Наменклатура : ${product?.title ?? ""} ${product?.vendorCode ?? ""}',
                        style: AppTextStyles.boldType14.copyWith(fontWeight: FontWeight.w600)),
                  ],
                ),
              ),
              AppSpace.vertical12,
              Expanded(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Expanded(
                      child: ListView(
                        padding: const EdgeInsets.fromLTRB(24, 10, 24, 24),
                        children: [
                          Details1C(product, isDialog: isDialog),
                          AppSpace.vertical24,
                          // About(),
                          // AppSpace.vertical24,
                          const Pricing(),
                          AppSpace.vertical24,
                          // AddCategories(),
                          // AppSpace.vertical24,
                          // Characteristics(),
                          // AppSpace.vertical24,
                        ],
                      ),
                    ),
                    SizedBox(
                      height: double.maxFinite,
                      width: 360,
                      child: ListView(
                        shrinkWrap: true,
                        padding: const EdgeInsets.fromLTRB(0, 11, 24, 24),
                        children: const [
                          Images(),
                          // AppSpace.vertical24,
                          // ProductPublicationStatus()
                        ],
                      ),
                    )
                  ],
                ),
              ),
            ],
          ),
        ),
        bottomNavigationBar: Padding(
          padding: const EdgeInsets.all(12),
          child: CustomBox(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                BlocConsumer<SearchBloc, SearchState>(
                  listener: (context, state) async {
                    if (state.status != StateStatus.success) return;

                    await showDialog(
                      context: context,
                      builder: (context) => AlertDialog(
                        title: const Text("Успешно"),
                        content: const Text(""),
                        actions: [
                          TextButton(
                            onPressed: () {
                              Navigator.of(context).pop();
                              context.read<SearchBloc>().add(SearchRemoteTextChanged(''));
                            },
                            child: const Text("ОК"),
                          ),
                        ],
                      ),
                    );

                    Navigator.pop(context, cubit.barcodeController.text);
                  },
                  builder: (context, state) {
                    return InkWell(
                      onTap: () {
                        product == null
                            ? searchBloc.add(AddProduct(
                                AddProductRequest(
                                  cid: const Uuid().v4(),
                                  title: cubit.titleController.text,
                                  vendorCode: cubit.codeController.text,
                                  quantity: int.tryParse(cubit.quantityController.text) ?? 0,
                                  purchasePrice: cubit.incomeController.text,
                                  barcode:
                                      cubit.barcodeController.text.isNotEmpty ? [cubit.barcodeController.text] : null,
                                  price: cubit.sellController.text,
                                  categoryId: cubit.state.categoryId,
                                ),
                                context))
                            : searchBloc.add(PutProduct(
                                AddProductRequest(
                                  cid: const Uuid().v4(),
                                  title: cubit.titleController.text,
                                  vendorCode: cubit.codeController.text,
                                  quantity: int.tryParse(cubit.quantityController.text) ?? 0,
                                  purchasePrice: cubit.incomeController.text,
                                  barcode:
                                      cubit.barcodeController.text.isNotEmpty ? [cubit.barcodeController.text] : null,
                                  price: cubit.sellController.text,
                                  categoryId: searchBloc.state.request?.categoryId,
                                ),
                                product!.id,
                                context));
                      },
                      child: Container(
                        padding: const EdgeInsets.all(5),
                        decoration: BoxDecoration(borderRadius: BorderRadius.circular(8), color: context.primary),
                        height: 50,
                        width: context.width * .1,
                        child: Center(
                          child: Text(
                            "Сохранить",
                            maxLines: 2,
                            style: TextStyle(fontSize: 13, color: context.onPrimary),
                          ),
                        ),
                      ),
                    );
                  },
                )
              ],
            ),
          ),
        ) /*const ProductNavbar()*/
        );
  }

  @override
  Widget wrappedRoute(BuildContext context) {
    return BlocProvider(
      create: (context) => getIt<AddProductCubit>()..init(product),
      child: this,
    );
  }
}
