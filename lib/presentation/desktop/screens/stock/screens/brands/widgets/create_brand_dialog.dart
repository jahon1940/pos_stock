import 'dart:io' show File;

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hoomo_pos/core/constants/app_utils.dart';
import 'package:hoomo_pos/core/extensions/context.dart';
import 'package:hoomo_pos/core/extensions/null_extension.dart';
import 'package:hoomo_pos/core/widgets/custom_square_icon_btn.dart';
import 'package:hoomo_pos/data/dtos/brand/brand_dto.dart';
import 'package:image_picker/image_picker.dart';

import '../../../../../../../core/styles/colors.dart';
import '../../../../../../../core/styles/text_style.dart';
import '../../../../../../../core/widgets/text_field.dart';
import '../cubit/brand_cubit.dart';

class CreateBrandDialog extends StatefulWidget {
  const CreateBrandDialog({
    super.key,
    this.brand,
  });

  final BrandDto? brand;

  @override
  State<CreateBrandDialog> createState() => _CreateBrandDialogState();
}

class _CreateBrandDialogState extends State<CreateBrandDialog> {
  BrandDto? get brand => widget.brand;
  File? _imageFile;
  late final TextEditingController _nameController;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: brand?.name);
  }

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

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
                    'Создания бренд',
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
                  if (_imageFile.isNotNull)
                    ClipRRect(
                      borderRadius: AppUtils.kBorderRadius12,
                      child: Container(
                        color: Colors.grey,
                        width: 150,
                        height: 150,
                        child: Stack(
                          children: [
                            Positioned.fill(
                              child: Image.file(_imageFile!, fit: BoxFit.cover),
                            ),
                            if (_imageFile.isNotNull)
                              Positioned(
                                top: 6,
                                right: 6,
                                child: IconButton(
                                  style: IconButton.styleFrom(
                                    backgroundColor: Colors.white30,
                                    visualDensity: VisualDensity.compact,
                                  ),
                                  onPressed: _delete,
                                  icon: const Icon(
                                    Icons.delete,
                                    color: Colors.white,
                                    size: 16,
                                  ),
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
                  BlocConsumer<BrandCubit, BrandState>(
                    listenWhen: (p, c) => p.createBrandStatus != c.createBrandStatus,
                    listener: (_, state) {
                      if (state.createBrandStatus.isSuccess || state.createBrandStatus.isError) {
                        context.pop(state.createBrandStatus.isSuccess);
                      }
                    },
                    buildWhen: (p, c) => p.createBrandStatus != c.createBrandStatus,
                    builder: (context, state) => ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primary800,
                        minimumSize: const Size.fromHeight(50),
                      ),
                      onPressed: () {
                        if (_nameController.text == brand?.name) {
                          context.pop();
                        }
                        if ((brand?.cid ?? '').isNotEmpty) {
                          context.brandBloc.updateBrand(
                            brandCid: brand!.cid!,
                            name: _nameController.text,
                          );
                        } else {
                          context.brandBloc.createBrand(
                            name: _nameController.text,
                            imageFile: _imageFile,
                          );
                        }
                      },
                      child: state.createBrandStatus.isLoading
                          ? const CircularProgressIndicator.adaptive(backgroundColor: Colors.white)
                          : const Text(
                              'Создать бренд',
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
        setState(() {});
      }
    } catch (e) {
      debugPrint('asklfjdasdf image pick error $e');
    }
  }

  void _delete() {
    _imageFile = null;
    setState(() {});
  }
}
