import 'dart:io' show File;

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hoomo_pos/core/extensions/context.dart';
import 'package:hoomo_pos/core/extensions/null_extension.dart';
import 'package:hoomo_pos/core/styles/colors.dart';
import 'package:hoomo_pos/core/styles/text_style.dart';
import 'package:hoomo_pos/core/widgets/text_field.dart';
import 'package:hoomo_pos/data/dtos/category/category_dto.dart';
import 'package:hoomo_pos/presentation/desktop/dialogs/category/bloc/category_bloc.dart';
import 'package:image_picker/image_picker.dart';
import '../../../../../../../core/constants/app_utils.dart';
import '../../../../../../../core/widgets/custom_square_icon_btn.dart';

class CreateCategoryDialog extends StatefulWidget {
  const CreateCategoryDialog({
    super.key,
    this.category,
  });

  final CategoryDto? category;

  @override
  State<CreateCategoryDialog> createState() => _CreateCategoryState();
}

class _CreateCategoryState extends State<CreateCategoryDialog> {
  CategoryDto? get category => widget.category;
  bool? _hasImage;
  File? _imageFile;
  late final TextEditingController _nameController;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: category?.name);
    _hasImage = category?.image.isNotEmpty;
  }

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  bool get _hasChanges =>
      (_nameController.text.trim().isNotEmpty && _nameController.text != category?.name) ||
      _imageFile.isNotNull ||
      _hasImage == false;

  @override
  Widget build(
    BuildContext context,
  ) =>
      AlertDialog(
        shape: const RoundedRectangleBorder(borderRadius: AppUtils.kBorderRadius12),
        contentPadding: AppUtils.kPaddingAll24,
        content: SizedBox(
          width: context.width * .3,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              /// header
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  /// title
                  const Text(
                    'Создания категории',
                    style: AppTextStyles.boldType18,
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

              /// content
              AppUtils.kGap24,
              Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  /// upload image button
                  if (_hasImage == true)
                    ClipRRect(
                      borderRadius: AppUtils.kBorderRadius12,
                      child: Container(
                        color: Colors.grey,
                        width: 150,
                        height: 150,
                        child: Stack(
                          children: [
                            Positioned.fill(
                              child: _imageFile.isNotNull
                                  ? Image.file(_imageFile!, fit: BoxFit.cover)
                                  : Image.network(category!.imageLink, fit: BoxFit.cover),
                            ),
                            Positioned(
                              top: 6,
                              right: 6,
                              child: IconButton(
                                style: IconButton.styleFrom(
                                  backgroundColor: Colors.white30,
                                  visualDensity: VisualDensity.compact,
                                ),
                                onPressed: _delete,
                                icon: const Icon(Icons.delete, color: Colors.white, size: 16),
                              ),
                            ),
                          ],
                        ),
                      ),
                    )
                  else
                    OutlinedButton(
                      style: OutlinedButton.styleFrom(
                        shape: const RoundedRectangleBorder(borderRadius: AppUtils.kBorderRadius12),
                        fixedSize: const Size(150, 150),
                        side: BorderSide(color: Colors.grey.shade300),
                        overlayColor: Colors.grey,
                        padding: EdgeInsets.zero,
                      ),
                      onPressed: _pickImage,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.image_outlined,
                            color: context.theme.disabledColor,
                            size: 30,
                          ),
                          AppUtils.kGap6,
                          Text(
                            'Upload image',
                            style: AppTextStyles.rType16.copyWith(
                              fontWeight: FontWeight.w500,
                              color: context.theme.unselectedWidgetColor,
                            ),
                          ),
                        ],
                      ),
                    ),

                  ///
                  AppUtils.kGap24,
                  AppTextField(
                    label: 'Название',
                    enabledBorderWith: 1,
                    enabledBorderColor: AppColors.stroke,
                    focusedBorderColor: AppColors.stroke,
                    focusedBorderWith: 1,
                    fieldController: _nameController,
                  ),

                  /// button
                  AppUtils.kGap24,
                  BlocConsumer<CategoryBloc, CategoryState>(
                    listenWhen: (p, c) => p.createCategoryStatus != c.createCategoryStatus,
                    listener: (_, state) {
                      if (state.createCategoryStatus.isSuccess || state.createCategoryStatus.isError) {
                        context.pop(state.createCategoryStatus.isSuccess);
                      }
                    },
                    buildWhen: (p, c) => p.createCategoryStatus != c.createCategoryStatus,
                    builder: (context, state) => ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primary800,
                        minimumSize: const Size.fromHeight(50),
                      ),
                      onPressed: () {
                        if (!_hasChanges) {
                          context.pop();
                          return;
                        }
                        if ((category?.cid ?? '').isNotEmpty) {
                          context.categoryBloc.add(UpdateCategoryEvent(
                            categoryCid: category!.cid!,
                            name: _nameController.text,
                            imageFile: _imageFile,
                            deleteImage: _hasImage == false,
                          ));
                        } else {
                          context.categoryBloc.add(CreateCategoryEvent(
                            name: _nameController.text,
                            imageFile: _imageFile,
                          ));
                        }
                      },
                      child: state.createCategoryStatus.isLoading
                          ? const CircularProgressIndicator.adaptive(backgroundColor: Colors.white)
                          : const Text(
                              'Создать категорию',
                              style: AppTextStyles.boldType16,
                            ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      );

  Future<void> _pickImage() async {
    try {
      final file = await ImagePicker().pickMedia();
      if (file.isNotNull) {
        _imageFile = File(file!.path);
        _hasImage = true;
        setState(() {});
      }
    } catch (e) {
      ///
    }
  }

  void _delete() {
    _imageFile = null;
    _hasImage = false;
    setState(() {});
  }
}
