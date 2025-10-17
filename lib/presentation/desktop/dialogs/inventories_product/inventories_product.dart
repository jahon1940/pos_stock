import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hoomo_pos/core/constants/spaces.dart';
import 'package:hoomo_pos/core/extensions/context.dart';
import 'package:hoomo_pos/core/styles/colors.dart';

import '../../../../core/mixins/secure_storage_mixin.dart';
import '../../../../data/dtos/stock_dto.dart';
import '../../screens/search/cubit/search_bloc.dart';
import '../category/bloc/category_bloc.dart';

class InventoriesProductDialog extends HookWidget with SecureStorageMixin {
  InventoriesProductDialog(
    this.stock, {
    super.key,
  });

  final StockDto stock;

  @override
  Widget build(
    BuildContext context,
  ) {
    final categoryController = useTextEditingController();
    return Container(
      width: 400,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: context.theme.cardColor,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          AppSpace.vertical24,
          BlocBuilder<CategoryBloc, CategoryState>(
            builder: (context, state) {
              final categories = state.categories?.results ?? [];
              return Padding(
                padding: const EdgeInsets.all(3),
                child: Container(
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey),
                    borderRadius: BorderRadius.circular(13),
                  ),
                  child: DropdownMenu<int?>(
                    width: 220,
                    hintText: 'Выбор категории',
                    textStyle: const TextStyle(fontSize: 11),
                    controller: categoryController,
                    onSelected: (value) => context.searchBloc.add(SelectCategoryEvent(id: value)),
                    inputDecorationTheme: InputDecorationTheme(
                      hintStyle: const TextStyle(fontSize: 11),
                      isDense: true,
                      constraints: BoxConstraints.tight(const Size.fromHeight(35)),
                    ),
                    dropdownMenuEntries: [
                      const DropdownMenuEntry(
                        value: null,
                        label: 'Все категории',
                      ),
                      ...categories.map(
                        (e) => DropdownMenuEntry(value: e.id, label: e.name),
                      )
                    ],
                  ),
                ),
              );
            },
          ),
          AppSpace.vertical24,
          GestureDetector(
            onTap: () async {
              context.searchBloc.add(ExportInventoryProducts(id: stock.id));
              Navigator.pop(context);
            },
            child: Container(
              padding: const EdgeInsets.all(5),
              decoration: BoxDecoration(borderRadius: BorderRadius.circular(8), color: AppColors.primary500),
              height: 50,
              width: context.width * .12,
              child: Padding(
                padding: const EdgeInsets.fromLTRB(4, 0, 0, 0),
                child: Row(
                  children: [
                    const Icon(
                      Icons.download,
                      color: AppColors.white,
                      size: 16,
                    ),
                    const SizedBox(width: 6),
                    Text(
                      'Скачать номенклатуру',
                      maxLines: 2,
                      style: TextStyle(fontSize: 11, color: context.onPrimary),
                    ),
                  ],
                ),
              ),
            ),
          ),
          AppSpace.vertical24,
        ],
      ),
    );
  }
}
