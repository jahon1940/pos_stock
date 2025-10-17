import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hoomo_pos/core/constants/app_utils.dart';
import 'package:hoomo_pos/core/extensions/context.dart';
import 'package:hoomo_pos/data/dtos/product_dto.dart';

import '../../../../../../core/styles/text_style.dart';
import '../../../../dialogs/category/bloc/category_bloc.dart';
import '../../widgets/back_button_widget.dart';
import 'widgets/create_product_navbar.dart';
import 'widgets/details_1c.dart';
import 'widgets/pricing.dart';
import 'widgets/product_images_widget.dart';

@RoutePage()
class CreateProductScreen extends HookWidget {
  const CreateProductScreen({
    super.key,
    this.product,
    this.isDialog = false,
  });

  final ProductDto? product;
  final bool isDialog;

  @override
  Widget build(
    BuildContext context,
  ) {
    useEffect(() {
      context.categoryBloc.add(const GetCategoryEvent());
      context.productBloc.setDataToFields(product);
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
                    style: ElevatedButton.styleFrom(fixedSize: Size(context.width * .15, 48)),
                    onPressed: () => showDialog(
                      context: context,
                      builder: (_) => AlertDialog(
                        content: SizedBox(
                          width: context.width * .5,
                          height: context.width * .6,
                          child: const Center(child: BackButtonWidget()), // todo implement
                        ),
                      ),
                    ),
                    child: const Text('Добавить из справочника'),
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
      bottomNavigationBar: CreateProductNavbar(product: product),
    );
  }
}
