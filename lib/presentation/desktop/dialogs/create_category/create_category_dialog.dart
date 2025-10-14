import 'package:flutter/material.dart';
import 'package:hoomo_pos/core/extensions/context.dart';
import 'package:hoomo_pos/core/styles/colors.dart';
import 'package:hoomo_pos/core/styles/text_style.dart';
import 'package:hoomo_pos/core/widgets/text_field.dart';
import 'package:hoomo_pos/data/dtos/category/create_category_request.dart';
import 'package:hoomo_pos/presentation/desktop/dialogs/category/bloc/category_bloc.dart';
import 'package:uuid/uuid.dart';
import '../../../../core/widgets/custom_square_icon_btn.dart';
import '../../../../data/dtos/product_param_dto.dart';

class CreateCategoryDialog extends StatefulWidget {
  const CreateCategoryDialog({
    super.key,
    this.categoryDto,
  });

  final ProductParamDto? categoryDto;

  @override
  State<CreateCategoryDialog> createState() => _CreateCategoryState();
}

class _CreateCategoryState extends State<CreateCategoryDialog> {
  @override
  Widget build(
    BuildContext context,
  ) {
    final nameController = TextEditingController();
    return Material(
      borderRadius: BorderRadius.circular(12),
      child: SizedBox(
        width: context.width * 0.4,
        height: context.height * 0.5,
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  /// title
                  const Padding(
                    padding: EdgeInsets.all(12),
                    child: Text('Создания категории', style: AppTextStyles.boldType18),
                  ),

                  /// close button
                  CustomSquareIconBtn(
                    Icons.close,
                    size: 48,
                    darkenColors: true,
                    backgrounColor: AppColors.error100,
                    iconColor: AppColors.error600,
                    onTap: () => context.pop(),
                  ),
                ],
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(10, 50, 10, 10),
                child: AppTextField(
                  width: 250,
                  label: 'Название',
                  enabledBorderWith: 1,
                  enabledBorderColor: AppColors.stroke,
                  focusedBorderColor: AppColors.stroke,
                  focusedBorderWith: 1,
                  fieldController: nameController,
                ),
              ),
              Container(
                height: 50,
                width: 250,
                margin: const EdgeInsets.all(8),
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary800,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  onPressed: () {
                    context.categoryBloc.add(CreateCategory(
                      CreateCategoryRequest(
                        name: nameController.text,
                        cid: const Uuid().v4(),
                        active: true,
                      ),
                    ));
                    context.pop(context);
                  },
                  child: const Text(
                    'Создать категорию',
                    style: AppTextStyles.boldType16,
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
