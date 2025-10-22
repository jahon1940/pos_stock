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
            spacing: 12,
            children: [
              OutlinedButton(
                onPressed: () {},
                child: const Row(
                  spacing: 4,
                  children: [
                    Icon(
                      Icons.arrow_back_ios_rounded,
                      size: 12,
                    ),
                    Text('Назад'),
                  ],
                ),
              ),
              ...List.generate(
                min(5, state.productPageData.totalPageQuantity),
                (index) => OutlinedButton(
                  style: OutlinedButton.styleFrom(
                    fixedSize: const Size(20, 30),
                    padding: EdgeInsets.zero,
                    backgroundColor: state.productPageData.pageNumber == index + 1 ? context.primary : null,
                    foregroundColor: state.productPageData.pageNumber == index + 1 ? context.onPrimary : null,
                  ),
                  onPressed: () => context.productBloc.getPageRelatedProducts(page: index + 1),
                  child: Text(
                    '${index + 1}',
                    style: const TextStyle(height: 1),
                  ),
                ),
              ),
              OutlinedButton(
                // onPressed: () => context.productBloc.getMoreProducts(isRemote: true),
                onPressed: () {},
                child: const Row(
                  spacing: 4,
                  children: [
                    Text('Вперёд'),
                    Icon(
                      Icons.arrow_forward_ios_rounded,
                      size: 12,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      );
}
