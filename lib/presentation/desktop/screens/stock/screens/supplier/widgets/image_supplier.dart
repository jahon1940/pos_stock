import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hoomo_pos/core/constants/spaces.dart';
import 'package:hoomo_pos/core/extensions/context.dart';
import '../../../../../../../core/styles/text_style.dart';
import '../../../../../../../core/widgets/custom_box.dart';

class ImageSupplier extends HookWidget {
  const ImageSupplier({
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
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: SizedBox(
          height: context.height * .43,
          child: Column(
            children: [
              Text(
                'Фото',
                style: AppTextStyles.boldType14.copyWith(fontWeight: FontWeight.w500),
              ),
              AppSpace.vertical24,
              // DraggableFile(
              //     size: const Size(314, 314),
              //     onDragDone: viewModel.productImage,
              //     networkImage: viewModel.product.gallery?.first),
              AppSpace.vertical24,
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
            ],
          ),
        ),
      ),
    );
  }
}
