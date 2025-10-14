import 'dart:io' show File;
import 'dart:math' show min;

import 'package:flutter/material.dart';
import 'package:hoomo_pos/core/extensions/context.dart';
import 'package:hoomo_pos/core/extensions/null_extension.dart';
import 'package:hoomo_pos/core/extensions/text_style_extension.dart';
import 'package:hoomo_pos/core/styles/text_style.dart';
import 'package:hoomo_pos/core/widgets/custom_box.dart';
import 'package:image_picker/image_picker.dart';

import '../../../../../../../core/constants/app_utils.dart';

class ProductImagesWidget extends StatefulWidget {
  const ProductImagesWidget({
    super.key,
  });

  @override
  State<ProductImagesWidget> createState() => _ProductImagesWidgetState();
}

class _ProductImagesWidgetState extends State<ProductImagesWidget> {
  final List<File> _images = [];
  File? _selectedItem;

  Future<void> _pickImage() async {
    try {
      final xfile = await ImagePicker().pickMedia();
      if (xfile.isNotNull) {
        final file = File(xfile!.path);
        for (final item in _images) {
          if (item.path == file.path) return;
        }
        if (_images.isEmpty) _selectedItem = file;
        _images.add(file);
        setState(() {});
      }
    } catch (e) {
      debugPrint('asklfjdasdf image pick error $e');
    }
  }

  void _delete() {
    if (_selectedItem.isNull) return;
    _images.removeWhere((item) => item.path == _selectedItem!.path);
    _selectedItem = _images.firstOrNull;
    setState(() {});
  }

  @override
  Widget build(
    BuildContext context,
  ) =>
      CustomBox(
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

            /// image or pick image button
            if (_selectedItem.isNotNull)
              ClipRRect(
                borderRadius: AppUtils.kBorderRadius12,
                child: Container(
                  color: Colors.grey,
                  width: 316,
                  height: 316,
                  child: Stack(
                    children: [
                      Positioned.fill(
                        child: Image.file(_selectedItem!, fit: BoxFit.cover),
                      ),
                      Positioned(
                        top: 12,
                        right: 12,
                        child: IconButton(
                          style: IconButton.styleFrom(backgroundColor: Colors.white30),
                          onPressed: _delete,
                          icon: const Icon(
                            Icons.delete,
                            color: Colors.white,
                            size: 24,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              )
            else
              _EmptyImageWidget(
                onTap: _pickImage,
              ),

            /// mini images
            if (_images.isNotEmpty) ...[
              AppUtils.kGap12,
              Row(
                spacing: AppUtils.kGap12.mainAxisExtent,
                children: List.generate(
                  min(4, _images.length + 1),
                  (index) {
                    final isLast = index == _images.length;
                    final file = isLast ? null : _images.elementAt(index);
                    final isSelected = file.isNotNull && file?.path == _selectedItem?.path;
                    return isLast
                        ? OutlinedButton(
                            style: OutlinedButton.styleFrom(
                              shape: const RoundedRectangleBorder(borderRadius: AppUtils.kBorderRadius12),
                              fixedSize: const Size(70, 70),
                              side: BorderSide(color: Colors.grey.shade300),
                              overlayColor: Colors.grey,
                              padding: EdgeInsets.zero,
                            ),
                            onPressed: _pickImage,
                            child: Icon(Icons.add_a_photo_outlined, color: Colors.grey.shade300),
                          )
                        : GestureDetector(
                            onTap: () => setState(() => _selectedItem = file),
                            child: Container(
                              height: 70,
                              width: 70,
                              decoration: BoxDecoration(
                                borderRadius: AppUtils.kBorderRadius12,
                                border: isSelected ? Border.all(color: context.primary, width: 3) : null,
                              ),
                              child: ClipRRect(
                                borderRadius: AppUtils.kBorderRadius8,
                                child: Image.file(
                                  file!,
                                  fit: BoxFit.cover,
                                ),
                              ),
                            ),
                          );
                  },
                ),
              ),
            ],
          ],
        ),
      );
}

class _EmptyImageWidget extends StatelessWidget {
  const _EmptyImageWidget({
    required this.onTap,
  });

  final VoidCallback onTap;

  @override
  Widget build(
    BuildContext context,
  ) =>
      OutlinedButton(
        style: OutlinedButton.styleFrom(
          shape: const RoundedRectangleBorder(borderRadius: AppUtils.kBorderRadius12),
          fixedSize: const Size(316, 316),
          side: BorderSide(color: Colors.grey.shade300),
          overlayColor: Colors.grey,
          padding: EdgeInsets.zero,
        ),
        onPressed: onTap,
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
      );
}
