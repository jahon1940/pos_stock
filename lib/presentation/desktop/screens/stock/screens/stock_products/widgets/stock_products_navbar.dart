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

  static const _elementsQuantity = 7;

  @override
  Widget build(
    BuildContext context,
  ) =>
      BlocBuilder<ProductCubit, ProductState>(
        builder: (context, state) {
          final data = state.productPageData;
          return CustomBox(
            padding: AppUtils.kPaddingAll12,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              spacing: 10,
              children: [
                /// previous
                _button2(
                  context,
                  onTap: data.isFirstPage ? null : () => _get(context, data.pageNumber - 1),
                  child: const Row(
                    spacing: 4,
                    children: [
                      Icon(Icons.arrow_back_ios_rounded, size: 12),
                      Text('Назад'),
                    ],
                  ),
                ),

                /// number buttons
                ...List.generate(
                  min(_elementsQuantity, data.totalPageQuantity),
                  (index) {
                    final isSelected = data.pageNumber == index + 1;
                    if (index == _elementsQuantity - 1) {
                      /// if is last element
                      return _button(
                        context,
                        isSelected: data.isLastPage,
                        onTap: () => data.isLastPage ? null : _get(context, data.totalPageQuantity),
                        label: '${data.totalPageQuantity}',
                      );
                    } else if (index == _elementsQuantity - 2) {
                      /// if element is before the last element
                      if (_elementsQuantity == data.totalPageQuantity) {
                        return _button(
                          context,
                          isSelected: data.isBeforeLastPage,
                          onTap: () => data.isBeforeLastPage ? null : _get(context, data.totalPageQuantity - 1),
                          label: '${data.totalPageQuantity - 1}',
                        );
                      }
                      return const Text('...');
                    }
                    return _button(
                      context,
                      isSelected: isSelected,
                      onTap: () => isSelected ? null : context.productBloc.getPageRelatedProducts(page: index + 1),
                      label: '${index + 1}',
                    );
                  },
                ),

                /// next
                _button2(
                  context,
                  onTap: data.isLastPage ? null : () => _get(context, data.pageNumber + 1),
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
          );
        },
      );

  void _get(BuildContext context, int page) => context.productBloc.getPageRelatedProducts(page: page);

  Widget _button(
    BuildContext context, {
    required bool isSelected,
    required VoidCallback onTap,
    required String label,
  }) =>
      _button2(
        context,
        isSelected: isSelected,
        onTap: onTap,
        child: Text(
          label,
          style: TextStyle(
            fontSize: 13,
            color: isSelected ? context.onPrimary : null,
          ),
        ),
      );

  Widget _button2(
    BuildContext context, {
    bool isSelected = false,
    required VoidCallback? onTap,
    required Widget child,
  }) =>
      Opacity(
        opacity: onTap == null ? .3 : 1,
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
