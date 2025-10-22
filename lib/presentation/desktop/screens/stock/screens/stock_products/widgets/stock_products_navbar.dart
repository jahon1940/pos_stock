import 'dart:math' show min;

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hoomo_pos/core/extensions/context.dart';

import '../../../../../../../core/constants/app_utils.dart';
import '../../../../../../../core/widgets/custom_box.dart';
import '../cubit/product_cubit.dart';

class StockProductsNavbar extends StatelessWidget {
  const StockProductsNavbar({
    super.key,
  });

  @override
  Widget build(
    BuildContext context,
  ) =>
      BlocBuilder<ProductCubit, ProductState>(
        builder: (context, state) => CustomBox(
          padding: AppUtils.kPaddingAll12,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            spacing: 10,
            children: [
              _button(
                context,
                isSelected: false,
                onTap: () => context.productBloc.getPageRelatedProducts(page: state.productPageData.pageNumber - 1),
                child: const Row(
                  spacing: 4,
                  children: [
                    Icon(Icons.arrow_back_ios_rounded, size: 12),
                    Text('Назад'),
                  ],
                ),
              ),
              ...List.generate(
                min(5, state.productPageData.totalPageQuantity),
                (index) {
                  final isSelected = state.productPageData.pageNumber == index + 1;
                  return _button(
                    context,
                    isSelected: isSelected,
                    onTap: () => context.productBloc.getPageRelatedProducts(page: index + 1),
                    child: Text(
                      '${index + 1}',
                      style: TextStyle(
                        fontSize: 13,
                        color: isSelected ? context.onPrimary : null,
                      ),
                    ),
                  );
                },
              ),
              _button(
                context,
                isSelected: false,
                onTap: () => context.productBloc.getPageRelatedProducts(page: state.productPageData.pageNumber + 1),
                child: const Row(
                  spacing: 4,
                  children: [
                    Text('Вперёд'),
                    Icon(Icons.arrow_forward_ios_rounded, size: 12),
                  ],
                ),
              ),
            ],
          ),
        ),
      );

  Widget _button(
    BuildContext context, {
    required bool isSelected,
    required VoidCallback onTap,
    required Widget child,
  }) =>
      SizedBox(
        child: Material(
          shape: RoundedRectangleBorder(
            borderRadius: AppUtils.kBorderRadius8,
            side: BorderSide(color: isSelected ? context.primary : Colors.grey),
          ),
          color: isSelected ? context.primary : context.onPrimary,
          child: InkWell(
            onTap: onTap,
            borderRadius: AppUtils.kBorderRadius8,
            child: Padding(
              padding: AppUtils.kPaddingH12V6,
              child: child,
            ),
          ),
        ),
      );
}
