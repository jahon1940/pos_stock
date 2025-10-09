import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hoomo_pos/app/di.dart';
import 'package:hoomo_pos/core/constants/app_utils.dart';
import 'package:hoomo_pos/core/extensions/context.dart';
import 'package:hoomo_pos/data/dtos/product_dto.dart';
import 'package:provider/provider.dart';

import '../../../../../../../../data/dtos/company/company_dto.dart';
import '../../../../../../../../data/dtos/stock_dto.dart';
import '../../../../dialogs/category/bloc/category_bloc.dart';
import '../../widgets/page_title_widget.dart';
import 'cubit/add_product_cubit.dart';
import 'widgets/add_product_navbar.dart';
import 'widgets/details_1c.dart';
import 'widgets/pricing.dart';
import 'widgets/product_images_widget.dart';

@RoutePage()
class AddProductScreen extends HookWidget {
  const AddProductScreen({
    super.key,
    this.stock,
    this.organization,
    this.product,
    this.isDialog = false,
  });

  final StockDto? stock;
  final CompanyDto? organization;
  final ProductDto? product;
  final bool isDialog;

  @override
  Widget build(
    BuildContext context,
  ) {
    useEffect(() {
      context.categoryBloc.add(GetCategory());
      return null;
    }, const []);
    return Provider<AddProductCubit>(
      create: (context) => getIt<AddProductCubit>()..init(product),
      builder: (blocContext, _) => Scaffold(
        body: Padding(
          padding: AppUtils.kPaddingAll10,
          child: Column(
            children: [
              /// header
              PageTitleWidget(
                label: 'Наменклатура : ${product?.title ?? ""} ${product?.vendorCode ?? ""}',
                canPop: true,
                isMain: false,
              ),

              /// body
              AppUtils.kMainObjectsGap,
              Expanded(
                child: Row(
                  spacing: AppUtils.mainSpacing,
                  crossAxisAlignment: CrossAxisAlignment.start,
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
        bottomNavigationBar: AddProductNavbar(product: product),
      ),
    );
  }
}
