import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hoomo_pos/core/extensions/context.dart';
import 'package:hoomo_pos/core/styles/colors.dart';
import 'package:hoomo_pos/core/styles/text_style.dart';
import 'package:hoomo_pos/core/widgets/text_field.dart';
import 'package:hoomo_pos/data/dtos/category/create_category_request.dart';
import 'package:hoomo_pos/data/dtos/product_dto.dart';
import 'package:hoomo_pos/presentation/desktop/dialogs/category/bloc/category_bloc.dart';
import 'package:uuid/uuid.dart';
import '../../../../core/constants/spaces.dart';
import '../../../../data/dtos/product_param_dto.dart';
import '../../screens/search/cubit/search_bloc.dart';

class ExposrPriceDialog extends StatefulWidget {
  const ExposrPriceDialog({super.key, this.product});

  final ProductDto? product;

  @override
  State<ExposrPriceDialog> createState() => _CreateCategoryState();
}

class _CreateCategoryState extends State<ExposrPriceDialog> {
  @override
  Widget build(BuildContext context) {
    final nameController = TextEditingController();
    final currencyFormatter = NumberFormat.currency(
      locale: 'ru_RU',
      symbol: '',
      decimalDigits: 0,
    );
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
                  Padding(
                    padding: const EdgeInsets.all(4),
                    child: Text(
                      " Цена: ${currencyFormatter.format(widget.product!.price).replaceAll('.', ' ')}",
                      style: const TextStyle(
                          fontSize: 20,
                          color: AppColors.primary500,
                          fontWeight: FontWeight.bold),
                    ),
                  ),
                  AppSpace.horizontal24,
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: SizedBox(
                      height: 50,
                      width: 50,
                      child: DecoratedBox(
                        decoration: BoxDecoration(
                          color: AppColors.error100,
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: IconButton(
                          onPressed: () {
                            Navigator.pop(context);
                          },
                          style: IconButton.styleFrom(
                              overlayColor: AppColors.error500),
                          icon: Icon(Icons.close, color: AppColors.error600),
                        ),
                      ),
                    ),
                  )
                ],
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(10, 50, 10, 10),
                child: AppTextField(
                  width: 250,
                  label: "Укажите количество",
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
                    context.read<SearchBloc>().add(ExportProductPrice(
                          productId: widget.product!.id,
                          quantity: int.parse(nameController.text),
                        ));
                    Navigator.pop(context);
                  },
                  child: Text(
                    "Скачать ценник",
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
