import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hoomo_pos/core/constants/spaces.dart';
import 'package:hoomo_pos/core/styles/text_style.dart';
import 'package:hoomo_pos/core/widgets/custom_box.dart';

class AddCategories extends HookWidget {
  const AddCategories({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    // final subCategoryController = useTextEditingController();
    // final ruDescriptionController = useTextEditingController();
    // final uzTitleController = useTextEditingController();
    // final uzDescriptionController = useTextEditingController();
    final List<dynamic> selectedItems = [];
    return CustomBox(
      child: Column(
        children: [
          const Text('Категории', style: AppTextStyles.boldType14),
          AppSpace.vertical12,
          SizedBox(
              height: 55,
              child: InputDecorator(
                  decoration: const InputDecoration(
                      border: OutlineInputBorder(borderRadius: BorderRadius.all(Radius.circular(10.0)))),
                  child: DropdownButtonHideUnderline(
                    child: DropdownButton<dynamic>(
                      borderRadius: BorderRadius.circular(10),
                      isExpanded: true,
                      underline: const SizedBox(),
                      hint: const Text("viewModel.product.brand?.name"),
                      value: "viewModel.brand",
                      items: selectedItems.map((dynamic brand) {
                        return DropdownMenuItem(
                          value: brand,
                          child: SizedBox(
                              width: 170,
                              child: Text(
                                brand?.name ?? '',
                                style: const TextStyle(fontSize: 14),
                              )),
                        );
                      }).toList(),
                      onChanged: (dynamic value) {
                        // viewModel.onChangeBrandDrawer(
                        //   value,
                        // );
                      },
                    ),
                  ))),
          AppSpace.vertical24,
          const Text('Бренд', style: AppTextStyles.boldType14),
          AppSpace.vertical12,
          SizedBox(
              height: 55,
              child: InputDecorator(
                  decoration: const InputDecoration(
                      border: OutlineInputBorder(borderRadius: BorderRadius.all(Radius.circular(10.0)))),
                  child: DropdownButtonHideUnderline(
                    child: DropdownButton<dynamic>(
                      borderRadius: BorderRadius.circular(10),
                      isExpanded: true,
                      underline: const SizedBox(),
                      hint: const Text("viewModel.product.brand?.name"),
                      value: "viewModel.brand",
                      items: selectedItems.map((dynamic brand) {
                        return DropdownMenuItem(
                          value: brand,
                          child: SizedBox(
                              width: 170,
                              child: Text(
                                brand?.name ?? '',
                                style: const TextStyle(fontSize: 14),
                              )),
                        );
                      }).toList(),
                      onChanged: (dynamic value) {
                        // viewModel.onChangeBrandDrawer(
                        //   value,
                        // );
                      },
                    ),
                  ))),
        ],
      ),
    );
  }
}
