import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hoomo_pos/core/extensions/context.dart';
import '../../../../../core/constants/spaces.dart';
import '../../../../../core/enums/states.dart';
import '../../../../../core/styles/colors.dart';
import '../../../../../core/styles/text_style.dart';
import '../../../../../core/widgets/custom_box.dart';
import '../../../../../core/widgets/product_table_item.dart';
import '../../../../../core/widgets/product_table_title.dart';
import '../../../../../core/widgets/text_field.dart';
import '../../../../../data/dtos/product_dto.dart';
import '../cubit/product_detail_cubit.dart';

class UpdateBarcode extends HookWidget {
  const UpdateBarcode(
    this.productDto, {
    super.key,
  });

  final ProductDto productDto;

  @override
  Widget build(BuildContext context) {
    final cubit = context.read<ProductDetailCubit>();
    ThemeData themeData = Theme.of(context);
    final scrollController = useScrollController();

    return BlocBuilder<ProductDetailCubit, ProductDetailState>(
        builder: (context, state) {
      if (state.status == StateStatus.loading) {
        return Center(child: CircularProgressIndicator());
      } else if (state.status == StateStatus.loaded) {
        return Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              width: context.width * .3,
              child: Column(
                children: [
                  AppSpace.vertical6,
                  TableTitleProducts(
                    fillColor: AppColors.stroke,
                    columnWidths: const {
                      0: FlexColumnWidth(4),
                    },
                    titles: [
                      "Штрих код",
                    ],
                  ),
                  if (state.productDetail?.barcode?.isEmpty ?? true)
                    Center(child: Text("Нет штрих кода")),
                  if (state.productDetail?.barcode?.isNotEmpty ?? false)
                    SizedBox(
                      height: context.height * .4,
                      child: ListView.separated(
                        shrinkWrap: true,
                        controller: scrollController,
                        padding: const EdgeInsets.all(8.0),
                        itemBuilder: (context, index) {
                          final String? barcode =
                              state.productDetail?.barcode![index];
                          return TableProductItem(
                            columnWidths: const {
                              0: FlexColumnWidth(4),
                            },
                            onTap: () {},
                            children: [
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Text("${barcode.toString()} "),
                              ),
                            ],
                          );
                        },
                        separatorBuilder: (context, index) =>
                            AppSpace.vertical12,
                        itemCount: state.productDetail?.barcode?.length ?? 0,
                      ),
                    )
                ],
              ),
            ),
            SizedBox(
              width: context.width * .3,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: CustomBox(
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        AppTextField(
                          prefix: Icon(
                            Icons.title,
                            color: context.primary,
                          ),
                          fieldController: cubit.titleController,
                          width: double.maxFinite,
                          contentPadding: const EdgeInsets.symmetric(
                              horizontal: 16, vertical: 18),
                          label: 'Ввидите новый штрих код...',
                          alignLabelWithHint: true,
                          maxLines: 1,
                          textInputType: TextInputType.text,
                          style: AppTextStyles.boldType14
                              .copyWith(fontWeight: FontWeight.w400),
                        ),
                        AppSpace.vertical48,
                        DecoratedBox(
                          decoration: BoxDecoration(
                            color: AppColors.success500,
                            borderRadius: BorderRadius.circular(6),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.fromLTRB(16, 8, 16, 8),
                            child: TextButton(
                              onPressed: () {
                                context
                                    .read<ProductDetailCubit>()
                                    .putBarcode(productDto.id);
                                cubit.titleController.clear();
                              },
                              child: Text(
                                "Добавить",
                                style: AppTextStyles.boldType16
                                    .copyWith(color: AppColors.white),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ],
        );
      }
      return Center(
          child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text("Ошибка загрузки"),
          Padding(
            padding: const EdgeInsets.all(10),
            child: DecoratedBox(
              decoration: BoxDecoration(
                color: AppColors.success500,
                borderRadius: BorderRadius.circular(6),
              ),
              child: Padding(
                padding: const EdgeInsets.all(5),
                child: TextButton(
                  onPressed: () {
                    context.read<ProductDetailCubit>().search(productDto.id);
                  },
                  child: Text(
                    "Обновить",
                    style: AppTextStyles.boldType16
                        .copyWith(color: AppColors.white),
                  ),
                ),
              ),
            ),
          ),
        ],
      ));
    });
  }
}
