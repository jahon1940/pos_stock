import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hoomo_pos/core/constants/spaces.dart';
import 'package:hoomo_pos/core/extensions/context.dart';

import '../../../../../../../../../core/styles/text_style.dart';
import '../../../../../../../../../core/widgets/custom_box.dart';
import '../../../../../../../../../core/widgets/text_field.dart';

class Characteristics extends HookWidget {
  const Characteristics({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    // final subCategoryController = useTextEditingController();
    // final ruDescriptionController = useTextEditingController();
    // final uzTitleController = useTextEditingController();
    List<TextEditingController> charactersDescriptionController = [TextEditingController()];
    List<TextEditingController> charactersController = [TextEditingController()];
    return CustomBox(
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text('Характеристики', style: AppTextStyles.boldType14),
              Container(
                padding: const EdgeInsets.all(5),
                decoration: BoxDecoration(borderRadius: BorderRadius.circular(8), color: context.primary),
                height: 50,
                width: context.width * .1,
                child: Center(
                  child: Text(
                    "Добавить",
                    maxLines: 2,
                    style: TextStyle(fontSize: 13, color: context.onPrimary),
                  ),
                ),
              )
            ],
          ),
          AppSpace.vertical24,
          ListView.separated(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: charactersController.length,
            separatorBuilder: (context, index) => AppSpace.vertical24,
            itemBuilder: (context, index) => Row(
              children: [
                Expanded(
                  child: AppTextField(
                    fieldController: charactersController[index],
                    contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 18),
                    label: ' Название Характеристики ${index + 1}',
                    alignLabelWithHint: true,
                    style: AppTextStyles.boldType14.copyWith(fontWeight: FontWeight.w400),
                  ),
                ),
                AppSpace.horizontal12,
                Expanded(
                  child: AppTextField(
                    fieldController: charactersDescriptionController[index],
                    contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 18),
                    label: 'Описание Характеристики ${index + 1}',
                    alignLabelWithHint: true,
                    style: AppTextStyles.boldType14.copyWith(fontWeight: FontWeight.w400),
                  ),
                ),
                if (index != 0) ...[
                  AppSpace.horizontal12,
                  IconButton(icon: Icon(Icons.close), onPressed: () {}),
                ]
              ],
            ),
          )
        ],
      ),
    );
  }
}
