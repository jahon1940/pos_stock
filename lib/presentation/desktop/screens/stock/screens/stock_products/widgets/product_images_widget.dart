import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hoomo_pos/core/extensions/context.dart';
import 'package:hoomo_pos/core/extensions/text_style_extension.dart';
import 'package:hoomo_pos/core/styles/text_style.dart';
import 'package:hoomo_pos/core/widgets/custom_box.dart';

import '../../../../../../../core/constants/app_utils.dart';

class ProductImagesWidget extends HookWidget {
  const ProductImagesWidget({
    super.key,
  });

  @override
  Widget build(
    BuildContext context,
  ) {
    // int drag = 1;
    // final oneCTitleController = useTextEditingController();
    // final barcodeController = useTextEditingController();
    // final codeController = useTextEditingController();
    // final quantityController = useTextEditingController();
    // List<TextEditingController> charactersDescriptionController = [TextEditingController()];
    // List<TextEditingController> charactersController = [TextEditingController()];
    return CustomBox(
      padding: AppUtils.kPaddingAll12,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          AppUtils.kGap16,
          Text(
            'Фото продукта',
            style: AppTextStyles.boldType14.copyWith(fontWeight: FontWeight.w500, height: 1),
          ),
          AppUtils.kGap20,
          const _EmptyImageWidget(),
        ],
      ),
    );
  }
}

class _EmptyImageWidget extends StatelessWidget {
  const _EmptyImageWidget();

  @override
  Widget build(
    BuildContext context,
  ) =>
      Stack(
        alignment: Alignment.center,
        children: [
          Container(
            width: 314,
            height: 314,
            decoration: BoxDecoration(
              borderRadius: AppUtils.kBorderRadius12,
              border: Border.all(width: 2, color: Colors.grey.shade300),
            ),
          ),
          for (int i = 0; i < 30; i++)
            Positioned(
              top: i * 13 + 5,
              child: Container(
                width: 314,
                height: 5,
                color: context.cardColor,
              ),
            ),
          for (int i = 0; i < 30; i++)
            Positioned(
              left: i * 13 + 5,
              child: Container(
                width: 5,
                height: 314,
                color: context.cardColor,
              ),
            ),
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.image_outlined,
                color: context.theme.disabledColor,
                size: 30,
              ),
              AppUtils.kGap6,
              Text(
                'Upload your product image.',
                style: AppTextStyles.rType16.copyWith(
                  fontWeight: FontWeight.w500,
                  color: context.theme.unselectedWidgetColor,
                ),
              ),
              AppUtils.kGap6,
              Text(
                'Only PNG, JPG format allowed.',
                style: AppTextStyles.rType12.withColor(context.theme.disabledColor),
              ),
              AppUtils.kGap6,
              Text(
                '500x500 pixels are recommended.',
                style: AppTextStyles.rType12.withColor(context.theme.disabledColor),
              ),
            ],
          ),
        ],
      );
}

// DraggableFile(
//     size: const Size(314, 314),
//     onDragDone: viewModel.productImage,
//     networkImage: viewModel.product.gallery?.first),
// Wrap(
//   direction: Axis.horizontal,
//   spacing: 12,
//   children: List.generate(drag + 1, (index) {
//     return Padding(
//       padding: const EdgeInsets.only(bottom: 10),
//       child: Stack(
//         children: [
//           // DraggableFile(
//           //   networkImage: index == viewModel.drag
//           //       ? ""
//           //       : viewModel.gallery?[index],
//           //   textOne: '',
//           //   textTwo: 'Выберите\n     фото',
//           //   textThree: '',
//           //   size: const Size(90, 80),
//           //   onDragDone: viewModel.productImage,
//           // ),
//           drag == 0
//               ? const SizedBox()
//               : Positioned(
//                   top: 5,
//                   right: 5,
//                   child: CircleAvatar(
//                     backgroundColor: AppColors.error700,
//                     radius: 10,
//                     child: IconButton(
//                         icon: Icon(Icons.close), onPressed: () {}),
//                   )),
//         ],
//       ),
//     );
//   }),
// )
