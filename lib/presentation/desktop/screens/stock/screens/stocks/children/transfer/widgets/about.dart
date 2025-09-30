import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hoomo_pos/core/constants/spaces.dart';
import '../../../../../../../../../core/styles/text_style.dart';
import '../../../../../../../../../core/widgets/custom_box.dart';
import '../../../../../../../../../core/widgets/text_field.dart';

class About extends HookWidget {
  const About({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final ruTitleController = useTextEditingController();
    final ruDescriptionController = useTextEditingController();
    final uzTitleController = useTextEditingController();
    final uzDescriptionController = useTextEditingController();
    return CustomBox(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          const Text('О продукте', style: AppTextStyles.boldType14),
          AppSpace.vertical24,
          AppTextField(
            fieldController: ruTitleController,
            label: 'Название Продукта на Русском...',
            textInputType: TextInputType.text,
            contentPadding:
                const EdgeInsets.symmetric(horizontal: 16, vertical: 18),
            style:
                AppTextStyles.boldType14.copyWith(fontWeight: FontWeight.w400),
          ),
          AppSpace.vertical24,
          AppTextField(
            fieldController: ruDescriptionController,
            label: 'Описание Продукта на Русском...',
            textInputType: TextInputType.text,
            alignLabelWithHint: true,
            contentPadding:
                const EdgeInsets.symmetric(horizontal: 16, vertical: 18),
            maxLines: 12,
            style:
                AppTextStyles.boldType14.copyWith(fontWeight: FontWeight.w400),
          ),
          AppSpace.vertical24,
          AppTextField(
            fieldController: uzTitleController,
            label: 'Название Продукта на Узбекском...',
            textInputType: TextInputType.text,
            contentPadding:
                const EdgeInsets.symmetric(horizontal: 16, vertical: 18),
            style:
                AppTextStyles.boldType14.copyWith(fontWeight: FontWeight.w400),
          ),
          AppSpace.vertical24,
          AppTextField(
            fieldController: uzDescriptionController,
            label: 'Описание Продукта на Узбекском...',
            textInputType: TextInputType.text,
            alignLabelWithHint: true,
            contentPadding:
                const EdgeInsets.symmetric(horizontal: 16, vertical: 18),
            maxLines: 12,
            style:
                AppTextStyles.boldType14.copyWith(fontWeight: FontWeight.w400),
          ),
        ],
      ),
    );
  }
}
