import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hoomo_pos/core/constants/app_utils.dart';
import 'package:hoomo_pos/core/extensions/context.dart';
import 'package:hoomo_pos/data/dtos/product_dto.dart';

import '../../../../../../app/di.dart';
import '../../../../../../core/styles/text_style.dart';
import '../../../../dialogs/category/bloc/category_bloc.dart';
import '../../../../dialogs/search/cubit/fast_search_bloc.dart';
import '../../../../dialogs/search/search_dialog.dart';
import '../../widgets/back_button_widget.dart';
import 'widgets/create_product_navbar.dart';
import 'widgets/product_1c_details.dart';
import 'widgets/product_images_widget.dart';
import 'widgets/product_pricing_widget.dart';

@RoutePage()
class CreateProductScreen extends HookWidget {
  const CreateProductScreen({
    super.key,
    this.product,
    this.isDialogOpen,
  });

  final ProductDto? product;
  final ValueNotifier<bool>? isDialogOpen;

  @override
  Widget build(
    BuildContext context,
  ) {
    useEffect(() {
      context.categoryBloc.add(const GetCategoryEvent());
      context.brandBloc.getBrands();
      context.productBloc.getProductDetailAndSet(product);
      return null;
    }, const []);
    final productName = '${product?.title ?? ""} ${product?.vendorCode ?? ""}'.trim();
    return Scaffold(
      body: Padding(
        padding: AppUtils.kPaddingAll10,
        child: Column(
          children: [
            /// header
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
                  const BackButtonWidget(),
                  AppUtils.kGap6,

                  /// label
                  AppUtils.kGap6,
                  Text(
                    'Номенклатура${productName.isNotEmpty ? ':  $productName' : ''}',
                    textAlign: TextAlign.start,
                    style: AppTextStyles.boldType14.copyWith(fontWeight: FontWeight.w600),
                  ),

                  /// button
                  const Spacer(),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      fixedSize: Size(context.width * .12, 48),
                      padding: EdgeInsets.zero,
                    ),
                    onPressed: () async => showDialog(
                      context: context,
                      builder: (context) => BlocProvider(
                        create: (context) => getIt<FastSearchBloc>()..add(SearchInit(false)),
                        child: const SearchDialog(
                          isDialog: true,
                        ),
                      ),
                    ),
                    child: const Text(
                      'Добавить из справочника',
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      textAlign: TextAlign.center,
                      style: TextStyle(fontSize: 11),
                    ),
                  ),
                ],
              ),
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
                        Expanded(child: Product1CDetails(product)),
                        AppUtils.kMainObjectsGap,
                        const ProductPricingWidget(),
                        // ProductAbout(),
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
      bottomNavigationBar: CreateProductNavbar(product: product),
    );
  }
}
